//
//  LayoutPreviewViewController.m
//  Tapt
//
//  Created by Parth on 29/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "LayoutPreviewViewController.h"
#import "UIImageView+WebCache.h"
#import "ProfileViewController.h"
#import "MapAnnotation.h"

@interface LayoutPreviewViewController ()
{
    CLLocationManager *locationManager;
    NSUserDefaults *userDefault;
}
@end

@implementation LayoutPreviewViewController

@synthesize viewLayout1,viewLayout2,viewLayout3,viewLayout4;
@synthesize imgLogo;
@synthesize mapView;
//layout1
@synthesize lblName,lblEmail,lblMobile,lblTitle,lblWebsite;
@synthesize imgProfilePic;
@synthesize imgCallBG,imgCallIcon,imgEmailBG,imgEmailIcon,imgWebsiteBG,imgWebsiteIcon;

//layout2
@synthesize lblName2,lblEmail2,lblMobile2,lblTitle2,lblWebsite2,lblAddress1,lblAddress2,lblAddress3,lblStatePostcode;
@synthesize imgCallBG2,imgCallIcon2,imgEmailBG2,imgEmailIcon2,imgWebsiteBG2,imgWebsiteIcon2;

//layout3
@synthesize lblName3,lblEmail3,lblMobile3,lblTitle3,lblWebsite3;
@synthesize imgLogo3;
@synthesize imgCallBG3,imgCallIcon3,imgEmailBG3,imgEmailIcon3,imgWebsiteBG3,imgWebsiteIcon3;


//layout4
@synthesize lblName4,lblEmail4,lblMobile4,lblTitle4,lblWebsite4;
@synthesize imgLogo4;
@synthesize viewHeaderBG;
@synthesize imgCallBG4,imgCallIcon4,imgEmailBG4,imgEmailIcon4,imgWebsiteBG4,imgWebsiteIcon4;

@synthesize dictContact;

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    userDefault = [NSUserDefaults standardUserDefaults];
    self.eventView.layer.cornerRadius=7.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    //for map
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter=1500;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDelegate setShouldRotate:NO];
    lblMobile.userInteractionEnabled = YES;
    lblMobile2.userInteractionEnabled = YES;
    lblMobile3.userInteractionEnabled = YES;
    lblMobile4.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling)];
    [lblMobile addGestureRecognizer:tapGesture];
    [lblMobile2 addGestureRecognizer:tapGesture];
    [lblMobile3 addGestureRecognizer:tapGesture];
    [lblMobile4 addGestureRecognizer:tapGesture];
    
    NSLog(@"%@",dictContact);
    viewHeaderBG.layer.cornerRadius=30;
    
    if ([[dictContact objectForKey:@"layout"] isEqualToString:@"1"] || [[dictContact objectForKey:@"layout"] isEqualToString:@"0"]) {
        
        lblName.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        
        if ([[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""]) {
            lblMobile.text=@"";
            imgCallBG.hidden=YES;
            imgCallIcon.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
            lblMobile.text=strContact;
            imgCallBG.hidden=NO;
            imgCallIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) { //email
            lblEmail.text=@"";
            imgEmailBG.hidden=YES;
            imgEmailIcon.hidden=YES;
        }
        else
        {
            lblEmail.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG.hidden=NO;
            imgEmailIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite.text=@"";
            imgWebsiteBG.hidden=YES;
            imgWebsiteIcon.hidden=YES;
        }
        else
        {
            lblWebsite.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG.hidden=NO;
            imgWebsiteIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle.text=@"";
        }
        else
        {
            lblTitle.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
           imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
        if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {

        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
        imgProfilePic.layer.masksToBounds=YES;
        imgProfilePic.layer.borderWidth=0;
        
        viewLayout1.hidden=NO;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=YES;
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"2"]){
        
        lblName2.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
//        lblMobile2.text=[userDefault objectForKey:@"mobile"];
//        lblEmail2.text=[userDefault objectForKey:@"email"];
//        lblWebsite2.text=[userDefault objectForKey:@"website"];
//        lblTitle2.text=[userDefault objectForKey:@"title"];
        
        if ([[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""]) {
            lblMobile2.text=@"";
            imgCallBG2.hidden=YES;
            imgCallIcon2.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
            lblMobile2.text=strContact;
            imgCallBG2.hidden=NO;
            imgCallIcon2.hidden=NO;
            
//            lblMobile2.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) {
            lblEmail2.text=@"";
            imgEmailBG2.hidden=YES;
            imgEmailIcon2.hidden=YES;
        }
        else
        {
            lblEmail2.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG2.hidden=NO;
            imgEmailIcon2.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite2.text=@"";
            imgWebsiteBG2.hidden=YES;
            imgWebsiteIcon2.hidden=YES;
        }
        else
        {
            lblWebsite2.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG2.hidden=NO;
            imgWebsiteIcon2.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle2.text=@"";
        }
        else
        {
            lblTitle2.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"home_address1"] isEqualToString:@""]) {
            lblAddress1.text=@"";
        }
        else
        {
            lblAddress1.text=[dictContact objectForKey:@"work_address1"];
        }
        
        if ([[dictContact objectForKey:@"work_address1"] isEqualToString:@""]) {
            lblAddress2.text=@"";
        }
        else
        {
            lblAddress2.text=[dictContact objectForKey:@"address2"];
        }
        
        if ([[dictContact objectForKey:@"address3"] isEqualToString:@""]) {
            lblAddress3.text=@"--";
        }
        else
        {
            lblAddress3.text=[dictContact objectForKey:@"address3"];
        }
        
        NSString *strState;//postcode
//        state
        if ([[dictContact objectForKey:@"work_state"] isEqualToString:@""]) {
            strState=@"";
        }
        else
        {
            strState=[dictContact objectForKey:@"work_state"];
        }
        
        if ([[dictContact objectForKey:@"work_post_code"] isEqualToString:@""]) {
            lblStatePostcode.text=[NSString stringWithFormat:@"%@",strState];
        }
        else
        {
            lblStatePostcode.text=[NSString stringWithFormat:@"%@/%@",strState,[dictContact objectForKey:@"work_post_code"]];
        }
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=NO;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=YES;
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"3"]){
        
        lblName3.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
//        lblMobile3.text=[userDefault objectForKey:@"mobile"];
//        lblEmail3.text=[userDefault objectForKey:@"email"];
//        lblWebsite3.text=[userDefault objectForKey:@"website"];
//        lblTitle3.text=[userDefault objectForKey:@"title"];
        
        if ([[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""]) {
            lblMobile3.text=@"";
            imgCallBG3.hidden=YES;
            imgCallIcon3.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
            lblMobile3.text=strContact;
            imgCallBG3.hidden=NO;
            imgCallIcon3.hidden=NO;
            
//            lblMobile3.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) {
            lblEmail3.text=@"";
            imgEmailBG3.hidden=YES;
            imgEmailIcon3.hidden=YES;
        }
        else
        {
            lblEmail3.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG3.hidden=NO;
            imgEmailIcon3.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite3.text=@"";
            imgWebsiteBG3.hidden=YES;
            imgWebsiteIcon3.hidden=YES;
        }
        else
        {
            lblWebsite3.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG3.hidden=NO;
            imgWebsiteIcon3.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle3.text=@"";
        }
        else
        {
            lblTitle3.text=[dictContact objectForKey:@"title"];
        }
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
            self.imgProfilePic3.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [self.imgProfilePic3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }

        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }

        imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
        imgProfilePic.layer.masksToBounds=YES;
        imgProfilePic.layer.borderWidth=0;
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=NO;
        viewLayout4.hidden=YES;
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"4"]){
        
        lblName4.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
//        lblMobile4.text=[userDefault objectForKey:@"mobile"];
//        lblEmail4.text=[userDefault objectForKey:@"email"];
//        lblWebsite4.text=[userDefault objectForKey:@"website"];
//        lblTitle4.text=[userDefault objectForKey:@"title"];
        
        if ([[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""]) {
            lblMobile4.text=@"";
            imgCallBG4.hidden=YES;
            imgCallIcon4.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
            lblMobile4.text=strContact;
            imgCallBG4.hidden=NO;
            imgCallIcon4.hidden=NO;
//            lblMobile4.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) {
            lblEmail4.text=@"";
            imgEmailBG4.hidden=YES;
            imgEmailIcon4.hidden=YES;
        }
        else
        {
            lblEmail4.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG4.hidden=NO;
            imgEmailIcon4.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite4.text=@"";
            imgWebsiteBG4.hidden=YES;
            imgWebsiteIcon4.hidden=YES;
        }
        else
        {
            lblWebsite4.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG4.hidden=NO;
            imgWebsiteIcon4.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle4.text=@"";
        }
        else
        {
            lblTitle4.text=[dictContact objectForKey:@"title"];
        }        
        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo4 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
        imgProfilePic.layer.masksToBounds=YES;
        imgProfilePic.layer.borderWidth=0;
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
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



#pragma mark - Action MEthod

- (IBAction)btnBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnOKAction:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(backAction)]) {
//        [self.delegate backAction];
//    }
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[ProfileViewController class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//    }
    //[self.navigationController popViewControllerAnimated:YES];

    
    if ([self isNetworkReachable])
    {
        [self showHud];
        
        NSLog(@"%@",dictContact);
        NSLog(@"%@",[userDefault objectForKey:@"ID"]);
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"addEvent" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:[NSString stringWithFormat:@"%@",self.txtEvent.text] forKey:@"event"];
     
        NSArray *arrData=[[userDefault objectForKey:@"ReceiveQrCode"] componentsSeparatedByString:@","];
       
        [dict setObject:[arrData objectAtIndex:0] forKey:@"senderId"];
        [dict setObject:[arrData objectAtIndex:1]forKey:@"random"];
        
        NSLog(@"dict : = %@",dict);
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
               if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
               {
                   
         /* NSString *insertQuery=[NSString stringWithFormat:@"insert into Contact_Detail (first_name,last_name,home_mobile_phone,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,website,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,image_url,logo_url,facebook,twitter,linkedIn,skype,Event,Lat,Long,cid)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[dict objectForKey:@"given_name"],[dict objectForKey:@"family_name"],[dict objectForKey:@"home_mobile_phone"],[dict objectForKey:@"home_phone"],[dict objectForKey:@"home_email"],[dict objectForKey:@"home_address1"],[dict objectForKey:@"home_suburb"],[dict objectForKey:@"home_city"],[dict objectForKey:@"home_state"],[dict objectForKey:@"home_country"],[dict objectForKey:@"home_post_code"],[dict objectForKey:@"company"],[dict objectForKey:@"title"],[dict objectForKey:@"work_phone"],[dict objectForKey:@"work_mobile_phone"],[dict objectForKey:@"work_email"],[dict objectForKey:@"work_www"],[dict objectForKey:@"work_address1"],[dict objectForKey:@"work_suburb"],[dict objectForKey:@"work_city"],[dict objectForKey:@"work_state"],[dict objectForKey:@"work_country"],[dict objectForKey:@"work_post_code"],[dict objectForKey:@"bizcard"],[dict objectForKey:@"image"],[dict objectForKey:@"logo"],@"",@"",@"",@"",[NSString stringWithFormat:@"%@",self.txtEvent.text],[userDefault objectForKey:@"curLat"],[userDefault objectForKey:@"cutLong"],[userDefault objectForKey:@"ID"]];
                   
                   
                   if([Database executeScalerQuery:insertQuery])
                   {
                       NSLog(@"Data Inserted!");
                   }
                   else
                   {
                       
                   } */
                   
                   NSString *updatequery= [NSString stringWithFormat:@"update Contact_Detail set Event='%@',Lat='%@',Long='%@' where contact_id='%@'",[NSString stringWithFormat:@"%@",self.txtEvent.text],[userDefault objectForKey:@"curLat"],[userDefault objectForKey:@"cutLong"],[dictContact objectForKey:@"contact_id"]];
                   
                   if([Database executeScalerQuery:updatequery])
                   {
                       NSLog(@"Data upddated!");
                   }
                   else
                   {
                       
                   }
                   
                   NSString *str=[NSString stringWithFormat:@"Select * from Contact_Detail"];
                   NSArray *a=[Database executeQuery:str];
                   NSLog(@"%@",a);
                   
             [userDefault setObject:@"1" forKey:@"isContact"];
              if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
              {
                       for (UIViewController *controller in self.navigationController.viewControllers) {
                           
                           if ([controller isKindOfClass:[ContactViewController class]]) {
                               
                               [self.navigationController popToViewController:controller
                                                                     animated:YES];
                               break;
                           }
                       
                       }
                       
               }
               else
               {
                   ContactViewController *vcReceivetag=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
                   [self.navigationController pushViewController:vcReceivetag animated:YES];
          
               }
            }
            
        } onFailure:^(NSError *error) {
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

#pragma mark - Custom Method

//for the calling fuctionality
-(void)calling{
    [self callThisPhone];
}

-(void) callThisPhone
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[dictContact objectForKey:@"mobile_phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Phone call facility is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}



- (IBAction)btnTagAction:(id)sender {
    
    [userDefault setObject:@"0" forKey:@"isFromcontactdetail"];
    NSLog(@"%@",dictContact);
    ReceiveTagViewController *vcReceivetag=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveTagViewController"];
    vcReceivetag.senderIDForTag=[dictContact objectForKey:@"contact_id"];
    [self.navigationController pushViewController:vcReceivetag animated:YES];
    
}
#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //        [scrlView setViewframe:textField forSuperView:self.view];
    self.txtEvent=textField;
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
    if (!CGRectContainsPoint(aRect, self.txtEvent.frame.origin) ) {
        [self.scrlView scrollRectToVisible:self.txtEvent.frame animated:YES];
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
