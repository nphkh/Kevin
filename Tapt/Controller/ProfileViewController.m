//
//  ViewController.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import "Webservice.h"
#import "NSString+Extensions.h"
#import "Database.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
//#import <FacebookSDK/FacebookSDK.h>


@interface ProfileViewController ()
{
    NSMutableData *mutableData;
//    NSUserDefaults *userDefault;
    BOOL isImage;
    BOOL isLogo;
    NSInteger btnSel;
}
@end

@implementation ProfileViewController

@synthesize arrKeyForShare;
@synthesize oAuthLoginView;

@synthesize lblFacebookName,lblLinkedInName,lblTwitterName;
@synthesize btnFacebookLogin,btnTwitterLogin,btnLinkedInLogin;

@synthesize containerView,scrlView;
@synthesize txtAddress1,txtAddress2,txtAddress3,txtCity,txtCompany,txtCountry,txtEmailAddress,txtPersonalEmail,txtFirstName;
@synthesize txtHomeContact,txtLastName,txtMobile,txtPostCode,txtState,txtSuburb,txtTitle,txtWorkContact;
@synthesize txtSkypeName,txtWebsite;
@synthesize imgUserPhoto;
@synthesize btnBack;

@synthesize btnFacebookSetup,btnTwitterSetup,btnLinkedInSetup;

@synthesize btnFirstName;//1
@synthesize btnLastName;//2
@synthesize btnMobile;//3
@synthesize btnWork;//4
@synthesize btnHome;//5
@synthesize btnEmail;//6
@synthesize btnCompany;//7
@synthesize btnTitle;//8
@synthesize btnAddress1;//9
@synthesize btnAddress2;//10
@synthesize btnAddress3;//11
@synthesize btnSuburb;//12
@synthesize btnPostcode;//13
@synthesize btnCity;//14
@synthesize btnState;//15
@synthesize btnCountry;//16
@synthesize btnCompanyLogo;//17
@synthesize btnPicture;//18
@synthesize btnFacebook;//19
@synthesize btnTwitter;//20
@synthesize btnLinkedIn;//21
@synthesize btnSkype;//22
@synthesize btnWebsite;//23
@synthesize btnEmail2;//24

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

//- (void) setTextField:(UITextField *)textField
//{
//    txtMobile = textField;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    [txtMobile setDelegate:self.mask];
    [txtHomeContact setDelegate:self.mask];
    [txtWorkContact setDelegate:self.mask];
    
//    [self setTextField:txtMobile];
//    [self setTextField:txtHomeContact];
//    [self setTextField:txtWorkContact];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstTime"]){
    }
    else{
           btnBack.hidden=YES;
    }
    
    arrKeyForShare= [[NSMutableArray alloc]initWithObjects:@"sFirstName",@"sLastName",@"sMobile",@"sWork",@"sHome",@"sEmail",@"sCompany",@"sTitle",@"sAddress1",@"sAddress2",@"sAddress3",@"sSuburb",@"sPostcode",@"sCity",@"sState",@"sCountry",@"sLogo",@"sPicture",@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype",@"sWebsite",@"sEmail2", nil];
    
    scrlView.contentSize=containerView.frame.size;
    
    imgUserPhoto.layer.cornerRadius=imgUserPhoto.frame.size.height/2;
    imgUserPhoto.layer.masksToBounds=YES;
    imgUserPhoto.layer.borderWidth=0;
    
//    userDefault=[NSUserDefaults standardUserDefaults];

   // [Database createEditableCopyOfDatabaseIfNeeded];
    
    isImage=NO;
    isLogo=NO;
    
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
    
    if ([[userDefault objectForKey:@"btnBackStatus"] isEqualToString:@"1"]) {
        btnBack.hidden=NO;
    }
    else
    {
        btnBack.hidden=YES;
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
//                                                 name:@"SessionStateChangeNotification"
//                                               object:nil];
    
//    [[FBSession activeSession] closeAndClearTokenInformation];
    
    lblFacebookName.hidden=YES;
    lblTwitterName.hidden=YES;
    lblLinkedInName.hidden=YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( [[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"] && !isImage) {
        if ([userDefault objectForKey:@"picname"]) {
            NSString *strImgUrl=[userDefault objectForKey:@"picname"];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgUserPhoto sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
            isImage=YES;
        }
    }
    
    if(!isImage)
    {
        if ([userDefault objectForKey:@"picname"]) {
            NSString *strImgUrl=[userDefault objectForKey:@"picname"];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgUserPhoto sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
    }
    
    if (!isLogo) {
        if ([userDefault objectForKey:@"logoname"]) {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [self.imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
    }
    
    if ([userDefault objectForKey:@"isFirstTime"] || [userDefault objectForKey:@"isFBLogin"]) {
        txtFirstName.text=[userDefault objectForKey:@"firstName"];
        txtLastName.text=[userDefault objectForKey:@"lastName"];
        
        NSString *format=@"###-###-####";
        NSString *strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"mobile"],format);
        
        txtMobile.text=strContact;
        strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"work"], format);
        txtWorkContact.text=strContact;
        strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"home"], format);
        txtHomeContact.text=strContact;
        txtEmailAddress.text=[userDefault objectForKey:@"email"];
        txtCompany.text=[userDefault objectForKey:@"company"];
        txtTitle.text=[userDefault objectForKey:@"title"];
        txtAddress1.text=[userDefault objectForKey:@"address1"];
        txtAddress2.text=[userDefault objectForKey:@"address2"];
        txtAddress3.text=[userDefault objectForKey:@"address3"];
        txtSuburb.text=[userDefault objectForKey:@"suburb"];
        txtPostCode.text=[userDefault objectForKey:@"postcode"];
        txtCity.text=[userDefault objectForKey:@"city"];
        txtState.text=[userDefault objectForKey:@"state"];
        txtCountry.text=[userDefault objectForKey:@"country"];
        txtWebsite.text=[userDefault objectForKey:@"website"];
        txtSkypeName.text=[userDefault objectForKey:@"skypeId"];
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
        
    }
    else
    {
        btnFacebook.userInteractionEnabled=NO;
        btnTwitter.userInteractionEnabled=NO;
        btnLinkedIn.userInteractionEnabled=NO;
    }
    
    for (NSString *key in arrKeyForShare) {
        
        switch ([arrKeyForShare indexOfObject:key]) {
            case 0:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:0]] integerValue]) {
                    case 2:
                        [btnFirstName setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnFirstName setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnFirstName setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 1:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:1]] integerValue]) {
                    case 2:
                        [btnLastName setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnLastName setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnLastName setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 2:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:2]] integerValue]) {
                    case 2:
                        [btnMobile setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnMobile setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnMobile setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 3:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:3]] integerValue]) {
                    case 2:
                        [btnWork setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnWork setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnWork setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 4:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:4]] integerValue]) {
                    case 2:
                        [btnHome setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnHome setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnHome setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 5:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:5]] integerValue]) {
                    case 2:
                        [btnEmail setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnEmail setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnEmail setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 6:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:6]] integerValue]) {
                    case 2:
                        [btnCompany setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnCompany setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnCompany setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 7:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:7]] integerValue]) {
                    case 2:
                        [btnTitle setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnTitle setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnTitle setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 8:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:8]] integerValue]) {
                    case 2:
                        [btnAddress1 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnAddress1 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnAddress1 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 9:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:9]] integerValue]) {
                    case 2:
                        [btnAddress2 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnAddress2 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnAddress2 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
            case 10:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:10]] integerValue]) {
                    case 2:
                        [btnAddress3 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnAddress3 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnAddress3 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 11:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:11]] integerValue]) {
                    case 2:
                        [btnSuburb setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnSuburb setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnSuburb setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 12:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:12]] integerValue]) {
                    case 2:
                        [btnPostcode setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnPostcode setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnPostcode setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 13:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:13]] integerValue]) {
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
                
            case 14:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:14]] integerValue]) {
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
                
            case 15:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:15]] integerValue]) {
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
                
                
            case 16:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:16]] integerValue]) {
                    case 2:
                        [btnCompanyLogo setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnCompanyLogo setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnCompanyLogo setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 17:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:17]] integerValue]) {
                    case 2:
                        [btnPicture setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnPicture setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnPicture setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 18:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:18]] integerValue]) {
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
                
            case 19:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:19]] integerValue]) {
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
                
            case 20:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:20]] integerValue]) {
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
                
            case 21:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:21]] integerValue]) {
                    case 2:
                        [btnSkype setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnSkype setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnSkype setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 22:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:22]] integerValue]) {
                    case 2:
                        [btnWebsite setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnWebsite setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnWebsite setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                break;
                
            case 23:
                switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:23]] integerValue]) {
                    case 2:
                        [btnEmail2 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        [btnEmail2 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btnEmail2 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method

- (IBAction)btnSaveAction:(id)sender {
    //&& [txtMobile validate]
    if ([txtFirstName validate] && [txtLastName validate] ) {
        
        if (![txtEmailAddress.text isEqualToString:@""]) {
            if ([NSString validateEmail:txtEmailAddress.text]) {
                [self callWebservice];
            }
            else
            {
                [UIAlertView infoAlertWithMessage:@"Enter valid Email Address" andTitle:APP_NAME];
            }
        }
        else
        {
            [self callWebservice];
        }
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"First Name, Last Name and Mobile number are Mandatory!" andTitle:APP_NAME];
    }
}

- (IBAction)btnMyProfile:(id)sender {
    btnSel=1;
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Photo from Gallery",
                            @"Take Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)btnCardLayout:(id)sender {
    
    UIViewController *vcLayout=[self.storyboard instantiateViewControllerWithIdentifier:@"CardLayoutViewController"];
    [self.navigationController pushViewController:vcLayout animated:YES];
//    [self.navigationController presentViewController:vcLayout animated:YES completion:nil];
    
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnShareFieldStatusAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case 1:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:0]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnFirstName setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnFirstName setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:0]];
                    [btnFirstName setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:1]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnLastName setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnLastName setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:1]];
                    [btnLastName setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 3:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:2]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnMobile setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnMobile setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:2]];
                    [btnMobile setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 4:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:3]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnWork setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnWork setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:3]];
                    [btnWork setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;

        case 5:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:4]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:4]];
                    [btnHome setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:4]];
                    [btnHome setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:4]];
                    [btnHome setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 6:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:5]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:5]];
                    [btnEmail setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:5]];
                    [btnEmail setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:5]];
                    [btnEmail setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 7:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:6]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:6]];
                    [btnCompany setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:6]];
                    [btnCompany setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:6]];
                    [btnCompany setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 8:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:7]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:7]];
                    [btnTitle setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:7]];
                    [btnTitle setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:7]];
                    [btnTitle setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;

        case 9:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:8]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:8]];
                    [btnAddress1 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:8]];
                    [btnAddress1 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:8]];
                    [btnAddress1 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;

        case 10:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:9]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:9]];
                    [btnAddress2 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:9]];
                    [btnAddress2 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:9]];
                    [btnAddress2 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
        case 11:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:10]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:10]];
                    [btnAddress3 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:10]];
                    [btnAddress3 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:10]];
                    [btnAddress3 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 12:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:11]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:11]];
                    [btnSuburb setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:11]];
                    [btnSuburb setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:11]];
                    [btnSuburb setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;

        case 13:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:12]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:12]];
                    [btnPostcode setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:12]];
                    [btnPostcode setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:12]];
                    [btnPostcode setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;

        case 14:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:13]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:13]];
                    [btnCity setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:13]];
                    [btnCity setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:13]];
                    [btnCity setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 15:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:14]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:14]];
                    [btnState setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:14]];
                    [btnState setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:14]];
                    [btnState setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 16:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:15]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:15]];
                    [btnCountry setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:15]];
                    [btnCountry setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:15]];
                    [btnCountry setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;


        case 17:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:16]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:16]];
                    [btnCompanyLogo setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:16]];
                    [btnCompanyLogo setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:16]];
                    [btnCompanyLogo setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 18:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:17]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:17]];
                    [btnPicture setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:17]];
                    [btnPicture setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:17]];
                    [btnPicture setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 19:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:18]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:18]];
                    [btnFacebook setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:18]];
                    [btnFacebook setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:18]];
                    [btnFacebook setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 20:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:19]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:19]];
                    [btnTwitter setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:19]];
                    [btnTwitter setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:19]];
                    [btnTwitter setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 21:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:20]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:20]];
                    [btnLinkedIn setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:20]];
                    [btnLinkedIn setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:20]];
                    [btnLinkedIn setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 22:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:21]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:21]];
                    [btnSkype setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:21]];
                    [btnSkype setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:21]];
                    [btnSkype setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
            
        case 23:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:22]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:22]];
                    [btnWebsite setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:22]];
                    [btnWebsite setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:22]];
                    [btnWebsite setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;
        case 24:
            switch ([[userDefault objectForKey:[arrKeyForShare objectAtIndex:23]] integerValue]) {
                case 1:
                    [userDefault setObject:@"2" forKey:[arrKeyForShare objectAtIndex:23]];
                    [btnEmail2 setImage:[UIImage imageNamed:@"yellow-circle.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [userDefault setObject:@"3" forKey:[arrKeyForShare objectAtIndex:23]];
                    [btnEmail2 setImage:[UIImage imageNamed:@"red-circle.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [userDefault setObject:@"1" forKey:[arrKeyForShare objectAtIndex:23]];
                    [btnEmail2 setImage:[UIImage imageNamed:@"green-circle.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            break;


        default:
            break;
    }
    
}

- (IBAction)btnFacebookAction:(id)sender {
    
//    if ([FBSession activeSession].state != FBSessionStateOpen &&
//        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
//        
//        [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
//        
//    }
//    else
//    {
//        // Close an existing session.
//        [[FBSession activeSession] closeAndClearTokenInformation];
//        
//    }
    
//    [self callFbLogin];
    
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

- (IBAction)btnCompanyLogoAction:(id)sender {
}

- (IBAction)btnLogoAction:(id)sender {
    
    btnSel=2;
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Photo from Gallery",
                            @"Take Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
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
    
//    NSString *parameter;
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    if (![userDefault objectForKey:@"isFirstTime"]) {
        
        [dict setObject:@"new" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:txtFirstName.text forKey:@"given_name"];
        [dict setObject:txtLastName.text forKey:@"family_name"];
//        [dict setObject:txtMobile.text forKey:@"mobile_phone"];
//        [dict setObject:txtWorkContact.text forKey:@"desk_phone"];
//        [dict setObject:txtHomeContact.text forKey:@"home_phone"];
        
        NSString *strConatct=[txtMobile.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [dict setObject:strConatct forKey:@"mobile_phone"];
        
        strConatct=[txtWorkContact.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [dict setObject:strConatct forKey:@"desk_phone"];
        
        strConatct=[txtHomeContact.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [dict setObject:strConatct forKey:@"home_phone"];
       
        [dict setObject:txtEmailAddress.text forKey:@"email"];
        [dict setObject:txtPersonalEmail.text forKey:@"email2"];
        [dict setObject:txtCompany.text forKey:@"company"];
        [dict setObject:txtTitle.text forKey:@"title"];
        [dict setObject:txtAddress1.text forKey:@"address1"];
        [dict setObject:txtAddress2.text forKey:@"address2"];
        [dict setObject:txtAddress3.text forKey:@"address3"];
        [dict setObject:txtSuburb.text forKey:@"suburb"];
        [dict setObject:txtPostCode.text forKey:@"post_code"];
        [dict setObject:txtCity.text forKey:@"city"];
        [dict setObject:txtState.text forKey:@"state"];
        [dict setObject:txtCompany.text forKey:@"country"];
        NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
        
        [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"fbid"];
        
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
        [dict setObject:txtFirstName.text forKey:@"given_name"];
        [dict setObject:txtLastName.text forKey:@"family_name"];
        
        NSString *strConatct=[txtMobile.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [dict setObject:strConatct forKey:@"mobile_phone"];
        
        strConatct=[txtWorkContact.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [dict setObject:strConatct forKey:@"desk_phone"];
        
        strConatct=[txtHomeContact.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [dict setObject:strConatct forKey:@"home_phone"];
        [dict setObject:txtEmailAddress.text forKey:@"email"];
        [dict setObject:txtPersonalEmail.text forKey:@"email2"];
        [dict setObject:txtCompany.text forKey:@"company"];
        [dict setObject:txtTitle.text forKey:@"title"];
        [dict setObject:txtAddress1.text forKey:@"address1"];
        [dict setObject:txtAddress2.text forKey:@"address2"];
        [dict setObject:txtAddress3.text forKey:@"address3"];
        [dict setObject:txtSuburb.text forKey:@"suburb"];
        [dict setObject:txtPostCode.text forKey:@"post_code"];
        [dict setObject:txtCity.text forKey:@"city"];
        [dict setObject:txtState.text forKey:@"state"];
        [dict setObject:txtCompany.text forKey:@"country"];
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
                [tmpDict setObject:[userDefault objectForKey:@"ID"] forKey:@"cid"];
                [tmpDict setObject:txtFirstName.text forKey:@"first_name"];
                [tmpDict setObject:txtLastName.text forKey:@"last_name"];
//                [tmpDict setObject:txtMobile.text forKey:@"mobile_phone"];
//                [tmpDict setObject:txtWorkContact.text forKey:@"desk_phone"];
//                [tmpDict setObject:txtHomeContact.text forKey:@"home_phone"];
                
                NSString *strConatct=[txtMobile.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                [tmpDict setObject:strConatct forKey:@"mobile_phone"];
                
                strConatct=[txtWorkContact.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                [tmpDict setObject:strConatct forKey:@"desk_phone"];
                
                strConatct=[txtHomeContact.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [tmpDict setObject:strConatct forKey:@"home_phone"];
                
                [tmpDict setObject:txtEmailAddress.text forKey:@"email"];
                [tmpDict setObject:txtPersonalEmail.text forKey:@"email2"];
                [tmpDict setObject:txtCompany.text forKey:@"company"];
                [tmpDict setObject:txtTitle.text forKey:@"title"];
                [tmpDict setObject:txtAddress1.text forKey:@"address1"];
                [tmpDict setObject:txtAddress2.text forKey:@"address2"];
                [tmpDict setObject:txtAddress3.text forKey:@"address3"];
                [tmpDict setObject:txtSuburb.text forKey:@"suburb"];
                [tmpDict setObject:txtPostCode.text forKey:@"post_code"];
                [tmpDict setObject:txtCity.text forKey:@"city"];
                [tmpDict setObject:txtState.text forKey:@"state"];
                [tmpDict setObject:txtCountry.text forKey:@"country"];
                
                NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
//                [dict setObject:[dictFB objectForKey:@"fbid"] forKey:@"social_facebook"];2
                [tmpDict setObject:SAFESTRING([dictFB objectForKey:@"fbid"]) forKey:@"facebook"];
                [tmpDict setObject:SAFESTRING([userDefault objectForKey:@"twId"]) forKey:@"twitter"];
                [tmpDict setObject:SAFESTRING([userDefault objectForKey:@"linkedIn_url"]) forKey:@"linkedIn"];
                [tmpDict setObject:txtSkypeName.text forKey:@"skype"];
                [Database insert:@"tbl_profile" data:tmpDict];
                NSLog(@"Data Inserted!");
                
            }
            else
            {
                NSString *query= [NSString stringWithFormat:@"update tbl_profile set first_name='%@',last_name='%@',mobile_phone='%@',desk_phone='%@',home_phone='%@',email='%@',company='%@',title='%@',address1='%@',address2='%@',address3='%@',suburb='%@',post_code='%@',city='%@',state='%@',country='%@',email2='%@' where cid='%@'", txtFirstName.text,txtLastName.text, txtMobile.text ,txtWorkContact.text, txtHomeContact.text , txtEmailAddress.text , txtCompany.text , txtTitle.text , txtAddress1.text , txtAddress2.text , txtAddress3.text , txtSuburb.text , txtPostCode.text , txtCity.text , txtState.text , txtCountry.text , txtPersonalEmail.text ,[userDefault objectForKey:@"ID"] ];
                
                [Database executeQuery:query];
                NSLog(@"Data Updated!");
            }
            
//            [userDefault setObject:@"1" forKey:@"isFirstTime"];
            [userDefault setObject:@"1" forKey:@"isRegistered"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];

                        
            [userDefault setObject:txtFirstName.text forKey:@"firstName"];
            [userDefault setObject:txtLastName.text forKey:@"lastName"];
            [userDefault setObject:txtMobile.text forKey:@"mobile"];
            [userDefault setObject:txtWorkContact.text forKey:@"work"];
            [userDefault setObject:txtHomeContact.text forKey:@"home"];
            [userDefault setObject:txtEmailAddress.text forKey:@"email"];
            [userDefault setObject:txtPersonalEmail.text forKey:@"email2"];
            [userDefault setObject:txtCompany.text forKey:@"company"];
            [userDefault setObject:txtTitle.text forKey:@"title"];
            [userDefault setObject:txtAddress1.text forKey:@"address1"];
            [userDefault setObject:txtAddress2.text forKey:@"address2"];
            [userDefault setObject:txtAddress3.text forKey:@"address3"];
            [userDefault setObject:txtSuburb.text forKey:@"suburb"];
            [userDefault setObject:txtPostCode.text forKey:@"postcode"];
            [userDefault setObject:txtCity.text forKey:@"city"];
            [userDefault setObject:txtState.text forKey:@"state"];
            [userDefault setObject:txtCountry.text forKey:@"country"];
            [userDefault setObject:txtSkypeName.text forKey:@"skypeId"];
            [userDefault setObject:txtWebsite.text forKey:@"website"];
                        
            if (isImage) {
                    [self uploadImage];
            }
            else
            {
                if (isLogo) {
                    [self uploadLogo];
                }
                else{
                
                    UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                
                    [self.navigationController pushViewController:vcHome animated:YES];
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
    
        NSData *dataOfImg=UIImageJPEGRepresentation(imgUserPhoto.image, 0.6f);
    
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
            
            NSString *query= [NSString stringWithFormat:@"update tbl_profile set image_url='%@' where cid='%@'", [dict objectForKey:@"Filename"] , [userDefault objectForKey:@"ID"] ];
            
            [Database executeQuery:query];
            NSLog(@"Data Updated!");
            
            if (isLogo) {
                [self uploadLogo];
            }
            else
            {
            
                UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self.navigationController pushViewController:vcHome animated:YES];
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
        
        NSData *dataOfImg=UIImageJPEGRepresentation(self.imgLogo.image, 0.6f);
        
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
            
            NSString *query= [NSString stringWithFormat:@"update tbl_profile set logo_url='%@' where cid='%@'", [dict objectForKey:@"Filename"] , [userDefault objectForKey:@"ID"] ];
            
            [Database executeQuery:query];
            NSLog(@"Data Updated!");
            
            UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            
            [self.navigationController pushViewController:vcHome animated:YES];
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

-(void)openGallory
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"Add Photo From Galllory!");
                    [self openGallory];
                    break;
                case 1:
                    NSLog(@"take Photo!");
                    [self takePhoto];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate Method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    imgUserPhoto.image = chosenImage;
    
    if (btnSel==1) {
        imgUserPhoto.image=chosenImage;
        isImage=true;
    }
    else
    {
        self.imgLogo.image=chosenImage;
        isLogo=true;
    }
    
    
    
    //    [self saveImage];
    //[picker performSelectorOnMainThread:@selector(saveImage) withObject:nil waitUntilDone:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
//    [self uploadImage];
}

#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [scrlView setViewframe:textField forSuperView:self.view];
    self.txtFieldCheck=textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    [scrlView resetViewframe];
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


@end
