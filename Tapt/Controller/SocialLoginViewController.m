//
//  SocialLoginViewController.m
//  Tapt
//
//  Created by Parth on 25/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "SocialLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "Database.h"

@interface SocialLoginViewController ()
{
    NSInteger totalContact;
    NSInteger startIndex;
    NSInteger count;
    NSInteger page;
    
    GPPSignIn *signIn;
}
@end

@implementation SocialLoginViewController

@synthesize dictContactResponse;
@synthesize arrKeyForShare;

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
    
    [Database createEditableCopyOfDatabaseIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
      if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480) {
            // 3.5 inch display - iPhone 4S and below
            NSLog(@"Device is an iPhone 4S or below");
            self.topConstrints.constant=43;
           // self.verticleSpace.constant=60;
             
        }
        
        else if (result.height == 568) {
            // 4 inch display - iPhone 5
            NSLog(@"Device is an iPhone 5/S/C");
            self.topConstrints.constant=80;
            self.verticleSpace.constant=50;
        }
        
        else if (result.height == 667) {
            // 4.7 inch display - iPhone 6
            NSLog(@"Device is an iPhone 6");
            self.topConstrints.constant=100;
            self.verticleSpace.constant=60;
        }
        
        else if (result.height == 736) {
            // 5.5 inch display - iPhone 6 Plus
            NSLog(@"Device is an iPhone 6 Plus");
            self.topConstrints.constant=140;
            self.verticleSpace.constant=80;
            self.mainViewHeight.constant=550;
        }
    }
    
    
    
    //google login
    signIn=[GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser=YES;
    signIn.clientID=GOOGLE_CLIENT_ID;
    signIn.scopes=@[kGTLAuthScopePlusLogin];
    signIn.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                     name:@"SessionStateChangeNotification"
                                                   object:nil];
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    

    
    
        
   // arrKeyForShare= [[NSMutableArray alloc]initWithObjects:@"sFirstName",@"sLastName",@"sMobile",@"sWork",@"sHome",@"sEmail",@"sCompany",@"sTitle",@"sAddress1",@"sAddress2",@"sAddress3",@"sSuburb",@"sPostcode",@"sCity",@"sState",@"sCountry",@"sLogo",@"sPicture",@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype",@"sWebsite",@"sEmail2", nil];
     arrKeyForShare=[[NSMutableArray alloc]initWithObjects:@"sFirstName",@"sLastName",@"sMobile",@"sPicture",@"sHome_phonenumber",@"sHome_Email",@"sHome_Address",@"sHome_street",@"sHome_City",@"sHome_State",@"sHome_County",@"sHome_Postcode",@"sCompanyName",@"stitle",@"sOfficePhone",@"sOfficeMobile",@"sOfficeEmail",@"sWebsite",@"sLogo",@"sOfficeAddress",@"sOfficeStreet",@"sOfficeCity",@"sOfficeState",@"sOfficeCountry",@"sOfficePostcode"@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype",nil];
    
    if ([userDefault objectForKey:@"isFirstTime"]) {
        
    }
    else
    {
        for(NSString *key in arrKeyForShare){
            
            if ([key isEqualToString:@"sFacebook"] || [key isEqualToString:@"sTwitter"] || [key isEqualToString:@"sLinkedIn"]) {
                [userDefault setObject:@"3" forKey:key];
            }
            else
            {
                [userDefault setObject:@"1" forKey:key];
            }
        }
    }
    
    //Giving the corner round
    self.btnFacebooklogin.layer.cornerRadius=5;
    self.btnGoogleplushlogin.layer.cornerRadius=5;
    self.viewEmail.layer.cornerRadius=15;
    self.viewPassword.layer.cornerRadius=15;
    self.lblOR.layer.cornerRadius=10;
    self.lblOR.layer.masksToBounds = YES;

    UIColor *color = [UIColor whiteColor];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action Method

- (IBAction)btnFacebookLoginAction:(id)sender {
    
        [userDefault setObject:@"fbLogin" forKey:@"LoginType"];
        if ([FBSession activeSession].state != FBSessionStateOpen &&
            [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
    
            [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
    
        }
        else
        {
            // Close an existing session.
            [[FBSession activeSession] closeAndClearTokenInformation];
            
        }
}

- (IBAction)btnGoogleplushLoginAction:(id)sender {
    [userDefault setObject:@"googleLogin" forKey:@"LoginType"];

    [signIn authenticate];
    
    
}

- (IBAction)btnSigninAction:(id)sender {
    
    [userDefault setObject:@"localLogin" forKey:@"LoginType"];
   
    
    if ([self.txtEmail validate] && [self.txtPassword validate] ) {
        
        if (![self.txtEmail.text isEqualToString:@""]) {
            if ([NSString validateEmail:self.txtEmail.text]) {
                
                [self callWebservice];
            }
            else
            {
                [UIAlertView infoAlertWithMessage:@"Enter valid Email Address" andTitle:APP_NAME];
            }
        }
        else
        {
          //  [self callWebservice];
        }
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"Email and Password are Mandatory!" andTitle:APP_NAME];
    }

//  IntroPageViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
   // [self.navigationController pushViewController:vcIntro animated:YES];

}

#pragma mark - GPPSignInDelegate Method

-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Received Error %@ and auth object %@",error,auth);
    }
    else
    {
        NSLog(@"googlePlusUser :=%@",signIn.googlePlusUser);
       
        NSMutableDictionary *dictGoogledata=[NSMutableDictionary dictionary];
        
        [userDefault setObject:@"1" forKey:@"isGoogle"];
        
        
        GTLPlusPersonName *fullName=[[GTLPlusPersonName alloc]init];
        fullName= signIn.googlePlusUser.name;
        
        
        
        NSLog(@"%@",signIn.googlePlusUser.identifier);
        NSLog(@"%@",signIn.googlePlusUser.emails);
        NSLog(@"%@",signIn.googlePlusUser);
       
       
        [dictGoogledata setObject:fullName.givenName forKey:@"Google_firstnm"];
        [dictGoogledata setObject:fullName.familyName forKey:@"Google_lastnm"];
        [dictGoogledata setObject:signIn.googlePlusUser.identifier forKey:@"Google_Id"];
        [dictGoogledata setObject:signIn.googlePlusUser.identifier forKey:@"Google_Email"];
       
        //[dictGoogledata setObject:signIn.googlePlusUser.image forKey:@"picname"];
        //[userDefault setObject:signIn.googlePlusUser.image forKey:@"picname"];
        
       
        [userDefault setObject:dictGoogledata forKey:@"GoogleData"];
        
          [signIn signOut];
        
        NSLog(@"%@",dictGoogledata);
        [self callWebservice];
    }
}

#pragma mark - Custom Method

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];

    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];

    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error)
    {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen)
        {
            // The session is open. Get the user information and update the UI.
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email, link"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
            {
                if (!error) {
                    
                    NSMutableDictionary *dictFBData=[NSMutableDictionary dictionary];
                    
                    
                    [userDefault setObject:@"1" forKey:@"isFacebook"];
                    
                    [dictFBData setObject:[result objectForKey:@"first_name"] forKey:@"FBFirstName"];
                    [dictFBData setObject:[result objectForKey:@"last_name"] forKey:@"FBLastName"];
                    [dictFBData setObject:[result objectForKey:@"id"] forKey:@"fbid"];
                    [dictFBData setObject:[result objectForKey:@"link"] forKey:@"fblink"];
                    [dictFBData setObject:[result objectForKey:@"email"] forKey:@"fbEmail"];
                    
                    NSString *strUrl=[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                    
                    NSString *proPicUrl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=450&width=450&type=large",[result objectForKey:@"id"]];
                    
                    [dictFBData setObject:proPicUrl forKey:@"picname"];
                    [userDefault setObject:proPicUrl forKey:@"picname"];
                    
                    //picname
                    [userDefault setObject:dictFBData forKey:@"FBData"];
                    
                    [self callWebservice];
                }
                else{
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}


-(void)callWebservice
{
    if ([self isNetworkReachable])
    {
        
        NSDictionary *tmpDictFBdata=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
        
        NSDictionary *tmpDictGoogledata=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"GoogleData"]];
        
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"checkAuth" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        
        
        if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"fbLogin"])
        {
            [dict setObject:@"facebook" forKey:@"source"];
         
            if(tmpDictFBdata>0)
            {
                [dict setObject:[tmpDictFBdata objectForKey:@"fbid"] forKey:@"fbid"];
                
            }
        }
        else if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"googleLogin"])
        {
          
            [dict setObject:@"google" forKey:@"source"];
         
            if(tmpDictGoogledata>0)
            {
                [dict setObject:[tmpDictGoogledata objectForKey:@"Google_Id"] forKey:@"fbid"];
            }
           
        }
        else if ([[userDefault objectForKey:@"LoginType"]isEqualToString:@"localLogin"])
        {
            [dict setObject:@"local" forKey:@"source"];
            [dict setObject:self.txtEmail.text forKey:@"email"];
            [dict setObject:self.txtPassword.text forKey:@"userPass"];
            [dict setObject:@"" forKey:@"fbid"];
        }
        else
        {
            
        }
        NSLog(@"dict := %@", dict);
//        Webservice *service = [[Webservice alloc]init];
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                
                //for getting timestamp for usase statstic
                NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                [userDefault setObject:timestamp forKey:@"DateForUsasestatus"];
               // ==========
                
                if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"localLogin"] )
                {
                    if([[dict objectForKey:@"Status"] isEqualToString:@"new account"])
                    {
                        [userDefault setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"ContactId"]] forKey:@"LocalloginID"];
                        [self callCreateContactWebservice];
                    }
                    else
                    {
                        [userDefault setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"ContactId"]] forKey:@"LocalloginID"];
                        [self callWebserviceForGetContactDetail:[NSString stringWithFormat:@"%@",[dict objectForKey:@"ContactId"]]];
                    }
                    
                }
                else
                {
                    
                    if([[dict objectForKey:@"ContactId"] isEqualToString:@"0"])
                    {
                        
                        if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"fbLogin"])
                        {
                            
                            [userDefault setObject:@"1" forKey:@"isFBLogin"];
                            [userDefault setObject:[tmpDictFBdata objectForKey:@"FBFirstName"] forKey:@"firstName"];
                            [userDefault setObject:[tmpDictFBdata objectForKey:@"FBLastName"] forKey:@"lastName"];
                            [userDefault setObject:[tmpDictFBdata objectForKey:@"fbEmail"] forKey:@"email"];
                            [userDefault setObject:[tmpDictFBdata objectForKey:@"picname"] forKey:@"picname"];
                            [userDefault setObject:[tmpDictFBdata objectForKey:@"fblink"] forKey:@"fblink"];
                            
                        }
                        else if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"googleLogin"])
                        {
                            
                            [userDefault setObject:@"1" forKey:@"isGoogleLogin"];
                            [userDefault setObject:[tmpDictGoogledata objectForKey:@"Google_firstnm"] forKey:@"firstName"];
                            [userDefault setObject:[tmpDictGoogledata objectForKey:@"Google_lastnm"] forKey:@"lastName"];
                            
                        }
                        else
                        {
                            [userDefault setObject:[dict objectForKey:@""] forKey:@"LocalloginID"];
                        }
                        
                        [self callCreateContactWebservice];
                        
                        
                        //                    ProfileViewController *vcProfile=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                        //                    [self.navigationController pushViewController:vcProfile animated:YES];
                        
                        //                    UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
                        //                    [self.navigationController pushViewController:vcIntro animated:YES];
                        
                        
                        
                    }
                    else
                    {
                        [userDefault setObject:[dict objectForKey:@"ContactId"] forKey:@"ID"];
                        [self callWebserviceForGetContactDetail:[dict objectForKey:@"ContactId"]];
                        
                        
                        
                        /*   if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"fbLogin"])
                         {
                         
                         [userDefault setObject:@"1" forKey:@"isFBLogin"];
                         [userDefault setObject:[tmpDictFBdata objectForKey:@"FBFirstName"] forKey:@"firstName"];
                         [userDefault setObject:[tmpDictFBdata objectForKey:@"FBLastName"] forKey:@"lastName"];
                         [userDefault setObject:[tmpDictFBdata objectForKey:@"fbEmail"] forKey:@"email"];
                         [userDefault setObject:[tmpDictFBdata objectForKey:@"picname"] forKey:@"picname"];
                         [userDefault setObject:[tmpDictFBdata objectForKey:@"fblink"] forKey:@"fblink"];
                         
                         
                         }
                         else if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"googleLogin"])
                         {
                         
                         [userDefault setObject:@"1" forKey:@"isGoogleLogin"];
                         [userDefault setObject:[tmpDictGoogledata objectForKey:@"Google_firstnm"] forKey:@"firstName"];
                         [userDefault setObject:[tmpDictGoogledata objectForKey:@"Google_lastnm"] forKey:@"lastName"];
                         
                         }
                         [self callCreateContactWebservice];*/
                        
                    }
                    
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
-(void)callCreateContactWebservice
{
     NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
        [dict setObject:@"new" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
    
       if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"fbLogin"])
        {
            [dict setObject:[userDefault objectForKey:@"firstName"] forKey:@"given_name"];
            [dict setObject:[userDefault objectForKey:@"lastName"] forKey:@"family_name"];
            
             [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"social_facebook"];

        }
        else if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"googleLogin"])
        {
            [dict setObject:[userDefault objectForKey:@"firstName"] forKey:@"given_name"];
            [dict setObject:[userDefault objectForKey:@"lastName"] forKey:@"family_name"];

        }
        else
        {
            [dict setObject:@"" forKey:@"given_name"];
            [dict setObject:@"" forKey:@"family_name"];
        }
    
    
    
        NSString *strConatct=[@"" stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [dict setObject:strConatct forKey:@"home_mobile_phone"];
        
        
        [dict setObject:@"" forKey:@"home_phone"];
        [dict setObject:@"" forKey:@"home_phone2"];
        
        
        [dict setObject:@"" forKey:@"home_email"];
        [dict setObject:@"" forKey:@"home_www"];
        
        
        [dict setObject:@"" forKey:@"home_address1"];
        [dict setObject:@"" forKey:@"home_address2"];
        [dict setObject:@"" forKey:@"home_address3"];
        
        [dict setObject:@"" forKey:@"home_suburb"];
        [dict setObject:@"" forKey:@"home_city"];
        [dict setObject:@"" forKey:@"home_state"];
        [dict setObject:@"" forKey:@"home_country"];
        [dict setObject:@"" forKey:@"home_post_code"];
        
        [dict setObject:@"" forKey:@"company"];
        [dict setObject:@"" forKey:@"title"];
        
        [dict setObject:@"" forKey:@"work_mobile_phone"];
        [dict setObject:@"" forKey:@"work_phone"];
        [dict setObject:@"" forKey:@"work_phone2"];
        
        [dict setObject:@"" forKey:@"work_email"];
        [dict setObject:@"" forKey:@"website"];
        [dict setObject:@"" forKey:@"work_address1"];
        [dict setObject:@"" forKey:@"work_address2"];
        [dict setObject:@"" forKey:@"work_address3"];
        [dict setObject:@"" forKey:@"work_suburb"];
        [dict setObject:@"" forKey:@"work_city"];
        [dict setObject:@"" forKey:@"work_state"];
        [dict setObject:@"" forKey:@"work_country"];
        [dict setObject:@"" forKey:@"work_post_code"];
        
        
        
        
        //fbid
        if([[userDefault objectForKey:@"LoginType"] isEqualToString:@"fbLogin"])
        {
            
            tmpDict=[userDefault objectForKey:@"FBData"];
            [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"fbid"];
        }
        else if([[userDefault objectForKey:@"LoginType"] isEqualToString:@"googleLogin"])
        {
            NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"GoogleData"]];
            [dict setObject:[tmpDict valueForKey:@"Google_Id"] forKey:@"fbid"];
        }
        else
        {
            [dict setObject:[userDefault objectForKey:@"LocalloginID"] forKey:@"fbid"];
        }
        
        //social
        [dict setObject:@"" forKey:@"social_twitter"];
        [dict setObject:@"" forKey:@"social_linkedin"];

        
        [dict setObject:@"" forKey:@"social_skype"];
        [dict setObject:@"" forKey:@"bizcard"];
      
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
         {
            NSLog(@"dict %@",dict);
            [self hidHud];
                if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
                {
                    NSLog(@"%@",[dict objectForKey:@"ID"]);
                    [userDefault setObject:[dict objectForKey:@"ID"] forKey:@"ID"];
                    [userDefault setObject:[dict objectForKey:@"Salt"] forKey:@"Salt"];
                    
                    //insert in to database
                NSString *insertQuery=[NSString stringWithFormat:@"insert into tbl_profile (given_name,family_name,home_mobile_phone,image,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,work_www,logo,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,social_facebook,social_twitter,social_linkedin,social_Skype,cid)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",[dict objectForKey:@"ID"]];
                    
                    if([Database executeScalerQuery:insertQuery])
                    {
                        NSLog(@"Data Inserted!");
                    }
                    else
                    {
                        
                    }
                    
                    //insert into usagestatusstatastic
                    NSString *Query1=[NSString stringWithFormat:@"insert into SubmitUsageStatistics(send2friend,tagSearch,shareEmail,shareText)values ('%d','%d','%d','%d')",0,0,0,0];
                    [Database executeQuery:Query1];
                    
                    
                    //30-Jun-15
                    if ([[userDefault objectForKey:@"isContact"] isEqualToString:@"1"]) {
                        UIViewController *vcContatct = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
                        vcContatct.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vcContatct animated:YES];
                    }
                    else{
                        
                        [userDefault setObject:@"1" forKey:@"isContact"];
                        UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
                        [self.navigationController pushViewController:vcIntro animated:YES];
                    }
                }
                else
                {
                    
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
-(void)callWebserviceForGetContactDetail:(NSString *)contact_Id
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"get" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        
        NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
        
         NSDictionary *tmpDictGoogledata=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"GoogleData"]];
        
        
        
        [dict setObject:contact_Id forKey:@"id"];
        
    
        if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"fbLogin"])
        {
            
            if(tmpDict>0)
            {
              [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"fbid"];
                
            }
        }
        else if([[userDefault objectForKey:@"LoginType"]isEqualToString:@"googleLogin"])
        {
            
            //[dict setObject:@"google" forKey:@"source"];
            
            if(tmpDictGoogledata>0)
            {
                [dict setObject:[tmpDictGoogledata objectForKey:@"Google_Id"] forKey:@"fbid"];
            }
            
        }
        else if ([[userDefault objectForKey:@"LoginType"]isEqualToString:@"localLogin"])
        {
             [dict setObject:[userDefault objectForKey:@"LocalloginID"] forKey:@"fbid"];
        }
        else
        {
            
        }
        
        
        NSLog(@"dict := %@", dict);        
        
        //        Webservice *service = [[Webservice alloc]init];
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                //storing purchased data to limit displaying user
                [userDefault setObject:[[dict objectForKey:@"Expiry"]stringValue] forKey:@"isBuy"];
                
                
                [userDefault setObject:[dict objectForKey:@"id"] forKey:@"ID"];
                [userDefault setObject:[dict objectForKey:@"password"] forKey:@"Salt"];
                [userDefault setObject:@"1" forKey:@"isRegistered"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [userDefault setObject:[dict objectForKey:@"given_name"] forKey:@"firstName"];
                [userDefault setObject:[dict objectForKey:@"family_name"] forKey:@"lastName"];
                [userDefault setObject:[dict objectForKey:@"mobile_phone"] forKey:@"mobile"];
                [userDefault setObject:[dict objectForKey:@"desk_phone"] forKey:@"work"];
                [userDefault setObject:[dict objectForKey:@"home_phone"] forKey:@"home"];
                [userDefault setObject:[dict objectForKey:@"email"] forKey:@"email"];
                [userDefault setObject:[dict objectForKey:@"company"] forKey:@"company"];
                [userDefault setObject:[dict objectForKey:@"title"] forKey:@"title"];
                [userDefault setObject:[dict objectForKey:@"address1"] forKey:@"address1"];
                [userDefault setObject:[dict objectForKey:@"address2"] forKey:@"address2"];
                [userDefault setObject:[dict objectForKey:@"address3"] forKey:@"address3"];
                [userDefault setObject:[dict objectForKey:@"suburb"] forKey:@"suburb"];
                [userDefault setObject:[dict objectForKey:@"post_code"] forKey:@"postcode"];
                [userDefault setObject:[dict objectForKey:@"city"] forKey:@"city"];
                [userDefault setObject:[dict objectForKey:@"state"] forKey:@"state"];
                [userDefault setObject:[dict objectForKey:@"country"] forKey:@"country"];
                
                NSString *picUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dict objectForKey:@"image"]];
                
                [userDefault setObject:picUrl forKey:@"picname"];
                [userDefault setObject:[dict objectForKey:@"logo"] forKey:@"logo"];
                [userDefault setObject:[dict objectForKey:@"bizcard"] forKey:@"cardLayout"];
                [userDefault setObject:[dict objectForKey:@"www"] forKey:@"website"];
               
                //store into userdetail preferwnces
               UserDetail *userDtl=[UserDetail sharedInstance];
                
                userDtl.firstName=[dict objectForKey:@"given_name"];
                userDtl.lastName=[dict objectForKey:@"family_name"];
                userDtl.MobileNumber=[dict objectForKey:@"mobile_phone"];
                userDtl.ProfilePhoto=[dict objectForKey:@"desk_phone"];
                userDtl.homePhone=[dict objectForKey:@"home_phone"];
                userDtl.homeEmail=[dict objectForKey:@"home_email"];
                userDtl.homeAddress=[dict objectForKey:@"home_address1"];
                userDtl.homeStreet=[dict objectForKey:@"home_suburb"];
                userDtl.homeCity=[dict objectForKey:@"home_city"];
                userDtl.homeState=[dict objectForKey:@"home_state"];
                userDtl.homeCountry=[dict objectForKey:@"home_country"];
                userDtl.homePostCode=[dict objectForKey:@"home_post_code"];
                userDtl.companyName=[dict objectForKey:@"company"];
                userDtl.title=[dict objectForKey:@"title"];
                userDtl.officePhonenumber=[dict objectForKey:@"work_phone"];
                userDtl.officeMobilenumber=[dict objectForKey:@"work_mobile_phone"];
                userDtl.officeEmail=[dict objectForKey:@"work_email"];
                userDtl.Website=[dict objectForKey:@"work_www"];
                userDtl.Logoimg=[dict objectForKey:@"logo"];
                userDtl.officeAddress=[dict objectForKey:@"work_address1"];
                userDtl.officeStreet=[dict objectForKey:@"work_suburb"];
                userDtl.officeCity=[dict objectForKey:@"work_city"];
                userDtl.officeState=[dict objectForKey:@"work_state"];
                userDtl.officeCountry=[dict objectForKey:@"work_country"];
                userDtl.officePostCode=[dict objectForKey:@"work_post_code"];
                userDtl.cardlayout=[dict objectForKey:@"bizcard"];
                userDtl.facebook=@"";
                userDtl.twitter=@"";
                userDtl.linkedin=@"";
                userDtl.skype=@"";
                
                
                
                NSString *query= [NSString stringWithFormat:@"delete from tbl_profile"];
                
                
                NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
                NSLog(@"%@",arrResponse);
                
                NSString *insertQuery=[NSString stringWithFormat:@"insert into tbl_profile (given_name,family_name,home_mobile_phone,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,work_www,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,image,logo,social_facebook,social_twitter,social_linkedin,social_Skype,cid)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[dict objectForKey:@"given_name"],[dict objectForKey:@"family_name"],[dict objectForKey:@"home_mobile_phone"],[dict objectForKey:@"home_phone"],[dict objectForKey:@"home_email"],[dict objectForKey:@"home_address1"],[dict objectForKey:@"home_suburb"],[dict objectForKey:@"home_city"],[dict objectForKey:@"home_state"],[dict objectForKey:@"home_country"],[dict objectForKey:@"home_post_code"],[dict objectForKey:@"company"],[dict objectForKey:@"title"],[dict objectForKey:@"work_phone"],[dict objectForKey:@"work_mobile_phone"],[dict objectForKey:@"work_email"],[dict objectForKey:@"work_www"],[dict objectForKey:@"work_address1"],[dict objectForKey:@"work_suburb"],[dict objectForKey:@"work_city"],[dict objectForKey:@"work_state"],[dict objectForKey:@"work_country"],[dict objectForKey:@"work_post_code"],[dict objectForKey:@"bizcard"],[dict objectForKey:@"image"],[dict objectForKey:@"logo"],@"",@"",@"",@"",[dict objectForKey:@"id"]];

                
                if([Database executeScalerQuery:insertQuery])
                {
                    NSLog(@"Data Inserted!");
                }
                else
                {
                    
                }
                
                [self callWebserviceForGetMyContactList:[userDefault objectForKey:@"ID"]];
              

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


-(void)callWebserviceForGetMyContactList:(NSString *)contact_Id
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"getMyContacts" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:contact_Id forKey:@"id"];
        
        NSLog(@"dict := %@", dict);
        
        //        Webservice *service = [[Webservice alloc]init];
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                if (![[[dict objectForKey:@"rowCount"] stringValue] isEqualToString:@"0"]) {
                    [userDefault setObject:@"1" forKey:@"isContact"];
                    totalContact=[[dict objectForKey:@"rowCount"] integerValue];
                    dictContactResponse=dict;
//                    [self callWebserviceForGetMyContact];
                    [self callPaging];

                }
                else
                {
                   
                    //insert into usagestatusstatastic
                    NSString *Query1=[NSString stringWithFormat:@"insert into SubmitUsageStatistics(send2friend,tagSearch,shareEmail,shareText)values ('%d','%d','%d','%d')",0,0,0,0];
                    [Database executeQuery:Query1];
                    
                     [userDefault setObject:@"0" forKey:@"isContact"];
                    IntroPageViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
                    [self.navigationController pushViewController:vcIntro animated:YES];
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

//getContact

-(void)callPaging{
    
    startIndex=1;
    count=50;
    page=totalContact/50;
    
    for (int i=0; i<=page; i++) {
        NSString *strKey=[NSString stringWithFormat:@"Contact%ld",(long)startIndex];
        
        if ([dictContactResponse objectForKey:strKey]) {
            
            NSString *strKey1=[NSString stringWithFormat:@"Contact%ld",(long)count];
            if ([dictContactResponse objectForKey:strKey1]) {
                
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
                [dict setObject:@"1.14" forKey:@"version"];
                [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
                
                NSString *strId=@"";
                
                for (startIndex; startIndex<=count; startIndex++) {
                    if ([strId isEqualToString:@""]) {
                        strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                    }
                    else
                    {
                        strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                    }
                }
                startIndex=count+1;
                count=count+50;
                
                [dict setObject:strId forKey:@"senders"];
                
                strId=@"";
      
                [self callWebserviceForGetMyContact:dict];
                
            }
            else
            {
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
                [dict setObject:@"1.14" forKey:@"version"];
                [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
                
                NSString *strId=@"";
                NSString *strTemp=@"";
                
                
                for (startIndex; startIndex<=totalContact; startIndex++) {
                    
                    if ([strId isEqualToString:@""]) {
                       // strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                       strTemp=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                        
                        if (![strTemp isEqualToString:[userDefault objectForKey:@"ID"]]) {
                            strId=[NSString stringWithFormat:@"%@",strTemp];
                        }
                        
                        
                    }
                    else
                    {
                       //strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                        
                        strTemp=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%ld",(long)startIndex]]];
                        
                        if (![strTemp isEqualToString:[userDefault objectForKey:@"ID"]]) {
                            strId=[strId stringByAppendingFormat:@",%@",strTemp];
                        }
                    }
                }
                startIndex=count+1;
                
                [dict setObject:strId forKey:@"senders"];
                
                strId=@"";
      
                [self callWebserviceForGetMyContact:dict];
            }
        }
    }
   /* HomeViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:vcHome animated:YES];*/
   

}

-(void)callWebserviceForGetMyContact:(NSMutableDictionary *)dict
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        
//        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
//        [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
//        [dict setObject:@"1.14" forKey:@"version"];
//        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
//        
//        NSString *strId=@"";
//        
//        for (int i=0; i<totalContact; i++) {
//            
//            if ([strId isEqualToString:@""]) {
//                strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",i+1]]];
//            }
//            else
//            {
//                strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",i+1]]];
//            }
//        }
//        
//        [dict setObject:strId forKey:@"senders"];
        
        
        NSLog(@"dict := %@", dict);
        
        Webservice *service1=[[Webservice alloc]init];
        
        [service1 callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
               /* int i=[[dict objectForKey:@"Count"] intValue];
                
                NSMutableArray *arrKeys=[NSMutableArray arrayWithArray:[dict allKeys]];
                [arrKeys removeObject:@"Count"];
                [arrKeys removeObject:@"Response"];
                
                for (int j=1; j<=i; j++) {
                    
                    NSString *strKey=[NSString stringWithFormat:@"Contact%d",j];
                    strKey=[dictContactResponse objectForKey:strKey];
                    

                    NSString *strKey1=[arrKeys objectAtIndex:j-1];
                    NSMutableDictionary *dictInsert = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:strKey1]];
                    NSArray *arrId=[NSArray arrayWithArray:[strKey1 componentsSeparatedByString:@" "]];
                    
                   
                    
                    NSLog(@"%@",[arrId objectAtIndex:1]);
                  
                    
                    //delete from contact_detail table
                    NSString *query= [NSString stringWithFormat:@"delete from Contact_Detail"];
                    NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
                 
                NSLog(@"%@",dictInsert);
                NSString *insertQuery=[NSString stringWithFormat:@"insert into Contact_Detail (first_name,last_name,home_mobile_phone,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,website,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,image_url,logo_url,facebook,twitter,linkedIn,skype,ContactSince,contact_id)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[dictInsert objectForKey:@"given_name"],[dictInsert objectForKey:@"family_name"],[dict objectForKey:@"home_mobile_phone"],[dictInsert objectForKey:@"home_phone"],[dictInsert objectForKey:@"home_email"],[dictInsert objectForKey:@"home_address1"],[dictInsert objectForKey:@"home_suburb"],[dictInsert objectForKey:@"home_city"],[dictInsert objectForKey:@"home_state"],[dictInsert objectForKey:@"home_country"],[dictInsert objectForKey:@"home_post_code"],[dictInsert objectForKey:@"company"],[dictInsert objectForKey:@"title"],[dictInsert objectForKey:@"work_phone"],[dictInsert objectForKey:@"work_mobile_phone"],[dictInsert objectForKey:@"work_email"],[dictInsert objectForKey:@"work_www"],[dictInsert objectForKey:@"work_address1"],[dictInsert objectForKey:@"work_suburb"],[dictInsert objectForKey:@"work_city"],[dictInsert objectForKey:@"work_state"],[dictInsert objectForKey:@"work_country"],[dictInsert objectForKey:@"work_post_code"],[dictInsert objectForKey:@"bizcard"],[dictInsert objectForKey:@"image"],[dictInsert objectForKey:@"logo"],@"",@"",@"",@"",[dictInsert objectForKey:@"created"],[arrId objectAtIndex:1]];
                
                
                if([Database executeScalerQuery:insertQuery])
                {
                NSLog(@"Data Inserted!");
                }
                else
                {
                
                }
                
                } */
                
                //delete from category relation
                NSString *deletequery= [NSString stringWithFormat:@"delete from Categorie_contact_relation"];
                [Database executeQuery:deletequery];
                
                NSString *deletequery1= [NSString stringWithFormat:@"delete from Tag_Contact_relation"];
                [Database executeQuery:deletequery1];
                
                
               int i=[[dict objectForKey:@"Count"] intValue];
                
                NSMutableArray *arrKeys=[NSMutableArray arrayWithArray:[dict allKeys]];
                [arrKeys removeObject:@"Count"];
                [arrKeys removeObject:@"Response"];
                
                for (int j=1; j<=i; j++) {
                    
                    NSString *strKey=[NSString stringWithFormat:@"Contact%d",j];
                    strKey=[dictContactResponse objectForKey:strKey];
                    
                    NSString *strKey1=[arrKeys objectAtIndex:j-1];
                    NSMutableDictionary *dictInsert = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:strKey1]];
                    NSArray *arrId=[NSArray arrayWithArray:[strKey1 componentsSeparatedByString:@" "]];
                    
                    
                    NSLog(@"%@",dictInsert);
                    NSLog(@"%@",[dictInsert objectForKey:@"home_mobile_phone"]);
                    NSString *insertQuery=[NSString stringWithFormat:@"insert into Contact_Detail (first_name,last_name,home_mobile_phone,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,website,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,image_url,logo_url,facebook,twitter,linkedIn,skype,ContactSince,Event,contact_id)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[dictInsert objectForKey:@"given_name"],[dictInsert objectForKey:@"family_name"],[dictInsert objectForKey:@"home_mobile_phone"],[dictInsert objectForKey:@"home_phone"],[dictInsert objectForKey:@"home_email"],[dictInsert objectForKey:@"home_address1"],[dictInsert objectForKey:@"home_suburb"],[dictInsert objectForKey:@"home_city"],[dictInsert objectForKey:@"home_state"],[dictInsert objectForKey:@"home_country"],[dictInsert objectForKey:@"home_post_code"],[dictInsert objectForKey:@"company"],[dictInsert objectForKey:@"title"],[dictInsert objectForKey:@"work_phone"],[dictInsert objectForKey:@"work_mobile_phone"],[dictInsert objectForKey:@"work_email"],[dictInsert objectForKey:@"work_www"],[dictInsert objectForKey:@"work_address1"],[dictInsert objectForKey:@"work_suburb"],[dictInsert objectForKey:@"work_city"],[dictInsert objectForKey:@"work_state"],[dictInsert objectForKey:@"work_country"],[dictInsert objectForKey:@"work_post_code"],[dictInsert objectForKey:@"bizcard"],[dictInsert objectForKey:@"image"],[dictInsert objectForKey:@"logo"],@"",@"",@"",@"",[dictInsert objectForKey:@"created"],[dictInsert objectForKey:@"Event"],[arrId objectAtIndex:1]];
                    
                    
                    if([Database executeScalerQuery:insertQuery])
                    {
                        NSLog(@"Data Inserted!");
                    }
                    else
                    {
                        
                    }
                    
                    
                    //insert into category relation table
                    if(![[dictInsert objectForKey:@"tag"]boolValue]==0)
                    {
                        NSArray *arrtags = [[dictInsert objectForKey:@"tag"] componentsSeparatedByString:@","];
                        
                        for(int i=0;i<[arrtags count];i++)
                        {
                            
                            NSString *Query=[NSString stringWithFormat:@"insert into Tag_Contact_relation (tag_id,contact_id)values ('%@','%@')",[arrtags objectAtIndex:i],[arrId objectAtIndex:1]];
                            
                            if([Database executeScalerQuery:Query])
                            {
                                NSLog(@"Data Inserted!");
                            }
                            else
                            {
                                
                            }

                        }
                        
                    }
                    //insert into Tag relation table
                    if([[dictInsert objectForKey:@"category"]length]>0)
                    {
                       
                        NSArray *items = [[dictInsert objectForKey:@"category"] componentsSeparatedByString:@","];
                        
                        NSString *Query=[NSString stringWithFormat:@"insert into Categorie_contact_relation (cate_id,contact_id)values ('%@','%@')",[items objectAtIndex:0],[arrId objectAtIndex:1]];
                        
                        if([Database executeScalerQuery:Query])
                        {
                            NSLog(@"Data Inserted!");
                        }
                        else
                        {
                            
                        }
                    }
                    
                }
                
                //insert into usagestatusstatastic
                NSString *Query1=[NSString stringWithFormat:@"insert into SubmitUsageStatistics(send2friend,tagSearch,shareEmail,shareText)values ('%d','%d','%d','%d')",0,0,0,0];
                [Database executeQuery:Query1];
                
               [self callWebserviceForGetCategories];
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
-(void)callWebserviceForGetCategories
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateCategories" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"get" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            
           if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
           {
               [dict removeObjectForKey:@"Response"];
               [dict removeObjectForKey:@"Count"];
               
               for (NSString *strkey in dict) {
                   
                   NSLog(@"%@",[strkey stringByReplacingOccurrencesOfString:@"Category" withString:@""]);
                   NSLog(@"%@",[dict objectForKey:strkey]);
                   
                   NSString *insertQuery=[NSString stringWithFormat:@"insert into Categories (cate_id,cate_name)values (%@,'%@')",[strkey stringByReplacingOccurrencesOfString:@"Category" withString:@""],[dict objectForKey:strkey]];
                   
                   if([Database executeScalerQuery:insertQuery])
                   {
                       NSLog(@"Data Inserted!");
                   }
                   else
                   {
                       
                   }
                   
               }
               [self callWebserviceForGetTags];
               

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
-(void)callWebserviceForGetTags
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateTags" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"get" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                [dict removeObjectForKey:@"Response"];
                [dict removeObjectForKey:@"Count"];
                
                for (NSString *strkey in dict) {
                    
                    NSLog(@"%@",[strkey stringByReplacingOccurrencesOfString:@"tag" withString:@""]);
                    NSLog(@"%@",[dict objectForKey:strkey]);
                    
                    NSString *insertQuery=[NSString stringWithFormat:@"insert into Tag (tag_id,tag_name)values (%@,'%@')",[strkey stringByReplacingOccurrencesOfString:@"tag" withString:@""],[dict objectForKey:strkey]];
                    
                    if([Database executeScalerQuery:insertQuery])
                    {
                        NSLog(@"Data Inserted!");
                    }
                    else
                    {
                        
                    }
                    
                    
                }
//                ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                [self.navigationController pushViewController:vcContact animated:YES];
                [self callWebserviceForGetFavorites];
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
-(void)callWebserviceForGetFavorites
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateFavourites" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"get" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
               
                 for (NSString *strkey in [[dict objectForKey:@"Favourites"] componentsSeparatedByString:@","]) {
                    
                 NSString *query= [NSString stringWithFormat:@"update Contact_Detail set Favorite='%@' where contact_id='%@'",
                                      [NSString stringWithFormat:@"1"],strkey];
                    
              
                    if([Database executeScalerQuery:query])
                    {
                        NSLog(@"Data Inserted!");
                    }
                    else
                    {
                        
                    }
                    
                }
                ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
                [self.navigationController pushViewController:vcContact animated:YES];
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

#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//        [scrlView setViewframe:textField forSuperView:self.view];
    self.txtFieldCheck=textField;
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    //[userDefault setObject:textField.text forKey:@"event"];
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


//old code
/*
 
 -(void)callWebserviceForGetMyContact:(NSMutableDictionary *)dict
 {
 if ([self isNetworkReachable])
 {
 [self showHud];
 if(!self.service)
 {
 self.service=[[Webservice alloc] init];
 }
 
 
 //        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
 //        [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
 //        [dict setObject:@"1.14" forKey:@"version"];
 //        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
 //
 //        NSString *strId=@"";
 //
 //        for (int i=0; i<totalContact; i++) {
 //
 //            if ([strId isEqualToString:@""]) {
 //                strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",i+1]]];
 //            }
 //            else
 //            {
 //                strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",i+1]]];
 //            }
 //        }
 //
 //        [dict setObject:strId forKey:@"senders"];
 
 
 NSLog(@"dict := %@", dict);
 
 Webservice *service1=[[Webservice alloc]init];
 
 [service1 callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
 NSLog(@"dict %@",dict);
 [self hidHud];
 if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
 {
 int i=[[dict objectForKey:@"Count"] intValue];
 
 for (int j=1; j<=i; j++) {
 
 NSString *strKey=[NSString stringWithFormat:@"Contact%d",j];
 strKey=[dictContactResponse objectForKey:strKey];
 
 NSMutableDictionary *dictInsert=[NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:[NSString stringWithFormat:@"id %@",strKey]]];
 //                    NSString *strName=[dictInsert objectForKey:@"given_name"];
 //                    [dictInsert removeObjectForKey:@"given_name"];
 //                    [dictInsert setObject:strName forKey:@"first_name"];
 //                    strName=[dictInsert objectForKey:@"family_name"];
 //                    [dictInsert removeObjectForKey:@"family_name"];
 //                    [dictInsert setObject:strName forKey:@"last_name"];
 //                    [dictInsert setObject:[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",j]] forKey:@"cid"];
 
 NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
 
 [tmpDict setObject:[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",j]] forKey:@"cid"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"given_name"]) forKey:@"first_name"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"family_name"]) forKey:@"last_name"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"mobile_phone"]) forKey:@"mobile_phone"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"desk_phone"]) forKey:@"desk_phone"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"home_phone"]) forKey:@"home_phone"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"email"]) forKey:@"email"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"company"]) forKey:@"company"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"title"]) forKey:@"title"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address1"]) forKey:@"address1"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address2"]) forKey:@"address2"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address3"]) forKey:@"address3"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"suburb"]) forKey:@"suburb"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"post_code"]) forKey:@"post_code"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"city"]) forKey:@"city"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"state"]) forKey:@"state"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"country"]) forKey:@"country"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"image"]) forKey:@"image_url"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"logo"]) forKey:@"logo_url"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_facebook"]) forKey:@"facebook"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_twitter"]) forKey:@"twitter"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_linkedin"]) forKey:@"linkedIn"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_Skype"]) forKey:@"skype"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"www"]) forKey:@"website"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"layout"]) forKey:@"layout"];
 
 [Database insert:@"tbl_profile" data:tmpDict];
 
 }
 
 //                HomeViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
 //                [self.navigationController pushViewController:vcHome animated:YES];
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
 
 
 
 */




/*
 -(void)callWebserviceForGetMyContact
 {
 if ([self isNetworkReachable])
 {
 [self showHud];
 if(!self.service)
 {
 self.service=[[Webservice alloc] init];
 }
 
 NSMutableDictionary *dict=[NSMutableDictionary dictionary];
 [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
 [dict setObject:@"1.14" forKey:@"version"];
 [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
 
 NSString *strId=@"";
 
 for (int i=0; i<totalContact; i++) {
 
 if ([strId isEqualToString:@""]) {
 strId=[NSString stringWithFormat:@"%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",i+1]]];
 }
 else
 {
 strId=[strId stringByAppendingFormat:@",%@",[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",i+1]]];
 }
 }
 
 [dict setObject:strId forKey:@"senders"];
 
 
 NSLog(@"dict := %@", dict);
 
 [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
 NSLog(@"dict %@",dict);
 [self hidHud];
 if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
 {
 int i=[[dict objectForKey:@"Count"] intValue];
 
 for (int j=1; j<=i; j++) {
 
 NSString *strKey=[NSString stringWithFormat:@"Contact%d",j];
 strKey=[dictContactResponse objectForKey:strKey];
 
 NSMutableDictionary *dictInsert=[NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:[NSString stringWithFormat:@"id %@",strKey]]];
 //                    NSString *strName=[dictInsert objectForKey:@"given_name"];
 //                    [dictInsert removeObjectForKey:@"given_name"];
 //                    [dictInsert setObject:strName forKey:@"first_name"];
 //                    strName=[dictInsert objectForKey:@"family_name"];
 //                    [dictInsert removeObjectForKey:@"family_name"];
 //                    [dictInsert setObject:strName forKey:@"last_name"];
 //                    [dictInsert setObject:[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",j]] forKey:@"cid"];
 
 NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
 
 [tmpDict setObject:[dictContactResponse objectForKey:[NSString stringWithFormat:@"Contact%d",j]] forKey:@"cid"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"given_name"]) forKey:@"first_name"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"family_name"]) forKey:@"last_name"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"mobile_phone"]) forKey:@"mobile_phone"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"desk_phone"]) forKey:@"desk_phone"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"home_phone"]) forKey:@"home_phone"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"email"]) forKey:@"email"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"company"]) forKey:@"company"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"title"]) forKey:@"title"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address1"]) forKey:@"address1"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address2"]) forKey:@"address2"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"address3"]) forKey:@"address3"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"suburb"]) forKey:@"suburb"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"post_code"]) forKey:@"post_code"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"city"]) forKey:@"city"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"state"]) forKey:@"state"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"country"]) forKey:@"country"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"image"]) forKey:@"image_url"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"logo"]) forKey:@"logo_url"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_facebook"]) forKey:@"facebook"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_twitter"]) forKey:@"twitter"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_linkedin"]) forKey:@"linkedIn"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"social_Skype"]) forKey:@"skype"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"www"]) forKey:@"website"];
 [tmpDict setObject:SAFESTRING([dictInsert objectForKey:@"layout"]) forKey:@"layout"];
 
 [Database insert:@"tbl_profile" data:tmpDict];
 
 }
 
 HomeViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
 [self.navigationController pushViewController:vcHome animated:YES];
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
 }*/

