//
//  InformationViewController.m
//  Tapt
//
//  Created by TriState  on 7/10/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController
@synthesize strinfoId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
    //[self callWebserviceForGetSharedFeilds];
   
    
    arrContactDetail=[[NSMutableArray alloc]init];
    NSString *query = [ NSString stringWithFormat:@"select * from Contact_Detail where contact_id=%@",strinfoId];
    arrContactDetail=[Database executeQuery:query];
   
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[arrContactDetail valueForKey:@"ContactSince"]objectAtIndex:0]doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a,dd MMM yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    
    self.lblContactsince.text=dateString;
    self.lblEvent.text=[[arrContactDetail valueForKey:@"Event"]objectAtIndex:0];
    self.lblHeaderText.text=[NSString stringWithFormat:@"%@ %@",[[arrContactDetail valueForKey:@"first_name"]objectAtIndex:0],[[arrContactDetail valueForKey:@"last_name"]objectAtIndex:0]];
    
    //for map
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter=1500;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark- calling webservice
-(void)callWebserviceForGetSharedFeilds
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"getSharedFields" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:strinfoId forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"dict %@",dict);
            infoDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                
                self.lblContactsince.text=[dict objectForKey:@""];
                self.lblEvent.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Event"]];
                
//                //for map
//                locationManager=[[CLLocationManager alloc]init];
//                locationManager.delegate = self;
//                locationManager.distanceFilter=1500;
//                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//                
//                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//                    [locationManager requestWhenInUseAuthorization];
//                
//                [locationManager startUpdatingLocation];
                

             }
       }
       onFailure:^(NSError *error)
       {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
       }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}
-(void)callWebserviceForDeleteContact{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"deleteContact" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:strinfoId forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
        {
            [self hidHud];
            NSLog(@"dict %@",dict);
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                
                NSString *query1= [NSString stringWithFormat:@"delete from Contact_Detail where contact_id=%@",strinfoId];
                NSMutableArray *arrResponse1=[NSMutableArray arrayWithArray:[Database executeQuery:query1]];
                
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    
                    //Do not forget to import AnOldViewController.h
                    if ([controller isKindOfClass:[ContactViewController class]]) {
                        
                        [self.navigationController popToViewController:controller
                                                              animated:YES];
                        break;
                    }
                }

            }
        }
        onFailure:^(NSError *error)
        {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}

- (IBAction)btnAddAction:(id)sender {
    
    
    EventContactListViewController *vcEventContact=[self.storyboard instantiateViewControllerWithIdentifier:@"EventContactListViewController"];
    vcEventContact.strEventContactId=strinfoId;
    vcEventContact.strEventName=self.lblEvent.text;
    [self.navigationController pushViewController:vcEventContact animated:YES];
    
}
#pragma mark - switchvaluechangeAction Method
- (IBAction)switchValueChangeAction:(id)sender
{
    if([sender isOn])
    {
      [self callWebserviceForDeleteContact];
    }
    else
    {
       NSLog(@"Switch is OFF");
    }

}


- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self.mapEventlocation setRegion:viewRegion animated:YES];
    [self.mapEventlocation regionThatFits:viewRegion];
    
  /*  MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [[infoDict objectForKey:@"Lat"]doubleValue];
    region.center.longitude = [[infoDict objectForKey:@"Long"]doubleValue];
    region.span.longitudeDelta = 0.15f;
    region.span.latitudeDelta = 0.15f;
    [self.mapEventlocation setRegion:region animated:YES];
    
    self.mapEventlocation.centerCoordinate=currentLocation;
    self.mapEventlocation.mapType=MKMapTypeStandard; */
    
    MapAnnotation *mapAnnot=[[MapAnnotation alloc]initWithTitle:@"" andCoordinate:currentLocation withIndex:0];
    [self.mapEventlocation addAnnotation:mapAnnot];
    
}
#pragma mark - Tab action
- (IBAction)btnPersoneTabAction:(id)sender {
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    
    NSString *query =[NSString stringWithFormat:@"select * from tbl_profile where cid='%@'",[userDefault objectForKey:@"ID"]];
    arrUserDetail=[[NSMutableArray alloc]init];
    arrUserDetail=[Database executeQuery:query];
    NSLog(@"%@",arrUserDetail);
    
    UserDetail *userDtl=[UserDetail sharedInstance];
    if(arrUserDetail.count>0)
    {
        userDtl.firstName=[[arrUserDetail valueForKey:@"first_name"]objectAtIndex:0];
        userDtl.lastName=[[arrUserDetail valueForKey:@"last_name"]objectAtIndex:0];
        userDtl.MobileNumber=[[arrUserDetail valueForKey:@"home_mobile_phone"]objectAtIndex:0];
        userDtl.ProfilePhoto=[[arrUserDetail valueForKey:@"image_url"]objectAtIndex:0];
        userDtl.homePhone=[[arrUserDetail valueForKey:@"home_phone"]objectAtIndex:0];
        userDtl.homeEmail=[[arrUserDetail valueForKey:@"home_email"]objectAtIndex:0];
        userDtl.homeAddress=[[arrUserDetail valueForKey:@"home_address1"]objectAtIndex:0];
        userDtl.homeStreet=[[arrUserDetail valueForKey:@"home_suburb"]objectAtIndex:0];
        userDtl.homeCity=[[arrUserDetail valueForKey:@"home_city"]objectAtIndex:0];
        userDtl.homeState=[[arrUserDetail valueForKey:@"home_state"]objectAtIndex:0];
        userDtl.homeCountry=[[arrUserDetail valueForKey:@"home_country"]objectAtIndex:0];
        userDtl.homePostCode=[[arrUserDetail valueForKey:@"home_post_code"]objectAtIndex:0];
        userDtl.companyName=[[arrUserDetail valueForKey:@"company"]objectAtIndex:0];
        userDtl.title=[[arrUserDetail valueForKey:@"title"]objectAtIndex:0];
        userDtl.officePhonenumber=[[arrUserDetail valueForKey:@"work_phone"]objectAtIndex:0];
        userDtl.officeMobilenumber=[[arrUserDetail valueForKey:@"work_mobile_phone"]objectAtIndex:0];
        userDtl.officeEmail=[[arrUserDetail valueForKey:@"work_email"]objectAtIndex:0];
        userDtl.Website=[[arrUserDetail valueForKey:@"website"]objectAtIndex:0];
        userDtl.Logoimg=[[arrUserDetail valueForKey:@"logo_url"]objectAtIndex:0];
        userDtl.officeAddress=[[arrUserDetail valueForKey:@"work_address1"]objectAtIndex:0];
        userDtl.officeStreet=[[arrUserDetail valueForKey:@"work_suburb"]objectAtIndex:0];
        userDtl.officeCity=[[arrUserDetail valueForKey:@"work_city"]objectAtIndex:0];
        userDtl.officeState=[[arrUserDetail valueForKey:@"work_state"]objectAtIndex:0];
        userDtl.officeCountry=[[arrUserDetail valueForKey:@"work_country"]objectAtIndex:0];
        userDtl.officePostCode=[[arrUserDetail valueForKey:@"work_post_code"]objectAtIndex:0];
        userDtl.cardlayout=[[arrUserDetail valueForKey:@"layout"]objectAtIndex:0];
        userDtl.facebook=[[arrUserDetail valueForKey:@"facebook"]objectAtIndex:0];
        userDtl.twitter=[[arrUserDetail valueForKey:@"twitter"]objectAtIndex:0];
        userDtl.linkedin=[[arrUserDetail valueForKey:@"linkedIn"]objectAtIndex:0];
        userDtl.skype=[[arrUserDetail valueForKey:@"skype"]objectAtIndex:0];
    }
    
    ProfileTabbarViewController *vcProfiletab=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTabbarViewController"];
    [self.navigationController pushViewController:vcProfiletab animated:YES];

}
- (IBAction)btnSendTabAction:(id)sender {
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    SendContactViewController *vcsend=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactViewController"];
    [self.navigationController pushViewController:vcsend animated:YES];
}
- (IBAction)btnReceiveTabAction:(id)sender {
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    ReceiveContactFirstViewController *vcReceive=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveContactFirstViewController"];
    [self.navigationController pushViewController:vcReceive animated:YES];
}

- (IBAction)btnFavoriteTabAction:(id)sender {
}

- (IBAction)btnSettingTabAction:(id)sender {
    
    if (flagMenuopen==1) {
        flagMenuopen=0;
        [UIView animateWithDuration:1.0 animations:^{
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
        }];
        
    }
    else{
        if (settingView==nil) {
            settingView = [UIView loadView:@"SettingMenu"];
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
            settingView.layer.borderWidth=1.0;
            settingView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.view addSubview:settingView];
        }
        flagMenuopen=1;
        [UIView animateWithDuration:1.0 animations:^{
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height-(settingView.frame.size.height+55), settingView.frame.size.width, settingView.frame.size.height);
        }];
        settingView.hidden=false;
        
    }
    

}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
