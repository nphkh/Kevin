//
//  HomeViewController.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "HomeViewController.h"
#import "MapAnnotation.h"
#import "ProfileViewController.h"

@interface HomeViewController ()
{
    CLLocationManager *locationManager;
    NSUserDefaults *userDefault;
}
@end

@implementation HomeViewController

@synthesize mapView,txtEvent;
@synthesize txtFieldCheck,scrlView;
@synthesize containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    scrlView.contentSize=containerView.frame.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    userDefault =[ NSUserDefaults standardUserDefaults];
    
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter=1500;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    [userDefault setObject:@"1" forKey:@"btnBackStatus"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [userDefault setObject:@"2" forKey:@"isRegistered"];
    txtEvent.text=[userDefault objectForKey:@"event"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method

- (IBAction)btnProfileAction:(id)sender {
   
    UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:vcHome animated:YES];
}

- (IBAction)btnSendAction:(id)sender {
    UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactViewController"];
    [self.navigationController pushViewController:vcHome animated:YES];
}

- (IBAction)btnMyContactAction:(id)sender {
    UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    [self.navigationController pushViewController:vcHome animated:YES];
}

- (IBAction)btnReceiveAction:(id)sender {
    UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveContactViewController"];
    [self.navigationController pushViewController:vcHome animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0)
{
    CLLocation *newLocation=[locations lastObject];
    if(newLocation.horizontalAccuracy <= 100.0f)
    {
        currentLocation=newLocation.coordinate;
        NSLog(@"%f",currentLocation.latitude);
        NSLog(@"%f",currentLocation.longitude);
        
        [userDefault setObject:[NSString stringWithFormat:@"%f", currentLocation.latitude] forKey:@"curLat"];
        [userDefault setObject:[NSString stringWithFormat:@"%f",currentLocation.longitude] forKey:@"cutLong"];
                
        [self currentLocationAdd];
    }
}

-(void)currentLocationAdd{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation, 7.5*1000,7.5*1000);
    
    MKCoordinateSpan span; // create a range of your view
    span.latitudeDelta = 0.5;  // span dimensions.  I have BASE_RADIUS defined as 0.0144927536 which is equivalent to 1 mile
    span.longitudeDelta = 0.5;  // span dimensions
    viewRegion.span = span;
   [mapView setRegion:viewRegion animated:YES];
    
    [mapView regionThatFits:viewRegion];
    
//    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
//    region.center.latitude = currentLocation.latitude ;
//    region.center.longitude = currentLocation.longitude;
//    region.span.longitudeDelta = 0.15f;
//    region.span.latitudeDelta = 0.15f;
//    [self.mapView setRegion:region animated:YES];
    
//    mapView.centerCoordinate=currentLocation;
    mapView.mapType=MKMapTypeStandard;
    
    MapAnnotation *mapAnnot=[[MapAnnotation alloc]initWithTitle:@"CurrentLocation" andCoordinate:currentLocation withIndex:0];
    [mapView addAnnotation:mapAnnot];

}

#pragma mark - UITextFieldDelegate

#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    [scrlView setViewframe:textField forSuperView:self.view];
    self.txtFieldCheck=textField;
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [userDefault setObject:textField.text forKey:@"event"];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Autolayout keyboard Method

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrlView.contentInset = contentInsets;
    self.scrlView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.txtFieldCheck.frame.origin) ) {
        [self.scrlView scrollRectToVisible:self.txtFieldCheck.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrlView.contentInset = contentInsets;
    self.scrlView.scrollIndicatorInsets = contentInsets;
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
