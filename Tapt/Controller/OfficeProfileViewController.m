//
//  OfficeProfileViewController.m
//  Tapt
//
//  Created by TriState  on 6/20/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "OfficeProfileViewController.h"
#import "Constants.h"
#import "Webservice.h"
#import "NSString+Extensions.h"
#import "Database.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"

@interface OfficeProfileViewController ()
{
    NSMutableData *mutableData;
    NSInteger btnSel;

}
@end

@implementation OfficeProfileViewController

@synthesize arrKeyForShare;
@synthesize oAuthLoginView;

@synthesize scrlView;
@synthesize txtOfficeAddress,txtStreet,txtCity,txtCountry,txtPostCode,txtState,txtFieldCheck;



@synthesize btnOfficeAddress;//1
@synthesize btnStreet;//2
@synthesize btnCity;//3
@synthesize btnState;//4
@synthesize btnCountry;//5
@synthesize btnPostCode;//6

@synthesize mask;
#pragma mark - View Life Cycle

- (MaskedTextField *) mask
{
    if (mask == nil) {
        MaskFormatter *cnpjFormatter = [[MaskFormatter alloc] initWithMask:@"___-___-____"];
        mask = [[MaskedTextField alloc] initWithFormatter:cnpjFormatter];
    }
    return mask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
    self.tabBarController.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
   
    
    arrKeyForShare= [[NSMutableArray alloc]initWithObjects:@"sOfficeAddress",@"sOfficeStreet",@"sOfficeCity",@"sOfficeState",@"sOfficeCountry",@"sOfficePostcode",nil];
    
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
        NSLog(@"%@",[userDefault objectForKey:@"sOfficePostcode"]);
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDelegate setShouldRotate:NO];
    
    UserDetail *userDtl=[UserDetail sharedInstance];

    txtOfficeAddress.text=userDtl.officeAddress;
    txtStreet.text=userDtl.officeStreet;
    txtCity.text=userDtl.officeCity;
    txtState.text=userDtl.officeState;
    txtCountry.text=userDtl.officeCountry;
    txtPostCode.text=userDtl.officePostCode;
   
    
    
   /* NSString *query =[NSString stringWithFormat:@"select * from tbl_profile where cid='%@'",[userDefault objectForKey:@"ID"]];
    arrUserDetail=[[NSMutableArray alloc]init];
    arrUserDetail=[Database executeQuery:query];
    NSLog(@"%@",arrUserDetail);
   
    if(arrUserDetail.count>0)
    {
        txtOfficeAddress.text=[[arrUserDetail valueForKey:@"work_address1"]objectAtIndex:0];
        txtStreet.text=[[arrUserDetail valueForKey:@"work_suburb"]objectAtIndex:0];
        txtCity.text=[[arrUserDetail valueForKey:@"work_city"]objectAtIndex:0];
        txtState.text=[[arrUserDetail valueForKey:@"work_state"]objectAtIndex:0];
        txtCountry.text=[[arrUserDetail valueForKey:@"work_country"]objectAtIndex:0];
        txtPostCode.text=[[arrUserDetail valueForKey:@"work_post_code"]objectAtIndex:0];
    } */
    
  
    for (NSString *key in arrKeyForShare) {
        
        switch ([arrKeyForShare indexOfObject:key]) {
            case 0:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:0]] integerValue]) {
                    case 2:
                        [btnOfficeAddress setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnOfficeAddress setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnOfficeAddress setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 1:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:1]] integerValue]) {
                    case 2:
                        [btnStreet setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnStreet setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnStreet setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 2:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:2]] integerValue]) {
                    case 2:
                        [btnCity setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnCity setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnCity setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 3:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:3]] integerValue]) {
                    case 2:
                        [btnState setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnState setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnState setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 4:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:4]] integerValue]) {
                    case 2:
                        [btnCountry setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnCountry setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnCountry setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 5:
               
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:5]] integerValue]) {
                    case 2:
                        [btnPostCode setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnPostCode setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnPostCode setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
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


-(void)viewWillDisappear:(BOOL)animated
{
    UserDetail *userDtl=[UserDetail sharedInstance];
    userDtl.officeAddress=[NSString stringWithFormat:@"%@",txtOfficeAddress.text];
    userDtl.officeStreet=[NSString stringWithFormat:@"%@",txtStreet.text];
    userDtl.officeCity=[NSString stringWithFormat:@"%@",txtCity.text];
    userDtl.officeState=[NSString stringWithFormat:@"%@",txtState.text];
    userDtl.officeCountry=[NSString stringWithFormat:@"%@",txtCountry.text];
    userDtl.officePostCode=[NSString stringWithFormat:@"%@",txtPostCode.text];
}
- (IBAction)btnBackAction:(id)sender {
    [self.currentTextField resignFirstResponder];
    [self callWebservice];

}
- (IBAction)btnShareFieldStatusAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case 1:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:0]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnOfficeAddress setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnOfficeAddress setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnOfficeAddress setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:1]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnStreet setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnStreet setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnStreet setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 3:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:2]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnCity setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnCity setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnCity setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 4:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:3]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnState setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnState setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnState setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 5:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:4]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:4]];
                    [btnCountry setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:4]];
                    [btnCountry setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:4]];
                    [btnCountry setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 6:
            
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:5]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:5]];
                    [btnPostCode setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:5]];
                    [btnPostCode setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:5]];
                    [btnPostCode setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
                  
        default:
            break;
    }
    
}
#pragma mark - Custom Method

-(void)callWebservice
{
     UserDetail *userDtl=[UserDetail sharedInstance];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
        [dict setObject:@"update" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
    
      /*  [dict setObject:[arrUserDetail valueForKey:@"first_name"] forKey:@"given_name"];
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
       
        [dict setObject:[NSString stringWithFormat:@"%@",txtOfficeAddress.text] forKey:@"work_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtStreet.text] forKey:@"work_suburb"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtCity.text] forKey:@"work_city"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtState.text] forKey:@"work_state"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtCountry.text] forKey:@"work_country"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtPostCode.text] forKey:@"work_post_code"]; */
    
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
    [dict setObject:[NSString stringWithFormat:@"%@",txtOfficeAddress.text] forKey:@"work_address1"];
    [dict setObject:@"" forKey:@"work_address2"];
    [dict setObject:@"" forKey:@"work_address3"];
    [dict setObject:[NSString stringWithFormat:@"%@",txtStreet.text] forKey:@"work_suburb"];
    [dict setObject:[NSString stringWithFormat:@"%@",txtCity.text] forKey:@"work_city"];
    [dict setObject:[NSString stringWithFormat:@"%@",txtState.text] forKey:@"work_state"];
    [dict setObject:[NSString stringWithFormat:@"%@",txtCountry.text] forKey:@"work_country"];
    [dict setObject:[NSString stringWithFormat:@"%@",txtPostCode.text] forKey:@"work_post_code"];

    
    
    
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
                
                
                //update into table
            //NSString *query= [NSString stringWithFormat:@"update tbl_profile set work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@' where cid='%@'",[NSString stringWithFormat:@"%@",txtOfficeAddress.text],[NSString stringWithFormat:@"%@",txtStreet.text],[NSString stringWithFormat:@"%@",txtCity.text],[NSString stringWithFormat:@"%@",txtState.text],[NSString stringWithFormat:@"%@",txtCountry.text],[NSString stringWithFormat:@"%@",txtPostCode.text],[userDefault objectForKey:@"ID"]];
                
                NSString *query= [NSString stringWithFormat:@"update tbl_profile set given_name='%@',family_name='%@',home_mobile_phone='%@',home_phone='%@',home_email='%@',home_address1='%@',home_suburb='%@',home_city='%@',home_state='%@',home_country='%@',home_post_code='%@',company='%@',title='%@',work_phone='%@',work_mobile_phone='%@',work_email='%@',work_www='%@',work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@',layout='%@',social_facebook='%@',social_twitter='%@',social_linkedin='%@',social_Skype='%@' where cid='%@'",[NSString stringWithFormat:@"%@",userDtl.firstName],[NSString stringWithFormat:@"%@",userDtl.lastName],[NSString stringWithFormat:@"%@",userDtl.MobileNumber],[NSString stringWithFormat:@"%@",userDtl.homePhone],[NSString stringWithFormat:@"%@",userDtl.homeEmail],[NSString stringWithFormat:@"%@",userDtl.homeAddress],[NSString stringWithFormat:@"%@",userDtl.homeStreet],[NSString stringWithFormat:@"%@",userDtl.homeCity],[NSString stringWithFormat:@"%@",userDtl.homeState],[NSString stringWithFormat:@"%@",userDtl.homeCountry],[NSString stringWithFormat:@"%@",userDtl.homePostCode],[NSString stringWithFormat:@"%@",userDtl.companyName],[NSString stringWithFormat:@"%@",userDtl.title],[NSString stringWithFormat:@"%@",userDtl.officePhonenumber],[NSString stringWithFormat:@"%@",userDtl.officeMobilenumber],[NSString stringWithFormat:@"%@",userDtl.officeEmail],[NSString stringWithFormat:@"%@",userDtl.Website],[NSString stringWithFormat:@"%@",txtOfficeAddress.text],[NSString stringWithFormat:@"%@",txtStreet.text],[NSString stringWithFormat:@"%@",txtCity.text],[NSString stringWithFormat:@"%@",txtState.text],[NSString stringWithFormat:@"%@",txtCountry.text],[NSString stringWithFormat:@"%@",txtPostCode.text],[userDefault objectForKey:@"cardLayout"],SAFESTRING([userDefault objectForKey:@"fbid"]),SAFESTRING([userDefault objectForKey:@"twId"]),SAFESTRING([userDefault objectForKey:@"linkedIn_url"]),[userDefault objectForKey:@"social_skype"],[userDefault objectForKey:@"ID"]];
                
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
                [userDefault setObject:txtOfficeAddress.text forKey:@"officeAddress"];
                [userDefault setObject:@"" forKey:@"address3"];
                [userDefault setObject:txtStreet.text forKey:@"officeStreet"];
                [userDefault setObject:txtCity.text forKey:@"officeCity"];
                [userDefault setObject:txtState.text forKey:@"officeState"];
                [userDefault setObject:txtCountry.text forKey:@"officeCountry"];
                [userDefault setObject:txtPostCode.text forKey:@"officePostcode"];

                
                userDtl.officeAddress=[NSString stringWithFormat:@"%@",txtOfficeAddress.text];
                userDtl.officeStreet=[NSString stringWithFormat:@"%@",txtStreet.text];
                userDtl.officeCity=[NSString stringWithFormat:@"%@",txtCity.text];
                userDtl.officeState=[NSString stringWithFormat:@"%@",txtState.text];
                userDtl.officeCountry=[NSString stringWithFormat:@"%@",txtCountry.text];
                userDtl.officePostCode=[NSString stringWithFormat:@"%@",txtPostCode.text];
                
                
                
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
//                    UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                    vcIntro.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:vcIntro animated:YES];
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
    UserDetail *userDtl=[UserDetail sharedInstance];
    userDtl.officeAddress=[NSString stringWithFormat:@"%@",txtOfficeAddress.text];
    userDtl.officeStreet=[NSString stringWithFormat:@"%@",txtStreet.text];
    userDtl.officeCity=[NSString stringWithFormat:@"%@",txtCity.text];
    userDtl.officeState=[NSString stringWithFormat:@"%@",txtState.text];
    userDtl.officeCountry=[NSString stringWithFormat:@"%@",txtCountry.text];
    userDtl.officePostCode=[NSString stringWithFormat:@"%@",txtPostCode.text];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    // Not found, so remove keyboard.
    //    [self.view resetViewframe];
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
        
        [dict setObject:[NSString stringWithFormat:@"%@",txtOfficeAddress.text] forKey:@"work_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtStreet.text] forKey:@"work_suburb"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtCity.text] forKey:@"work_city"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtState.text] forKey:@"work_state"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtCountry.text] forKey:@"work_country"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtPostCode.text] forKey:@"work_post_code"];
        
        
        /*[dict setObject:userDtl.homePhone forKey:@"home_phone"];
         [dict setObject:@"" forKey:@"home_phone2"];
         
         
         [dict setObject:userDtl.homeEmail forKey:@"home_email"];
         [dict setObject:@"" forKey:@"home_www"];
         
         [dict setObject:userDtl.homeAddress forKey:@"home_address1"];
         [dict setObject:@"" forKey:@"home_address2"];
         [dict setObject:@"" forKey:@"home_address3"];
         
         [dict setObject:userDtl.homeStreet forKey:@"home_suburb"];
         [dict setObject:userDtl.homeCity forKey:@"home_city"];
         [dict setObject:userDtl.homeState forKey:@"home_state"];
         [dict setObject:userDtl.homeCountry forKey:@"home_country"];
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
         [dict setObject:userDtl.officePostCode forKey:@"work_post_code"]; //
        
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
        
        [dict setObject:[NSString stringWithFormat:@"%@",txtOfficeAddress.text] forKey:@"work_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtStreet.text] forKey:@"work_suburb"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtCity.text] forKey:@"work_city"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtState.text] forKey:@"work_state"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtCountry.text] forKey:@"work_country"];
        [dict setObject:[NSString stringWithFormat:@"%@",txtPostCode.text] forKey:@"work_post_code"];
        
        /* [dict setObject:userDtl.homePhone forKey:@"home_phone"];
         [dict setObject:@"" forKey:@"home_phone2"];
         
         
         [dict setObject:userDtl.homeEmail forKey:@"home_email"];
         [dict setObject:@"" forKey:@"home_www"];
         
         [dict setObject:userDtl.homeAddress forKey:@"home_address1"];
         [dict setObject:@"" forKey:@"home_address2"];
         [dict setObject:@"" forKey:@"home_address3"];
         
         [dict setObject:userDtl.homeStreet forKey:@"home_suburb"];
         [dict setObject:userDtl.homeCity forKey:@"home_city"];
         [dict setObject:userDtl.homeState forKey:@"home_state"];
         [dict setObject:userDtl.homeCountry forKey:@"home_country"];
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
         [dict setObject:userDtl.officePostCode forKey:@"work_post_code"]; //
        
        
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
                    // NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
                    
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
                     //  [Database insert:@"tbl_profile" data:tmpDict]; //
                    
                    NSString *insertQuery=[NSString stringWithFormat:@"insert into tbl_profile (work_address1,work_suburb,work_city,work_state,work_country,work_post_code,cid)values ('%@','%@','%@','%@','%@','%@','%@')",[NSString stringWithFormat:@"%@",txtOfficeAddress.text],[NSString stringWithFormat:@"%@",txtStreet.text],[NSString stringWithFormat:@"%@",txtCity.text],[NSString stringWithFormat:@"%@",txtState.text],[NSString stringWithFormat:@"%@",txtCountry.text],[NSString stringWithFormat:@"%@",txtPostCode.text],[userDefault objectForKey:@"ID"]];
                    
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
                    NSString *query= [NSString stringWithFormat:@"update tbl_profile set work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@' where cid='%@'",[NSString stringWithFormat:@"%@",txtOfficeAddress.text],[NSString stringWithFormat:@"%@",txtStreet.text],[NSString stringWithFormat:@"%@",txtCity.text],[NSString stringWithFormat:@"%@",txtState.text],[NSString stringWithFormat:@"%@",txtCountry.text],[NSString stringWithFormat:@"%@",txtPostCode.text],[userDefault objectForKey:@"ID"]];
                    
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
                [userDefault setObject:txtOfficeAddress.text forKey:@"officeAddress"];
                [userDefault setObject:txtStreet.text forKey:@"officeStreet"];
                [userDefault setObject:txtCity.text forKey:@"officeCity"];
                [userDefault setObject:txtState.text forKey:@"officeState"];
                [userDefault setObject:txtCountry.text forKey:@"officeCountry"];
                [userDefault setObject:txtPostCode.text forKey:@"officePostcode"];
                
                
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
