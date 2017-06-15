//
//  SocialProfileViewController.m
//  Tapt
//
//  Created by TriState  on 6/20/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "SocialProfileViewController.h"
#import "Constants.h"
#import "Webservice.h"
#import "NSString+Extensions.h"
#import "Database.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
@interface SocialProfileViewController ()
{
    NSMutableData *mutableData;
    //    NSUserDefaults *userDefault;
    BOOL isImage;
    BOOL isLogo;
    NSInteger btnSel;
}
@end

@implementation SocialProfileViewController

@synthesize arrKeyForShare;
@synthesize oAuthLoginView;

@synthesize lblFacebookName,lblLinkedInName,lblTwitterName;
@synthesize btnFacebookLogin,btnTwitterLogin,btnLinkedInLogin;

@synthesize scrlView;
@synthesize txtFieldCheck,txtSkypename;

@synthesize btnFacebookSetup,btnTwitterSetup,btnLinkedInSetup;

@synthesize btnFacebook;//1
@synthesize btnLinkedIn;//2
@synthesize btnTwitter;//3
@synthesize btnSkyp;//4

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    arrKeyForShare= [[NSMutableArray alloc]initWithObjects:@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype", nil];
    
    scrlView.contentSize=self.contentView.frame.size;
    
    
   // [Database createEditableCopyOfDatabaseIfNeeded];
    
    
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
    
    
    lblFacebookName.hidden=YES;
    lblTwitterName.hidden=YES;
    lblLinkedInName.hidden=YES;
    
    //put by kishan
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    [[FBSession activeSession] closeAndClearTokenInformation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDelegate setShouldRotate:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    
   // if ([userDefault objectForKey:@"isFirstTime"] || [userDefault objectForKey:@"isFBLogin"]) {
            
            txtSkypename.text=[userDefault objectForKey:@"skypeId"];
            if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
                
                NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
                lblFacebookName.text=[NSString stringWithFormat:@"%@ %@",[dictFB objectForKey:@"FBFirstName"],[dictFB objectForKey:@"FBLastName"]];
                [btnFacebookLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
                lblFacebookName.hidden=NO;
                btnFacebook.userInteractionEnabled=YES;
                [btnFacebookSetup setTitle:@"" forState:UIControlStateSelected];
                btnFacebookSetup.selected=YES;
                //            [btnFacebookSetup setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
            else
            {
                btnFacebook.userInteractionEnabled=NO;
            }
            
            if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
                lblTwitterName.text=[userDefault objectForKey:@"TWName"];
                [btnTwitterLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
                lblTwitterName.hidden=NO;
                btnTwitter.userInteractionEnabled=YES;
                [btnTwitterSetup setTitle:@"" forState:UIControlStateSelected];
                btnTwitterSetup.selected=YES;
                //            [btnTwitterSetup setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
            else
            {
                btnTwitter.userInteractionEnabled=NO;
            }
            
            if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
                lblLinkedInName.text=[userDefault objectForKey:@"LKName"];
                [btnLinkedInLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
                lblLinkedInName.hidden=NO;
                btnLinkedIn.userInteractionEnabled=YES;
                [btnLinkedInSetup setTitle:@"" forState:UIControlStateSelected];
                btnLinkedInSetup.selected=YES;
                //            [btnLinkedInSetup setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
            else
            {
                btnLinkedIn.userInteractionEnabled=NO;
            }
            
       // }
       // else
       // {
            // btnFacebook.userInteractionEnabled=NO;
            //btnTwitter.userInteractionEnabled=NO;
            //btnLinkedIn.userInteractionEnabled=NO;
       // }
    
    
    
    for (NSString *key in arrKeyForShare) {
        
        switch ([arrKeyForShare indexOfObject:key]) {
            case 0:
                
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:0]] integerValue]) {
                    case 2:
                        [btnFacebook setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnFacebook setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnFacebook setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 1:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:1]] integerValue]) {
                    case 2:
                        [btnTwitter setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnTwitter setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnTwitter setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 2:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:2]] integerValue]) {
                    case 2:
                        [btnLinkedIn setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnLinkedIn setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnLinkedIn setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 3:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:3]] integerValue]) {
                    case 2:
                        [btnSkyp setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnSkyp setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnSkyp setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
                          
            default:
                break;
        }       
        
    }
    
    
}
- (IBAction)btnShareFieldStatusAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case 1:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:0]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnFacebook setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnFacebook setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnFacebook setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:1]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnTwitter setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnTwitter setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnTwitter setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 3:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:2]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnLinkedIn setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnLinkedIn setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnLinkedIn setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 4:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:3]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnSkyp setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnSkyp setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnSkyp setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
                    
        default:
            break;
    }
    
}


- (IBAction)btnBackAction:(id)sender {
     [self.currentTextField resignFirstResponder];
    [self callWebservice];
}
- (IBAction)btnFacebookAction:(id)sender {
    
//        if ([FBSession activeSession].state != FBSessionStateOpen &&
//            [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
//    
//            [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
//    
//        }
//        else
//        {
//            // Close an existing session.
//            [[FBSession activeSession] closeAndClearTokenInformation];
//    
//        }
//    
//        [self callFbLogin];
  
 
  if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"])
  {
      
  }
  else
  {
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
   

}
- (IBAction)btnTwitterAction:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        //        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        //        [tweetSheet setInitialText:@"This is a tweet!"];
        //        [self presentViewController:tweetSheet animated:YES completion:nil];
        [self showHud];
        [self getTwInfo];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't setup now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}
- (IBAction)btnLinkedInAction:(id)sender {
    oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    //    [oAuthLoginView retain];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oAuthLoginView];
    
    [self presentViewController:oAuthLoginView animated:YES completion:nil];
    //    [self presentModalViewController:oAuthLoginView animated:YES];
    

}
#pragma mark - Login via Linked In

-(void) loginViewDidFinish:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
    
}

- (void)profileApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    //    [request release];
    
}


- (void)profileApiCallForEmail
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(email-address)"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResultForEmail:didFinish:)
                  didFailSelector:@selector(profileApiCallResultForEmail:didFail:)];
    //    [request release];
    
}


- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    //    [responseBody release];
    
    if ( profile )
    {
        //        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
        //                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        //        headline.text = [profile objectForKey:@"headline"];
        [userDefault setObject:[profile objectForKey:@"id"] forKey:@"linkedIn_id"];
        
        NSString *strName= [NSString stringWithFormat:@"%@ %@", [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        
        NSDictionary *dictUrl=[profile objectForKey:@"siteStandardProfileRequest"];
        
        [userDefault setObject:[dictUrl objectForKey:@"url"] forKey:@"linkedIn_url"];
        
        lblLinkedInName.text=strName;
        [btnLinkedInLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
        lblLinkedInName.hidden=NO;
        [userDefault setObject:@"1" forKey:@"sLinkedIn"];
        [btnTwitter setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
        
        
        btnLinkedIn.userInteractionEnabled=YES;
        
        [userDefault setObject:@"1" forKey:@"isLinkedIn"];
        [userDefault setObject:strName forKey:@"LKName"];
        
        strName=[NSString stringWithFormat:@"%@|%@|%@",[profile objectForKey:@"id"], [profile objectForKey:@"firstName"],[profile objectForKey:@"lastName"]];
        [userDefault setObject:strName forKey:@"LinkedInValue"];
        
        btnLinkedInSetup.selected=YES;
        [btnLinkedInSetup setTitle:@"" forState:UIControlStateSelected];
    }
    [self profileApiCallForEmail];
    
    // The next thing we want to do is call the network updates
    //    [self networkApiCall];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)profileApiCallResultForEmail:(OAServiceTicket *)ticket didFinish:(NSData *)data{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    //    [responseBody release];
    
    if ( profile )
    {
        //        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
        //                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        //        headline.text = [profile objectForKey:@"headline"];
        [userDefault setObject:[profile objectForKey:@"emailAddress"] forKey:@"LinkEmail"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)profileApiCallResultForEmail:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(networkApiCallResult:didFinish:)
                  didFailSelector:@selector(networkApiCallResult:didFail:)];
    //    [request release];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    //    [responseBody release];
    
    if ( [person objectForKey:@"currentStatus"] )
    {
        //        [postButton setHidden:false];
        //        [postButtonLabel setHidden:false];
        //        [statusTextView setHidden:false];
        //        [updateStatusLabel setHidden:false];
        //        status.text = [person objectForKey:@"currentStatus"];
    } else {
        //        [postButton setHidden:false];
        //        [postButtonLabel setHidden:false];
        //        [statusTextView setHidden:false];
        //        [updateStatusLabel setHidden:false];
        //        status.text = [[[[person objectForKey:@"personActivities"]
        //                         objectForKey:@"values"]
        //                        objectAtIndex:0]
        //                       objectForKey:@"body"];
        
    }
    
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}




#pragma mark - get Fb info Method
-(void)callFbLogin
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        [self showHud];
        [self getFbInfo];
        //        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        //        [fbPostSheet setInitialText:@"This is a Facebook post!"];
        //        [self presentViewController:fbPostSheet animated:YES completion:nil];
        
    } else{
        //        [self hidHud];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't setup now, make sure your device has an internet connection and you have at least one facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}


-(void)getFbInfo
{
    self->accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self->accountStore accountTypeWithAccountTypeIdentifier:
                                   ACAccountTypeIdentifierFacebook];
    NSString *key = FACEBOOK_APP_ID; //put your own key from FB here
    NSDictionary *dictFB =@{ACFacebookAppIdKey :key,
                            ACFacebookPermissionsKey : @[@"email"],
                            ACFacebookAudienceKey : ACFacebookAudienceFriends}; //use ACAccountStore to help create your dictionary
    [self->accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB
                                             completion: ^(BOOL granted, NSError *e)
     {
         if (granted) {
             
             NSArray *accounts = [self->accountStore accountsWithAccountType:FBaccountType];
             ACAccount *facebookAccount = [accounts lastObject];
             
             NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
             SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
             request.account = facebookAccount;
             
             [request performRequestWithHandler:^(NSData *data,NSHTTPURLResponse *response,NSError *error)
              {
                  if(!error){
                      
                      NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                      
                      [userDefault setObject:[list objectForKey:@"id"] forKey:@"fbid"];
                      [userDefault setObject:[list objectForKey:@"link"] forKey:@"fblink"];
                      
                      NSLog(@"Dictionary contains: %@", list );
                      
                      NSString *strFBName=[NSString stringWithFormat:@"%@ %@",[list objectForKey:@"first_name"],[list objectForKey:@"last_name"]];
                      
                      lblFacebookName.text=strFBName;
                      [userDefault setObject:@"1" forKey:@"isFacebook"];
                      
                      [userDefault setObject:strFBName forKey:@"FBName"];
                      
                      
                      [btnFacebookLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
                      lblFacebookName.hidden=NO;
                     
                      btnFacebook.userInteractionEnabled=YES;
                      
                      btnFacebookSetup.selected=YES;
                      [btnFacebookSetup setTitle:@"" forState:UIControlStateSelected];
                      
                      [self hidHud];
                      
                      [UIAlertView infoAlertWithMessage:@"Facebook Account Successfully setup to Tapt!" andTitle:APP_NAME];
                      
                      //                                                            dispatch_async(dispatch_get_main_queue(), ^{
                      //                                                                [self callLoginWebserviceWithFB:[list objectForKey:@"id"]];
                      //                                                            });
                      
                  }
                  else{
                      //handle error gracefully
                  }
              }];
         }
         else {
             [self hidHud];
             //Fail gracefully...
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self hidHud];
                 [UIAlertView infoAlertWithMessage:@"Make sure you have at least one facebook account setup" andTitle:APP_NAME];
             });
             
             NSLog(@"error getting permission %@",e);
         }
     }];
}


//method put by kishan
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
                     
                                       
                     [userDefault setObject:@"1" forKey:@"isFacebook"];
                     
                     [userDefault setObject:[result objectForKey:@"id"] forKey:@"fbid"];
                     [userDefault setObject:[result objectForKey:@"link"] forKey:@"fblink"];
                     
                     
                     NSString *strFBName=[NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                     
                     lblFacebookName.text=strFBName;
                     [userDefault setObject:@"1" forKey:@"isFacebook"];
                     [userDefault setObject:strFBName forKey:@"FBName"];
                     
                     [btnFacebookLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
                     lblFacebookName.hidden=NO;
                     [userDefault setObject:@"1" forKey:@"sFacebook"];
                     [btnFacebook setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                     
                     btnFacebook.userInteractionEnabled=YES;
                     
                     btnFacebookSetup.selected=YES;
                     [btnFacebookSetup setTitle:@"" forState:UIControlStateSelected];
                     
                    
                     
                     
                     NSMutableDictionary *dictFBData=[NSMutableDictionary dictionary];
                     [dictFBData setObject:[result objectForKey:@"first_name"] forKey:@"FBFirstName"];
                     [dictFBData setObject:[result objectForKey:@"last_name"] forKey:@"FBLastName"];
                     [dictFBData setObject:[result objectForKey:@"id"] forKey:@"fbid"];
                     [dictFBData setObject:[result objectForKey:@"link"] forKey:@"fblink"];
                     [dictFBData setObject:[result objectForKey:@"email"] forKey:@"fbEmail"];
                     
                     [userDefault setObject:dictFBData forKey:@"FBData"];
                     
                     [self hidHud];
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



#pragma mark - Get Twitter info Method

- (void) getTwInfo
{
    accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            [self hidHud];
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            [self hidHud];
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            NSString *strUsername= [(NSDictionary *)TWData objectForKey:@"screen_name"];
                            NSString *strId=[(NSDictionary *)TWData objectForKey:@"id"];
                            [userDefault setObject:strUsername forKey:@"tw_username"];
                            [userDefault setObject:strId forKey:@"twId"];
                            
                            lblTwitterName.text=strUsername;
                            [userDefault setObject:@"1" forKey:@"sTwitter"];
                            [btnTwitter setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                            
                            
                            [userDefault setObject:@"1" forKey:@"isTwitter"];
                            [userDefault setObject:strUsername forKey:@"TWName"];
                            
                            
                            [btnTwitterLogin setTitleEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, 0)];
                            lblTwitterName.hidden=NO;
                            
                            btnTwitter.userInteractionEnabled=YES;
                            
                            btnTwitterSetup.selected=YES;
                            [btnTwitterSetup setTitle:@"" forState:UIControlStateSelected];
                            
                            [self hidHud];
                            
                            //                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            //                            [dict setValue:[NSString stringWithFormat:@"%@", strId] forKey:@"id"];
                            //                            [dict setValue:strUsername forKey:@"screen_name"];
                            //                            [dict setValue:name forKey:@"name"];
                            //                            [dict setValue:[NSString stringWithFormat:@"%d",followers] forKey:@"folloers"];
                            //                            [dict setValue:[NSString stringWithFormat:@"%d",following] forKey:@"following"];
                            
                            
                            
                            [UIAlertView infoAlertWithMessage:@"Twitter Account Successfully setup to Tapt!" andTitle:APP_NAME];
                            //                            [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":dict,@"message":@""} waitUntilDone:YES];
                            
                        }
                    });
                }];
            }
        } else {
            [self hidHud];
            NSLog(@"No access granted");
        }
    }];
}

-(void)performTwitterDelegateMethodwithDict:(NSMutableDictionary *)dict{
    NSMutableDictionary *dictinfo = [dict valueForKey:@"info"];
    NSString *message = [dict valueForKey:@"message"];
    
    //    if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)])
    //        [_delegate twUserDetailWithData:dictinfo withMessage:message];
    
    [self twUserDetailWithData:dictinfo withMessage:message];
}
#pragma mark - Custom Method

-(void)callWebservice
{
    UserDetail *userDtl=[UserDetail sharedInstance];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    
        [dict setObject:@"update" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
    
    [dict setObject:userDtl.firstName forKey:@"given_name"];
    [dict setObject:userDtl.lastName forKey:@"family_name"];
   
    [dict setObject:userDtl.MobileNumber forKey:@"home_mobile_phone"];
    
    [dict setObject:userDtl.homePhone forKey:@"home_phone"];
    [dict setObject:@"" forKey:@"home_phone2"];
    
    
    [dict setObject:userDtl.homeEmail forKey:@"home_email"];
    [dict setObject:@"" forKey:@"home_www"];
    
    [dict setObject:userDtl.homeAddress forKey:@"home_address1"];
    [dict setObject:@"" forKey:@"home_address2"];
    [dict setObject:@"" forKey:@"home_address3"];
    
    [dict setObject:userDtl.homeStreet forKey:@"home_suburb"];
    [dict setObject:userDtl.homeCity forKey:@"home_city"];
    [dict setObject:userDtl.homeState forKey:@"home_state"];
    [dict setObject:userDtl.homeCountry  forKey:@"home_country"];
    [dict setObject:userDtl.homePostCode forKey:@"home_post_code"];
    
    [dict setObject:userDtl.companyName forKey:@"company"];
    [dict setObject:userDtl.title forKey:@"title"];
    
    [dict setObject:userDtl.officeMobilenumber forKey:@"work_mobile_phone"];
    [dict setObject:userDtl.officePhonenumber forKey:@"work_phone"];
    [dict setObject:@"" forKey:@"work_phone2"];
    
    [dict setObject:userDtl.officeEmail forKey:@"work_email"];
    [dict setObject:userDtl.Website forKey:@"work_www"];
    [dict setObject:userDtl.officeAddress forKey:@"work_address1"];
    [dict setObject:@"" forKey:@"work_address2"];
    [dict setObject:@"" forKey:@"work_address3"];
    [dict setObject:userDtl.officeStreet forKey:@"work_suburb"];
    [dict setObject:userDtl.officeCity forKey:@"work_city"];
    [dict setObject:userDtl.officeState forKey:@"work_state"];
    [dict setObject:userDtl.officeCountry forKey:@"work_country"];
    [dict setObject:userDtl.officePostCode forKey:@"work_post_code"];
    
    
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
            
            NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
            [dict setObject:[dictFB objectForKey:@"fbid"] forKey:@"social_facebook"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_facebook"];
        }
        
        if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
            if([userDefault objectForKey:@"twId"])
            {
                [dict setObject:[userDefault objectForKey:@"twId"] forKey:@"social_twitter"];
            }
            else{
                [dict setObject:@"" forKey:@"social_twitter"];
            }

        }
        else
        {
            [dict setObject:@"" forKey:@"social_twitter"];
        }
        
        if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
            
            //            [dict setObject:[userDefault objectForKey:@"LinkedInValue"] forKey:@"social_linkedin"];
            [dict setObject:[userDefault objectForKey:@"linkedIn_url"] forKey:@"social_linkedin"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_linkedin"];
        }
        
        [dict setObject:SAFESTRING([userDefault objectForKey:@"skypeId"]) forKey:@"social_skype"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"cardLayout"]) forKey:@"bizcard"];
        
  
    NSLog(@"%@",dict);
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
                
                //update into database
                NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
                    
//                    NSString *query= [NSString stringWithFormat:@"update tbl_profile set facebook='%@',twitter='%@',linkedIn='%@',skype='%@' where cid='%@'",SAFESTRING([dictFB objectForKey:@"fbid"]),SAFESTRING([userDefault objectForKey:@"twId"]),SAFESTRING([userDefault objectForKey:@"linkedIn_url"]),[NSString stringWithFormat:@"%@",txtSkypename.text],[userDefault objectForKey:@"ID"]];
//                    
//                    [Database executeQuery:query];
//                    NSLog(@"Data Updated!");
                
                
                
                NSString *query= [NSString stringWithFormat:@"update tbl_profile set given_name='%@',family_name='%@',home_mobile_phone='%@',home_phone='%@',home_email='%@',home_address1='%@',home_suburb='%@',home_city='%@',home_state='%@',home_country='%@',home_post_code='%@',company='%@',title='%@',work_phone='%@',work_mobile_phone='%@',work_email='%@',work_www='%@',work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@',layout='%@',social_facebook='%@',social_twitter='%@',social_linkedin='%@',social_Skype='%@' where cid='%@'",[NSString stringWithFormat:@"%@",userDtl.firstName],[NSString stringWithFormat:@"%@",userDtl.lastName],[NSString stringWithFormat:@"%@",userDtl.MobileNumber],[NSString stringWithFormat:@"%@",userDtl.homePhone],[NSString stringWithFormat:@"%@",userDtl.homeEmail],[NSString stringWithFormat:@"%@",userDtl.homeAddress],[NSString stringWithFormat:@"%@",userDtl.homeStreet],[NSString stringWithFormat:@"%@",userDtl.homeCity],[NSString stringWithFormat:@"%@",userDtl.homeState],[NSString stringWithFormat:@"%@",userDtl.homeCountry],[NSString stringWithFormat:@"%@",userDtl.homePostCode],[NSString stringWithFormat:@"%@",userDtl.companyName],[NSString stringWithFormat:@"%@",userDtl.title],[NSString stringWithFormat:@"%@",userDtl.officePhonenumber],[NSString stringWithFormat:@"%@",userDtl.officeMobilenumber],[NSString stringWithFormat:@"%@",userDtl.officeEmail],[NSString stringWithFormat:@"%@",userDtl.Website],[NSString stringWithFormat:@"%@",userDtl.officeAddress],[NSString stringWithFormat:@"%@",userDtl.officeStreet],[NSString stringWithFormat:@"%@",userDtl.officeCity],[NSString stringWithFormat:@"%@",userDtl.officeState],[NSString stringWithFormat:@"%@",userDtl.officeCountry],[NSString stringWithFormat:@"%@",userDtl.officePostCode],[userDefault objectForKey:@"cardLayout"],SAFESTRING([dictFB objectForKey:@"fbid"]),SAFESTRING([userDefault objectForKey:@"twId"]),SAFESTRING([userDefault objectForKey:@"linkedIn_url"]),[userDefault objectForKey:@"skypeId"],[userDefault objectForKey:@"ID"]];
                
                [Database executeQuery:query];
                NSLog(@"Data Updated!");
                
                
                
                
                //[userDefault setObject:@"1" forKey:@"isFirstTime"];
                [userDefault setObject:@"1" forKey:@"isRegistered"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [userDefault setObject:userDtl.firstName forKey:@"first_name"];
                [userDefault setObject:userDtl.lastName forKey:@"last_name"];
                [userDefault setObject:userDtl.MobileNumber forKey:@"mobile_phone"];
                [userDefault setObject:userDtl.homePhone forKey:@"homePhone"];
                [userDefault setObject:userDtl.homeEmail forKey:@"homeEmail"];
                [userDefault setObject:userDtl.homeAddress forKey:@"homeAddress"];
                [userDefault setObject:userDtl.homeStreet forKey:@"homeStreet"];
                [userDefault setObject:userDtl.homeCity forKey:@"homeCity"];
                [userDefault setObject:userDtl.homeState forKey:@"homeState"];
                [userDefault setObject:userDtl.homeCountry forKey:@"homeCountry"];
                [userDefault setObject:userDtl.homePostCode forKey:@"homePostcode"];
                [userDefault setObject:userDtl.companyName forKey:@"companyName"];
                [userDefault setObject:userDtl.title forKey:@"title"];
                [userDefault setObject:userDtl.officePhonenumber forKey:@"officePhone"];
                [userDefault setObject:userDtl.officeMobilenumber forKey:@"officeMobile"];
                [userDefault setObject:userDtl.officeEmail forKey:@"officeEmail"];
                [userDefault setObject:userDtl.Website forKey:@"officeWebsite"];
                [userDefault setObject:userDtl.officeAddress forKey:@"officeAddress"];
                [userDefault setObject:userDtl.officeStreet forKey:@"officeStreet"];
                [userDefault setObject:userDtl.officeCity forKey:@"officeCity"];
                [userDefault setObject:userDtl.officeState forKey:@"officeState"];
                [userDefault setObject:userDtl.officeCountry forKey:@"officeCountry"];
                [userDefault setObject:userDtl.officePostCode forKey:@"officePostcode"];
                
                [userDefault setObject:self.txtSkypename.text forKey:@"skypeId"];
               
                //for images
                if (appDelegate.isimage) {
                    appDelegate.isimage=NO;
                    [self uploadImage];
                }
                else
                {
                    if (appDelegate.isLogo) {
                        appDelegate.isLogo=NO;
                        [self uploadLogo];
                    }
                    else{
                        
//                        if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//                        {
//                            ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                            vcContact.hidesBottomBarWhenPushed=YES;
//                            [self.navigationController pushViewController:vcContact animated:YES];
//                            
//                        }
//                        else
//                        {
//                            UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                            vcIntro.hidesBottomBarWhenPushed=YES;
//                            [self.navigationController pushViewController:vcIntro animated:YES];
//                        }
                        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
                        
                        UINavigationController *navVc = (UINavigationController *)keyWindow.rootViewController;
                        [navVc popViewControllerAnimated:YES];

                    }
                }
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
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
-(void)uploadImage{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSData *dataOfImg=[userDefault objectForKey:@"UserImagedata"];
        
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"action=image&version=1.14&id=%@&password=%@&afile=afile",[userDefault objectForKey:@"ID"],[userDefault objectForKey:@"Salt"]];
        Webservice *service=[[Webservice alloc]init];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"image" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        [service callPOSTWebServiceWithImage:dataOfImg andParams:dict isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            
            NSString *strPicURl=[WEBSERVICE_IMG_BASE_URL stringByAppendingString:[dict objectForKey:@"Filename"]];
            
            [userDefault setObject:strPicURl forKey:@"picname"];
            
            UserDetail *userDtl=[UserDetail sharedInstance];
            userDtl.ProfilePhoto=strPicURl;
            
            NSString *query= [NSString stringWithFormat:@"update tbl_profile set image='%@' where cid='%@'", strPicURl , [userDefault objectForKey:@"ID"] ];
            
            [Database executeQuery:query];
            NSLog(@"Data Updated!");
            
            if (appDelegate.isLogo) {
                 appDelegate.isLogo=NO;
                [self uploadLogo];
            }
            else
            {
//                if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//                {
//                    ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                    vcContact.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:vcContact animated:YES];
//                    
//                }
//                else
//                {
//                    if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//                    {
//                        ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                        [self.navigationController pushViewController:vcContact animated:YES];
//                        
//                    }
//                    else
//                    {
//                        UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                        vcIntro.hidesBottomBarWhenPushed=YES;
//                        [self.navigationController pushViewController:vcIntro animated:YES];
//                    }
//
//                }
                UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
                
                UINavigationController *navVc = (UINavigationController *)keyWindow.rootViewController;
                [navVc popViewControllerAnimated:YES];

                
            }
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
            
        } onProgress:^(float progressInPercent) {
            
        }];
        
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
    
}
-(void)uploadLogo{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSData *dataOfImg=[userDefault objectForKey:@"logoImagedata"];
        
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"action=logo&version=1.14&id=%@&password=%@&afile=afile",[userDefault objectForKey:@"ID"],[userDefault objectForKey:@"Salt"]];
        Webservice *service=[[Webservice alloc]init];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"logo" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        [service callPOSTWebServiceWithImage:dataOfImg andParams:dict isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            [userDefault setObject:[dict objectForKey:@"Filename"] forKey:@"logoname"];
            
            NSString *query= [NSString stringWithFormat:@"update tbl_profile set logo='%@' where cid='%@'", [dict objectForKey:@"Filename"] , [userDefault objectForKey:@"ID"] ];
            
            [Database executeQuery:query];
            NSLog(@"Data Updated!");
            
//            if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//            {
//                ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                vcContact.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:vcContact animated:YES];
//                
//            }
//            else
//            {
//                UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                vcIntro.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:vcIntro animated:YES];
//            }

            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            
            UINavigationController *navVc = (UINavigationController *)keyWindow.rootViewController;
            [navVc popViewControllerAnimated:YES];

            
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
            
        } onProgress:^(float progressInPercent) {
            
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
    //    [scrlView setViewframe:textField forSuperView:self.view];
     self.currentTextField=textField;
    self.txtFieldCheck=textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    [scrlView resetViewframe];
   [userDefault setObject:self.txtSkypename.text forKey:@"skypeId"];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    // Not found, so remove keyboard.
    //    [self.view resetViewframe];
    [textField resignFirstResponder];
    return YES;
}



#pragma mark- TWITTER METHODS

- (void)twUserDetailWithData:(NSMutableDictionary *)dictInfo withMessage:(NSString *)message
{
    if (message.length) {
        [self hidHud];
        
        [UIAlertView infoAlertWithMessage:message andTitle:APP_NAME];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"Successfully Followed!" andTitle:APP_NAME];
        
        //        if ([self isNetworkReachable]) {
        //            [self showHud];
        //            if (isTwitter == 1) {
        //                isTwitter = 0;
        //            }
        //            else
        //                isTwitter = 1;
        //
        //            [self followUserWebservice:isTwitter];
        //        }
        //        else
        //        {
        //            [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        //        }
        
    }
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
//old code
/*-(void)webservice
 {
 //    NSString *parameter;
 NSMutableDictionary *dict=[NSMutableDictionary dictionary];
 
 if (![userDefault objectForKey:@"isFirstTime"]) {
 
 [dict setObject:@"new" forKey:@"action"];
 [dict setObject:@"1.14" forKey:@"version"];
 
 [dict setObject:[arrUserDetail valueForKey:@"first_name"] forKey:@"given_name"];
 [dict setObject:[arrUserDetail valueForKey:@"last_name"] forKey:@"family_name"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_mobile_phone"] forKey:@"home_mobile_phone"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_phone"] forKey:@"home_phone"];
 [dict setObject:[arrUserDetail valueForKey:@"home_phone2"] forKey:@"home_phone2"];
 
 
 [dict setObject:[arrUserDetail valueForKey:@"home_email"] forKey:@"home_email"];
 [dict setObject:[arrUserDetail valueForKey:@"home_www"] forKey:@"home_www"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_address1"] forKey:@"home_address1"];
 [dict setObject:[arrUserDetail valueForKey:@"home_address2"] forKey:@"home_address2"];
 [dict setObject:[arrUserDetail valueForKey:@"home_address3"] forKey:@"home_address3"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_suburb"] forKey:@"home_suburb"];
 [dict setObject:[arrUserDetail valueForKey:@"home_city"] forKey:@"home_city"];
 [dict setObject:[arrUserDetail valueForKey:@"home_state"] forKey:@"home_state"];
 [dict setObject:[arrUserDetail valueForKey:@"home_country"] forKey:@"home_country"];
 [dict setObject:[arrUserDetail valueForKey:@"home_post_code"] forKey:@"home_post_code"];
 [dict setObject:[arrUserDetail valueForKey:@"company"] forKey:@"company"];
 [dict setObject:[arrUserDetail valueForKey:@"title"] forKey:@"title"];
 
 [dict setObject:[arrUserDetail valueForKey:@"work_mobile_phone"] forKey:@"work_mobile_phone"];
 [dict setObject:[arrUserDetail valueForKey:@"work_phone"] forKey:@"work_phone"];
 [dict setObject:[arrUserDetail valueForKey:@"work_phone2"] forKey:@"work_phone2"];
 
 [dict setObject:[arrUserDetail valueForKey:@"work_email"] forKey:@"work_email"];
 [dict setObject:[arrUserDetail valueForKey:@"website"] forKey:@"website"];
 [dict setObject:[arrUserDetail valueForKey:@"work_address1"] forKey:@"work_address1"];
 [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
 [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
 [dict setObject:[arrUserDetail valueForKey:@"work_suburb"] forKey:@"work_suburb"];
 [dict setObject:[arrUserDetail valueForKey:@"work_city"] forKey:@"work_city"];
 [dict setObject:[arrUserDetail valueForKey:@"work_state"] forKey:@"work_state"];
 [dict setObject:[arrUserDetail valueForKey:@"work_country"] forKey:@"work_country"];
 [dict setObject:[arrUserDetail valueForKey:@"work_post_code"] forKey:@"work_post_code"];
 
 
 NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
 
 
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
 [dict setObject:@"" forKey:@"fbid"];
 }
 
 //social
 if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
 [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"social_facebook"];
 
 }
 else
 {
 [dict setObject:@"" forKey:@"social_facebook"];
 }
 
 if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
 [dict setObject:[userDefault objectForKey:@"twId"] forKey:@"social_twitter"];
 }
 else
 {
 [dict setObject:@"" forKey:@"social_twitter"];
 }
 
 if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
 
 //            [dict setObject:[userDefault objectForKey:@"LinkedInValue"] forKey:@"social_linkedin"];
 [dict setObject:[userDefault objectForKey:@"linkedIn_url"] forKey:@"social_linkedin"];
 
 }
 else
 {
 [dict setObject:@"" forKey:@"social_linkedin"];
 }
 
 [dict setObject:SAFESTRING([userDefault objectForKey:@"skypeId"]) forKey:@"social_skype"];
 [dict setObject:SAFESTRING([userDefault objectForKey:@"cardLayout"]) forKey:@"bizcard"];
 
 
 }
 else
 {
 //        parameter = [NSString stringWithFormat:@"action=update&version=1.14&id=%@&given_name=%@&family_name=%@&mobile_phone=%@&desk_phone=%@&home_phone=%@&email=%@&company=%@&title=%@&address1=%@&address2=%@&address3=%@&suburb=%@&post_code=%@&city=%@&state=%@&country=%@&password=%@",[userDefault objectForKey:@"ID"],txtFirstName.text , txtLastName.text , txtMobile.text , txtWorkContact.text , txtHomeContact.text , txtEmailAddress.text , txtCompany.text , txtTitle.text , txtAddress1.text , txtAddress2.text , txtAddress3.text , txtSuburb.text , txtPostCode.text , txtCity.text , txtState.text , txtCountry.text , [userDefault objectForKey:@"Salt"] ]; //Parameter values from user.
 
 
 
 [dict setObject:@"update" forKey:@"action"];
 [dict setObject:@"1.14" forKey:@"version"];
 [dict setObject:[arrUserDetail valueForKey:@"first_name"] forKey:@"given_name"];
 [dict setObject:[arrUserDetail valueForKey:@"last_name"] forKey:@"family_name"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_mobile_phone"] forKey:@"home_mobile_phone"];
 
 
 [dict setObject:[arrUserDetail valueForKey:@"home_phone"] forKey:@"home_phone"];
 [dict setObject:[arrUserDetail valueForKey:@"home_phone2"] forKey:@"home_phone2"];
 
 
 [dict setObject:[arrUserDetail valueForKey:@"home_email"] forKey:@"home_email"];
 [dict setObject:[arrUserDetail valueForKey:@"home_www"] forKey:@"home_www"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_address1"] forKey:@"home_address1"];
 [dict setObject:[arrUserDetail valueForKey:@"home_address2"] forKey:@"home_address2"];
 [dict setObject:[arrUserDetail valueForKey:@"home_address3"] forKey:@"home_address3"];
 
 [dict setObject:[arrUserDetail valueForKey:@"home_suburb"] forKey:@"home_suburb"];
 [dict setObject:[arrUserDetail valueForKey:@"home_city"] forKey:@"home_city"];
 [dict setObject:[arrUserDetail valueForKey:@"home_state"] forKey:@"home_state"];
 [dict setObject:[arrUserDetail valueForKey:@"home_country"] forKey:@"home_country"];
 [dict setObject:[arrUserDetail valueForKey:@"home_post_code"] forKey:@"home_post_code"];
 [dict setObject:[arrUserDetail valueForKey:@"company"] forKey:@"company"];
 [dict setObject:[arrUserDetail valueForKey:@"title"] forKey:@"title"];
 
 [dict setObject:[arrUserDetail valueForKey:@"work_mobile_phone"] forKey:@"work_mobile_phone"];
 [dict setObject:[arrUserDetail valueForKey:@"work_phone"] forKey:@"work_phone"];
 [dict setObject:[arrUserDetail valueForKey:@"work_phone2"] forKey:@"work_phone2"];
 
 [dict setObject:[arrUserDetail valueForKey:@"work_email"] forKey:@"work_email"];
 [dict setObject:[arrUserDetail valueForKey:@"website"] forKey:@"website"];
 [dict setObject:[arrUserDetail valueForKey:@"work_address1"] forKey:@"work_address1"];
 [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
 [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
 [dict setObject:[arrUserDetail valueForKey:@"work_suburb"] forKey:@"work_suburb"];
 [dict setObject:[arrUserDetail valueForKey:@"work_city"] forKey:@"work_city"];
 [dict setObject:[arrUserDetail valueForKey:@"work_state"] forKey:@"work_state"];
 [dict setObject:[arrUserDetail valueForKey:@"work_country"] forKey:@"work_country"];
 [dict setObject:[arrUserDetail valueForKey:@"work_post_code"] forKey:@"work_post_code"];
 
 
 [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
 [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
 
 if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
 
 NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
 [dict setObject:[dictFB objectForKey:@"fbid"] forKey:@"social_facebook"];
 
 }
 else
 {
 [dict setObject:@"" forKey:@"social_facebook"];
 }
 
 if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
 [dict setObject:[userDefault objectForKey:@"twId"] forKey:@"social_twitter"];
 }
 else
 {
 [dict setObject:@"" forKey:@"social_twitter"];
 }
 
 if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
 
 //            [dict setObject:[userDefault objectForKey:@"LinkedInValue"] forKey:@"social_linkedin"];
 [dict setObject:[userDefault objectForKey:@"linkedIn_url"] forKey:@"social_linkedin"];
 
 }
 else
 {
 [dict setObject:@"" forKey:@"social_linkedin"];
 }
 
 [dict setObject:SAFESTRING([userDefault objectForKey:@"skypeId"]) forKey:@"social_skype"];
 [dict setObject:SAFESTRING([userDefault objectForKey:@"cardLayout"]) forKey:@"bizcard"];
 
 }
 NSLog(@"%@",dict);
 if ([self isNetworkReachable])
 {
 [self showHud];
 if(!self.service)
 {
 self.service=[[Webservice alloc] init];
 }
 
 Webservice *service = [[Webservice alloc]init];
 [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
 NSLog(@"dict %@",dict);
 [self hidHud];
 if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
 
 if (![userDefault objectForKey:@"isFirstTime"]) {
 
 [userDefault setObject:[dict objectForKey:@"ID"] forKey:@"ID"];
 [userDefault setObject:[dict objectForKey:@"Salt"] forKey:@"Salt"];
 NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
 
 /* [tmpDict setObject:[userDefault objectForKey:@"ID"] forKey:@"cid"];
 [tmpDict setObject:self.txtFirstname.text forKey:@"first_name"];
 [tmpDict setObject:self.txtLastname.text forKey:@"last_name"];
 
 NSString *strConatct=[self.txtMobileNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
 [tmpDict setObject:strConatct forKey:@"home_mobile_phone"];
 
 [tmpDict setObject:userDtl.homePhone forKey:@"home_phone"];
 [tmpDict setObject:@"" forKey:@"home_phone2"];
 
 
 [tmpDict setObject:userDtl.homeEmail forKey:@"home_email"];
 [tmpDict setObject:@"" forKey:@"home_www"];
 
 [tmpDict setObject:userDtl.homeAddress forKey:@"home_address1"];
 [tmpDict setObject:@"" forKey:@"home_address2"];
 [tmpDict setObject:@"" forKey:@"home_address3"];
 
 [tmpDict setObject:userDtl.homeStreet forKey:@"home_suburb"];
 [tmpDict setObject:userDtl.homeCity forKey:@"home_city"];
 [tmpDict setObject:userDtl.homeState forKey:@"home_state"];
 [tmpDict setObject:userDtl.homeCountry forKey:@"home_country"];
 [tmpDict setObject:userDtl.homePostCode forKey:@"home_post_code"];
 
 [tmpDict setObject:userDtl.companyName forKey:@"company"];
 [tmpDict setObject:userDtl.title forKey:@"title"];
 
 [tmpDict setObject:userDtl.officeMobilenumber forKey:@"work_mobile_phone"];
 [tmpDict setObject:userDtl.officePhonenumber forKey:@"work_phone"];
 [tmpDict setObject:@"" forKey:@"work_phone2"];
 
 [tmpDict setObject:userDtl.officeEmail forKey:@"work_email"];
 [tmpDict setObject:userDtl.Website forKey:@"work_www"];
 [tmpDict setObject:userDtl.officeAddress forKey:@"work_address1"];
 [tmpDict setObject:@"" forKey:@"work_address2"];
 [tmpDict setObject:@"" forKey:@"work_address3"];
 [tmpDict setObject:userDtl.officeStreet forKey:@"work_suburb"];
 [tmpDict setObject:userDtl.officeCity forKey:@"work_city"];
 [tmpDict setObject:userDtl.officeState forKey:@"work_state"];
 [tmpDict setObject:userDtl.officeCountry forKey:@"work_country"];
 [tmpDict setObject:userDtl.officePostCode forKey:@"work_post_code"];
 
 
 NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
 
 [tmpDict setObject:SAFESTRING([dictFB objectForKey:@"fbid"]) forKey:@"facebook"];
 [tmpDict setObject:SAFESTRING([userDefault objectForKey:@"twId"]) forKey:@"twitter"];
 [tmpDict setObject:SAFESTRING([userDefault objectForKey:@"linkedIn_url"]) forKey:@"linkedIn"];
 [tmpDict setObject:@"" forKey:@"skype"];
 
 //  NSLog(@"%@",tmpDict);
 //  [Database insert:@"tbl_profile" data:tmpDict]; */


/*  NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
 
 NSString *insertQuery=[NSString stringWithFormat:@"insert into tbl_profile (facebook,twitter,linkedIn,skype,cid)values ('%@','%@','%@','%@','%@')",SAFESTRING([dictFB objectForKey:@"fbid"]),SAFESTRING([userDefault objectForKey:@"twId"]),SAFESTRING([userDefault objectForKey:@"linkedIn_url"]),[NSString stringWithFormat:@"%@",txtSkypename.text],[userDefault objectForKey:@"ID"]];
 
 if([Database executeScalerQuery:insertQuery])
 {
 NSLog(@"Data Inserted!");
 }
 else
 {
 
 }
 
 }
 else
 {
 NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
 
 NSString *query= [NSString stringWithFormat:@"update tbl_profile set facebook='%@',twitter='%@',linkedIn='%@',skype='%@' where cid='%@'",SAFESTRING([dictFB objectForKey:@"fbid"]),SAFESTRING([userDefault objectForKey:@"twId"]),SAFESTRING([userDefault objectForKey:@"linkedIn_url"]),[NSString stringWithFormat:@"%@",txtSkypename.text],[userDefault objectForKey:@"ID"]];
 
 [Database executeQuery:query];
 NSLog(@"Data Updated!");
 
 }
 
 //[userDefault setObject:@"1" forKey:@"isFirstTime"];
 [userDefault setObject:@"1" forKey:@"isRegistered"];
 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 
 [userDefault setObject:[userDefault valueForKey:@"firstName"] forKey:@"firstName"];
 [userDefault setObject:[userDefault valueForKey:@"lastName"] forKey:@"lastName"];
 [userDefault setObject:[userDefault valueForKey:@"HomeContact"] forKey:@"HomeContact"];
 
 [userDefault setObject:[userDefault valueForKey:@"homePhone"] forKey:@"homePhone"];
 [userDefault setObject:[userDefault valueForKey:@"homeEmail"] forKey:@"homeEmail"];
 [userDefault setObject:[userDefault valueForKey:@"homeEmail"] forKey:@"homeEmail"];
 [userDefault setObject:[userDefault valueForKey:@"homeStreet"] forKey:@"homeStreet"];
 [userDefault setObject:[userDefault valueForKey:@"homeCity"] forKey:@"homeCity"];
 [userDefault setObject:[userDefault valueForKey:@"homeState"] forKey:@"homeState"];
 [userDefault setObject:[userDefault valueForKey:@"homeCountry"] forKey:@"homeCountry"];
 [userDefault setObject:[userDefault valueForKey:@"homePostcode"] forKey:@"homePostcode"];
 
 [userDefault setObject:[userDefault valueForKey:@"companyName"] forKey:@"companyName"];
 [userDefault setObject:[userDefault valueForKey:@"title"] forKey:@"title"];
 [userDefault setObject:[userDefault valueForKey:@"officePhone"] forKey:@"officePhone"];
 [userDefault setObject:[userDefault valueForKey:@"officeMobile"] forKey:@"officeMobile"];
 [userDefault setObject:[userDefault valueForKey:@"officeEmail"] forKey:@"officeEmail"];
 [userDefault setObject:[userDefault valueForKey:@"officeWebsite"] forKey:@"officeWebsite"];
 [userDefault setObject:[userDefault valueForKey:@"officeAddress"] forKey:@"officeAddress"];
 [userDefault setObject:[userDefault valueForKey:@"officeStreet"] forKey:@"officeStreet"];
 [userDefault setObject:[userDefault valueForKey:@"officeCity"] forKey:@"officeCity"];
 [userDefault setObject:[userDefault valueForKey:@"officeState"] forKey:@"officeState"];
 [userDefault setObject:[userDefault valueForKey:@"officeCountry"] forKey:@"officeCountry"];
 [userDefault setObject:[userDefault valueForKey:@"officePostcode"] forKey:@"officePostcode"];
 [userDefault setObject:txtSkypename.text forKey:@"skypeId"];
 
 
 
 UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
 [self.navigationController pushViewController:vcHome animated:YES];
 
 }
 else
 {
 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
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
 } */

@end
