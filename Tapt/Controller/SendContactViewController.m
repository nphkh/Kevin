//
//  SendContactViewController.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "SendContactViewController.h"
#include <stdlib.h>


@interface SendContactViewController ()
{
    NSUserDefaults *userDefault;
    int randomNumber;
    BOOL isSMS;
    BOOL isEmail;
}
@end

@implementation SendContactViewController

@synthesize imgQRPreview;
@synthesize arrKeyForShare,arrNewKeyForShare;
@synthesize arrFieldForShare,arrNewFieldForShare;
@synthesize arrKeyField,arrNewKeyField,arrDatabaseFeild;

@synthesize dictPermissionIndex;
@synthesize dictPermission;
@synthesize heightConstraintsForAskPermission;
@synthesize bottomSpaceConstraintsForAskermission;

@synthesize strEmail,strMobileNo;

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefault=[NSUserDefaults standardUserDefaults];
    
    dictPermission=[NSMutableDictionary dictionary];
    dictPermissionIndex=[NSMutableDictionary dictionary];
    Feildforemail=[[NSMutableArray alloc]init];
    
    flagMyprofile=1;
    flagHomeprofile=1;
    flagBusinessprofile=1;
    flagOfficeprofile=1;
    flagbusinesscard=1;
    flagsocialprofile=1;
    
  //  arrKeyForShare= [[NSMutableArray alloc]initWithObjects:@"sFirstName",@"sLastName",@"sMobile",@"sWork",@"sHome",@"sEmail",@"sCompany",@"sTitle",@"sAddress1",@"sAddress2",@"sAddress3",@"sSuburb",@"sPostcode",@"sCity",@"sState",@"sCountry",@"sLogo",@"sPicture",@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype",@"sWebsite",@"sEmail2", nil];
    
    
    arrKeyForShare=[[NSMutableArray alloc]initWithObjects:@"sFirstName",@"sLastName",@"sMobile",@"sPicture",@"sHome_phonenumber",@"sHome_Email",@"sHome_Address",@"sHome_street",@"sHome_City",@"sHome_State",@"sHome_County",@"sHome_Postcode",@"sCompanyName",@"stitle",@"sOfficePhone",@"sOfficeMobile",@"sOfficeEmail",@"sWebsite",@"sLogo",@"sOfficeAddress",@"sOfficeStreet",@"sOfficeCity",@"sOfficeState",@"sOfficeCountry",@"sOfficePostcode"@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype",nil];
    
    
    
   // arrFieldForShare= [[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Mobile",@"Work",@"Home",@"Email",@"Company",@"Title",@"Address1",@"Address2",@"Address3",@"Suburb",@"Postcode",@"City",@"State",@"Country",@"Logo",@"Picture",@"Facebook",@"Twitter",@"Linked In",@"Skype",@"Website",@"Personal Email", nil];
    
    arrFieldForShare= [[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Mobile",@"Picture",@"Home Phonenumber",@"Home Email",@"Home Address",@"Home Street",@"Home City",@"Home state",@"Home Country",@"Home Postcode",@"Company",@"Title",
                       @"Office Phone",@"Office MObile",@"Office Email",@"Website",@"Logo",@"Office Address",@"Office Street",@"Office City",@"Office State",@"Office Country",@"Office Country",@"Office Postcode",@"Facebook",@"Twitter",@"Linked In",@"Skype",nil];
   
    
    
   // arrKeyField=[[NSMutableArray alloc]initWithObjects:@"given_name",@"family_name",@"mobile_phone",@"desk_phone",@"home_phone",@"email",@"company",@"title",@"address1",@"address2",@"address3",@"suburb",@"post_code",@"city",@"state",@"country",@"logo",@"image",@"social_facebook",@"social_twitter",@"social_linkedin",@"social_Skype",@"www",@"email2", nil];
    
    arrKeyField=[[NSMutableArray alloc]initWithObjects:@"given_name",@"family_name",@"home_mobile_phone",@"image",@"home_phone",@"home_email",@"home_address1",@"home_suburb",@"home_city",@"home_state",@"home_country",@"home_post_code",@"company",@"title",@"work_mobile_phone",@"work_phone",@"work_email",@"work_www",@"logo",@"work_address1",@"work_suburb",@"work_city",@"work_state",@"work_country",@"work_post_code",@"social_facebook",@"social_twitter",@"social_linkedin",@"social_Skype",nil];
    
    
    
    
    /* for (int i=0;i<[arrKeyForShare count];i++){
        [dictPermissionIndex setObject:[NSString stringWithFormat:@"%d", i] forKey:[arrKeyForShare objectAtIndex:i]];
        [dictPermission setObject:@"1" forKey:[arrKeyForShare objectAtIndex:i]];
    }*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  /*  [self generateRandomNumber];
    
    NSString *strForQR=[NSString stringWithFormat:@"%@,%d", [userDefault objectForKey:@"ID"] ,randomNumber];
    
    CIImage *img=[self createQRForString:strForQR];
    
    imgQRPreview.image=[self createNonInterpolatedUIImageFromCIImage:img withScale:2*[[UIScreen mainScreen] scale]]; */
   
   // [self getPermission];
    
  // [self callWebservice];
    
    arrNewKeyForShare=[[NSMutableArray alloc]init];
    arrNewFieldForShare=[[NSMutableArray alloc]init];
    arrNewKeyField=[[NSMutableArray alloc]init];
    
    isSMS=NO;
    isEmail=NO;
    isfromQrcode=NO;
    isaskpermision=NO;
    

}
- (IBAction)btnMyprofileshareAction:(id)sender {
    
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [sender setAlpha:1];
        flagMyprofile=1;
        
    }
    else
    {
        [sender setSelected:YES];
        [sender setAlpha:0.5];
        flagMyprofile=0;
    }
    
}

- (IBAction)btnHomeprofileshareAction:(id)sender {
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [sender setAlpha:1];
        flagHomeprofile=1;
    }
    else
    {
        [sender setSelected:YES];
        [sender setAlpha:0.5];
        flagHomeprofile=0;
    }

}

- (IBAction)btnBusinessprofileshareAction:(id)sender {
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [sender setAlpha:1];
        flagBusinessprofile=1;
    }
    else
    {
        [sender setSelected:YES];
        [sender setAlpha:0.5];
         flagBusinessprofile=0;
    }

}

- (IBAction)btnOfficeprofileshareAction:(id)sender {
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [sender setAlpha:1];
        flagOfficeprofile=1;
    }
    else
    {
        [sender setSelected:YES];
        [sender setAlpha:0.5];
        flagOfficeprofile=0;
    }

}

- (IBAction)btnBusinesscardshareAction:(id)sender {
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [sender setAlpha:1];
       // flagbusinesscard=1;
    }
    else
    {
        [sender setSelected:YES];
        [sender setAlpha:0.5];
       // flagbusinesscard=0;
    }

}

- (IBAction)btnSocialprofileshareAction:(id)sender {
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [sender setAlpha:1];
        flagsocialprofile=1;
    }
    else
    {
        [sender setSelected:YES];
        [sender setAlpha:0.5];
        flagsocialprofile=0;
    }

}




#pragma mark - Action Method


- (IBAction)btnQRCodeAction:(id)sender {
    
//    randomNumber = 1000 + rand() % (5000-1000);
 /*   [self generateRandomNumber];
    
    NSString *strForQR=[NSString stringWithFormat:@"%@,%d", [userDefault objectForKey:@"ID"] ,randomNumber];
     
    CIImage *img=[self createQRForString:strForQR];
    
    imgQRPreview.image=[self createNonInterpolatedUIImageFromCIImage:img withScale:2*[[UIScreen mainScreen] scale]]; */
}

- (IBAction)btnBackAction:(id)sender {
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
//        ContactViewController *vcReceivetag=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//        [self.navigationController pushViewController:vcReceivetag animated:YES];
      
      //  [self.navigationController popViewControllerAnimated:YES];
        
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[IntroPageViewController class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }

    }
  
}
- (IBAction)btnCodeAction:(id)sender {
    
    isfromQrcode=YES;
   // isaskpermision=YES;
    [self setarrayforpermision];
    
}
-(void)setarrayforpermision
{
    [arrNewFieldForShare removeAllObjects];
    [arrNewKeyField removeAllObjects];
    [arrNewKeyForShare removeAllObjects];
    [dictPermission removeAllObjects];
    
    //myprofile page
    if(flagMyprofile==1)
    {
        [arrNewKeyForShare addObject:@"sFirstName"];
        [arrNewKeyForShare addObject:@"sLastName"];
        [arrNewKeyForShare addObject:@"sMobile"];
        [arrNewKeyForShare addObject:@"sPicture"];
        
        
        [arrNewFieldForShare addObject:@"First Name"];
        [arrNewFieldForShare addObject:@"Last Name"];
        [arrNewFieldForShare addObject:@"Mobile"];
        [arrNewFieldForShare addObject:@"Picture"];
        
        [arrNewKeyField addObject:@"given_name"];
        [arrNewKeyField addObject:@"family_name"];
        [arrNewKeyField addObject:@"home_mobile_phone"];
        [arrNewKeyField addObject:@"image"];
    }
    else
    {
        [arrNewKeyForShare removeObject:@"sFirstName"];
        [arrNewKeyForShare removeObject:@"sLastName"];
        [arrNewKeyForShare removeObject:@"sMobile"];
        [arrNewKeyForShare removeObject:@"sPicture"];
        
        [arrNewFieldForShare removeObject:@"First Name"];
        [arrNewFieldForShare removeObject:@"Last Name"];
        [arrNewFieldForShare removeObject:@"Mobile"];
        [arrNewFieldForShare removeObject:@"Picture"];
        
        [arrNewKeyField removeObject:@"given_name"];
        [arrNewKeyField removeObject:@"family_name"];
        [arrNewKeyField removeObject:@"home_mobile_phone"];
        [arrNewKeyField removeObject:@"image"];
        
        
    }
    
    //homeprofilepage
    if(flagHomeprofile==1)
    {
        [arrNewKeyForShare addObject:@"sHome_phonenumber"];
        [arrNewKeyForShare addObject:@"sHome_Email"];
        [arrNewKeyForShare addObject:@"sHome_Address"];
        [arrNewKeyForShare addObject:@"sHome_street"];
        [arrNewKeyForShare addObject:@"sHome_City"];
        [arrNewKeyForShare addObject:@"sHome_State"];
        [arrNewKeyForShare addObject:@"sHome_County"];
        [arrNewKeyForShare addObject:@"sHome_Postcode"];
        
        
        [arrNewFieldForShare addObject:@"Home Phonenumber"];
        [arrNewFieldForShare addObject:@"Home Email"];
        [arrNewFieldForShare addObject:@"Home Address"];
        [arrNewFieldForShare addObject:@"Home Street"];
        [arrNewFieldForShare addObject:@"Home City"];
        [arrNewFieldForShare addObject:@"Home state"];
        [arrNewFieldForShare addObject:@"Home Country"];
        [arrNewFieldForShare addObject:@"Home Postcode"];
        
        [arrNewKeyField addObject:@"home_phone"];
        [arrNewKeyField addObject:@"home_email"];
        [arrNewKeyField addObject:@"home_address1"];
        [arrNewKeyField addObject:@"home_suburb"];
        [arrNewKeyField addObject:@"home_city"];
        [arrNewKeyField addObject:@"home_state"];
        [arrNewKeyField addObject:@"home_country"];
        [arrNewKeyField addObject:@"home_post_code"];
    }
    else
    {
        [arrNewKeyForShare removeObject:@"sHome_phonenumber"];
        [arrNewKeyForShare removeObject:@"sHome_Email"];
        [arrNewKeyForShare removeObject:@"sHome_Address"];
        [arrNewKeyForShare removeObject:@"sHome_street"];
        [arrNewKeyForShare removeObject:@"sHome_City"];
        [arrNewKeyForShare removeObject:@"sHome_State"];
        [arrNewKeyForShare removeObject:@"sHome_County"];
        [arrNewKeyForShare removeObject:@"sHome_Postcode"];
        
        [arrNewFieldForShare removeObject:@"Home Phonenumber"];
        [arrNewFieldForShare removeObject:@"Home Email"];
        [arrNewFieldForShare removeObject:@"Home Address"];
        [arrNewFieldForShare removeObject:@"Home Street"];
        [arrNewFieldForShare removeObject:@"Home City"];
        [arrNewFieldForShare removeObject:@"Home state"];
        [arrNewFieldForShare removeObject:@"Home Country"];
        [arrNewFieldForShare removeObject:@"Home Postcode"];
        
        [arrNewKeyField removeObject:@"home_phone"];
        [arrNewKeyField removeObject:@"home_email"];
        [arrNewKeyField removeObject:@"home_address1"];
        [arrNewKeyField removeObject:@"home_suburb"];
        [arrNewKeyField removeObject:@"home_city"];
        [arrNewKeyField removeObject:@"home_state"];
        [arrNewKeyField removeObject:@"home_country"];
        [arrNewKeyField removeObject:@"home_post_code"];
        
        
    }
    
    //homeprofilepage
    if(flagBusinessprofile==1)
    {
        
        [arrNewKeyForShare addObject:@"sCompanyName"];
        [arrNewKeyForShare addObject:@"stitle"];
        [arrNewKeyForShare addObject:@"sOfficePhone"];
        [arrNewKeyForShare addObject:@"sOfficeMobile"];
        [arrNewKeyForShare addObject:@"sOfficeEmail"];
        [arrNewKeyForShare addObject:@"sWebsite"];
        [arrNewKeyForShare addObject:@"sLogo"];
        
        [arrNewFieldForShare addObject:@"Company"];
        [arrNewFieldForShare addObject:@"Title"];
        [arrNewFieldForShare addObject:@"Office Phone"];
        [arrNewFieldForShare addObject:@"Office MObile"];
        [arrNewFieldForShare addObject:@"Office Email"];
        [arrNewFieldForShare addObject:@"Website"];
        [arrNewFieldForShare addObject:@"Logo"];
        
        [arrNewKeyField addObject:@"Company"];
        [arrNewKeyField addObject:@"Title"];
        [arrNewKeyField addObject:@"work_mobile_phone"];
        [arrNewKeyField addObject:@"work_phone"];
        [arrNewKeyField addObject:@"work_email"];
        [arrNewKeyField addObject:@"work_www"];
        [arrNewKeyField addObject:@"logo"];
    }
    else
    {
        [arrNewKeyForShare removeObject:@"sCompanyName"];
        [arrNewKeyForShare removeObject:@"stitle"];
        [arrNewKeyForShare removeObject:@"sOfficePhone"];
        [arrNewKeyForShare removeObject:@"sOfficeMobile"];
        [arrNewKeyForShare removeObject:@"sOfficeEmail"];
        [arrNewKeyForShare removeObject:@"sWebsite"];
        [arrNewKeyForShare removeObject:@"sLogo"];
        
        [arrNewFieldForShare removeObject:@"Company"];
        [arrNewFieldForShare removeObject:@"Title"];
        [arrNewFieldForShare removeObject:@"Office Phone"];
        [arrNewFieldForShare removeObject:@"Office MObile"];
        [arrNewFieldForShare removeObject:@"Office Email"];
        [arrNewFieldForShare removeObject:@"Website"];
        [arrNewFieldForShare removeObject:@"Logo"];
        
        [arrNewKeyField removeObject:@"Company"];
        [arrNewKeyField removeObject:@"Title"];
        [arrNewKeyField removeObject:@"work_mobile_phone"];
        [arrNewKeyField removeObject:@"work_phone"];
        [arrNewKeyField removeObject:@"work_email"];
        [arrNewKeyField removeObject:@"work_www"];
        [arrNewKeyField removeObject:@"logo"];
        
    }
    
    //office page
    if(flagOfficeprofile==1)
    {
        [arrNewKeyForShare addObject:@"sOfficeAddress"];
        [arrNewKeyForShare addObject:@"sOfficeStreet"];
        [arrNewKeyForShare addObject:@"sOfficeCity"];
        [arrNewKeyForShare addObject:@"sOfficeState"];
        [arrNewKeyForShare addObject:@"sOfficeCountry"];
        [arrNewKeyForShare addObject:@"sOfficePostcode"];
        
        
        [arrNewFieldForShare addObject:@"Office Address"];
        [arrNewFieldForShare addObject:@"Office Street"];
        [arrNewFieldForShare addObject:@"Office City"];
        [arrNewFieldForShare addObject:@"Office State"];
        [arrNewFieldForShare addObject:@"Office Country"];
        [arrNewFieldForShare addObject:@"Office Postcode"];
        
        [arrNewKeyField addObject:@"work_address1"];
        [arrNewKeyField addObject:@"work_suburb"];
        [arrNewKeyField addObject:@"work_city"];
        [arrNewKeyField addObject:@"work_state"];
        [arrNewKeyField addObject:@"work_country"];
        [arrNewKeyField addObject:@"work_post_code"];
    }
    else
    {
        [arrNewKeyForShare removeObject:@"sOfficeAddress"];
        [arrNewKeyForShare removeObject:@"sOfficeStreet"];
        [arrNewKeyForShare removeObject:@"sOfficeCity"];
        [arrNewKeyForShare removeObject:@"sOfficeState"];
        [arrNewKeyForShare removeObject:@"sOfficeCountry"];
        [arrNewKeyForShare removeObject:@"sOfficePostcode"];
        
        
        [arrNewFieldForShare removeObject:@"Office Address"];
        [arrNewFieldForShare removeObject:@"Office Street"];
        [arrNewFieldForShare removeObject:@"Office City"];
        [arrNewFieldForShare removeObject:@"Office State"];
        [arrNewFieldForShare removeObject:@"Office Country"];
        [arrNewFieldForShare removeObject:@"Office Postcode"];
        
        [arrNewKeyField removeObject:@"work_address1"];
        [arrNewKeyField removeObject:@"work_suburb"];
        [arrNewKeyField removeObject:@"work_city"];
        [arrNewKeyField removeObject:@"work_state"];
        [arrNewKeyField removeObject:@"work_country"];
        [arrNewKeyField removeObject:@"work_post_code"];
    }
    
    //social profile page
    if(flagsocialprofile==1)
    {
        [arrNewKeyForShare addObject:@"sFacebook"];
        [arrNewKeyForShare addObject:@"sTwitter"];
        [arrNewKeyForShare addObject:@"sLinked In"];
        [arrNewKeyForShare addObject:@"sSkype"];
        
        [arrNewFieldForShare addObject:@"Facebook"];
        [arrNewFieldForShare addObject:@"Twitter"];
        [arrNewFieldForShare addObject:@"Linked In"];
        [arrNewFieldForShare addObject:@"Skype"];
        
        [arrNewKeyField addObject:@"social_facebook"];
        [arrNewKeyField addObject:@"social_twitter"];
        [arrNewKeyField addObject:@"social_linkedin"];
        [arrNewKeyField addObject:@"social_Skype"];
        
    }
    else
    {
        [arrNewKeyForShare removeObject:@"sFacebook"];
        [arrNewKeyForShare removeObject:@"sTwitter"];
        [arrNewKeyForShare removeObject:@"sLinked In"];
        [arrNewKeyForShare removeObject:@"sSkype"];
        
        [arrNewFieldForShare removeObject:@"Facebook"];
        [arrNewFieldForShare removeObject:@"Twitter"];
        [arrNewFieldForShare removeObject:@"Linked In"];
        [arrNewFieldForShare removeObject:@"Skype"];
        
        [arrNewKeyField removeObject:@"social_facebook"];
        [arrNewKeyField removeObject:@"social_twitter"];
        [arrNewKeyField removeObject:@"social_linkedin"];
        [arrNewKeyField removeObject:@"social_Skype"];
        
    }
    
    NSLog(@"%@",arrNewFieldForShare);
    NSLog(@"%@",arrNewKeyForShare);
    NSLog(@"%@",arrNewKeyField);
    
    for (int i=0;i<[arrNewKeyForShare count];i++){
        [dictPermissionIndex setObject:[NSString stringWithFormat:@"%d", i] forKey:[arrNewKeyForShare objectAtIndex:i]];
        [dictPermission setObject:@"1" forKey:[arrNewKeyForShare objectAtIndex:i]];
    }
    NSLog(@"%@",dictPermission);
    
    [self getPermission];

    
}

- (IBAction)btnSendMessageAction:(id)sender {
    
  
    [self generateRandomNumber];
    
    isSMS=YES;
    isEmail=NO;
    
    UIAlertView *alertForMobileNo=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Enter Mobile No. to Share Contact!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alertForMobileNo.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertForMobileNo textFieldAtIndex:0].delegate = self;
    
    [alertForMobileNo show];
    
}

- (IBAction)btnSendEmailAction:(id)sender {
    
    
    [self generateRandomNumber];
    
    isEmail=YES;
    isSMS=NO;
    
    
    UIAlertView *alertForEmail=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Enter Email to Share Contact!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alertForEmail.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertForEmail textFieldAtIndex:0].delegate = self;
    
    [alertForEmail show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"0 Index");
            break;
            
        case 1:
        {
            NSLog(@"1 Index :=%@",[alertView textFieldAtIndex:0].text);
            
            if (isSMS) {
                
                if ([[alertView textFieldAtIndex:0].text isEqualToString:@""])
                {
                    [UIAlertView infoAlertWithMessage:@"Please Enter Mobile No.!" andTitle:APP_NAME];
                }
                else
                {
                    strMobileNo=[alertView textFieldAtIndex:0].text;
                    //[self callWebservice];
                    [self setarrayforpermision];
                }
                
            }
            else if (isEmail){
                
                if ([[alertView textFieldAtIndex:0].text isEqualToString:@""])
                {
                    [UIAlertView infoAlertWithMessage:@"Please Enter Email Address!" andTitle:APP_NAME];
                }
                else
                {
                    strEmail=[alertView textFieldAtIndex:0].text;
                    [self setarrayforpermision];
                   
                }
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - Custom Method

-(void)generateRandomNumber{
    randomNumber = 1000 + rand() % (5000-1000);
}

/*
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
} */

-(void)callWebservice
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"share" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"curLat"]) forKey:@"lat"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"curLong"]) forKey:@"long"];
        [dict setObject:[NSString stringWithFormat:@"%d", randomNumber ]forKey:@"random"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"event"]) forKey:@"event"];
        
        if (isSMS) {
            [dict setObject:strMobileNo forKey:@"receiver_phone"];
        }
        else{
            [dict setObject:@"" forKey:@"receiver_phone"];
        }
        
        if (isEmail) {
            [dict setObject:strEmail forKey:@"receiver_email"];
        }
        else{
            [dict setObject:@"" forKey:@"receiver_email"];
        }
        
       
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        NSString *strField=@"";
        
        for (NSString *key in dictPermission){
            if ([[dictPermission objectForKey:key] isEqualToString:@"1"]) {
                if ([strField isEqualToString:@""]) {
                    strField = [NSString stringWithFormat:@"%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]];
                }
                else
                {
                   
                   strField = [strField stringByAppendingString:[NSString stringWithFormat:@",%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]]];
             
                }
            }
        }
        [dict setObject:strField forKey:@"fields"];
        
        NSLog(@"dict := %@", dict);
        
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
                NSLog(@"dict %@",dict);
                [self hidHud];
                if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
                    //                [UIAlertView infoAlertWithMessage:@"Successfully Share Contact" andTitle:APP_NAME];
                    
                    
                   
                    //code for seding count  to usage statastic webservice
                    NSString *str=[NSString stringWithFormat:@"Select * from SubmitUsageStatistics"];
                    NSArray *a=[Database executeQuery:str];
                    
                    //count for sms
                    if(isSMS)
                    {
                        countForSmsShare=[[[a valueForKey:@"shareText"]objectAtIndex:0]intValue];
                        
                        if([[[a valueForKey:@"shareText"]objectAtIndex:0]isEqualToString:@"0"])
                        {
                            countForSmsShare=1;
                            NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set shareText='%d'",countForSmsShare];
                            [Database executeQuery:query];
                            
                        }
                        else
                        {
                           
                            countForSmsShare++;
                            NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set shareText='%d'",countForSmsShare];
                            [Database executeQuery:query];
                            
                        }
                        
                    }
                    
                    //count for email
                    if(isEmail)
                    {
                        countForEmailShare=[[[a valueForKey:@"shareEmail"]objectAtIndex:0]intValue];
                        
                        if([[[a valueForKey:@"shareEmail"]objectAtIndex:0]isEqualToString:@"0"])
                        {
                            countForEmailShare=1;
                            NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set shareEmail='%d'",countForEmailShare];
                            [Database executeQuery:query];
                            
                        }
                        else
                        {
                            countForEmailShare++;
                            NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set shareEmail='%d'",countForEmailShare];
                            [Database executeQuery:query];
                            
                        }

                    }
                   
                }
                else
                {
                    [UIAlertView infoAlertWithMessage:@"Contact is not share, please try again!" andTitle:APP_NAME];
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

-(void)btnPress:(UIButton *)sender{
    
    UIButton *btn=(UIButton *)sender;
    
    if ([[dictPermission objectForKey:[arrKeyForShare objectAtIndex:((UIButton *)sender).tag]] isEqualToString:@"1"]) {
        [dictPermission setObject:@"0" forKey:[arrKeyForShare objectAtIndex:((UIButton *)sender).tag]];
        [btn setBackgroundColor:[UIColor yellowColor]];
    }
    else
    {
        [btn setBackgroundColor:[UIColor greenColor]];
        [dictPermission setObject:@"1" forKey:[arrKeyForShare objectAtIndex:((UIButton *)sender).tag]];
    }
    
    NSLog(@" Field Share : = %@", [arrKeyForShare objectAtIndex:((UIButton *)sender).tag]);
    
}

-(void)getPermission{
    
    int cnt=0;
    isaskpermision=YES;
    NSLog(@"%@",arrNewKeyForShare);
    NSLog(@"%@",arrKeyForShare);
    NSMutableArray *arrFieldNameSort=[[NSMutableArray alloc]init];
    
    if(arrNewKeyForShare>0)
    {
        for (NSString *key in arrNewKeyForShare) {
            if([[userDefault objectForKey:key] isEqualToString:@"2"])
            {
                cnt++;
                [arrFieldNameSort addObject:[arrNewFieldForShare objectAtIndex:[arrNewKeyForShare indexOfObject:key]]];
                
            }
            
            NSLog(@"%@",[userDefault objectForKey:key]);
            NSLog(@"%@",key);
            
            [dictPermission setObject:SAFESTRING([userDefault objectForKey:key]) forKey:key];
           
        }

    }
    
    if (cnt == 0) {
        
        if(isfromQrcode)
        {
           
            isfromQrcode=NO;
            NSLog(@"%@",dictPermission);
            NSString *strField=@"";
            
            for (NSString *key in dictPermission){
                if ([[dictPermission objectForKey:key] isEqualToString:@"1"]) {
                   
                    
                    if ([strField isEqualToString:@""]) {
                        strField = [NSString stringWithFormat:@"%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]];
                    }
                    else
                    {
                        
                        strField = [strField stringByAppendingString:[NSString stringWithFormat:@",%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]]];
                        
                    }
                }
            }

            

            NSLog(@"%@",strField);
            SendContactDetailViewController *vcsenddetail=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactDetailViewController"];
            vcsenddetail.strsharefeild=strField;
            [self.navigationController pushViewController:vcsenddetail animated:YES];
            
        }
        else
        {
           // [self callWebservice];
            
            [Feildforemail removeAllObjects];
            for (NSString *key in dictPermission){
                if ([[dictPermission objectForKey:key] isEqualToString:@"1"]) {
                    
                    [Feildforemail addObject:[NSString stringWithFormat:@"%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]]];
                }
            }
            [self getDataFromdb:Feildforemail];
            
           
            if(isSMS)
            {
                [self sendViaSMS:strMobileNo];
            }
            else if(isEmail)
            {
                [self sendViaEmail:strEmail];
            }
            else
            {
                
            }
            
        }
       
    }
    else
    {
        NSLog(@"%@",dictPermission);
        AskSharePermissionView *getPermission=[AskSharePermissionView loadView];
        getPermission.delegate=self;
        getPermission.arrFieldName=arrNewFieldForShare;
        getPermission.arrUDName=arrNewKeyForShare;
        getPermission.dictShare=dictPermission;
        [getPermission showInView:self.view];
    }
}

#pragma mark - CustomDelegateShare

-(void)sharePermissionChage:(NSMutableDictionary *)dict{
    
    dictPermission= [NSMutableDictionary dictionaryWithDictionary:dict];
    if(isfromQrcode)
    {
        isfromQrcode=NO;
        NSString *strField=@"";
        for (NSString *key in dictPermission){
            if ([[dictPermission objectForKey:key] isEqualToString:@"1"]) {
               
                
                if ([strField isEqualToString:@""]) {
                    strField = [NSString stringWithFormat:@"%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]];
                }
                else
                {
                   
                    strField = [strField stringByAppendingString:[NSString stringWithFormat:@",%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]]];
                    
                }
            }
        }
        
        NSLog(@"%@",strField);
        SendContactDetailViewController *vcsenddetail=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactDetailViewController"];
        vcsenddetail.strsharefeild=strField;
        [self.navigationController pushViewController:vcsenddetail animated:YES];
        
    }
    else
    {
       // [self callWebservice];
        [Feildforemail removeAllObjects];
        for (NSString *key in dictPermission){
            if ([[dictPermission objectForKey:key] isEqualToString:@"1"]) {
                
               [Feildforemail addObject:[NSString stringWithFormat:@"%@",[arrNewKeyField objectAtIndex:[arrNewKeyForShare indexOfObject:key]]]];
            }
        }
        [self getDataFromdb:Feildforemail];
        
        if(isSMS)
        {
            [self sendViaSMS:strMobileNo];
        }
        else if(isEmail)
        {
            [self sendViaEmail:strEmail];
        }
        else
        {
            
        }

    }
    
    
}

-(void)getDataFromdb:(NSMutableArray *)array
{
    NSString *str=[NSString stringWithFormat:@"Select * from tbl_profile where cid='%@'",[userDefault objectForKey:@"ID"]];
    NSArray *arrtemp=[Database executeQuery:str];
    
    dataforshare=@"";
    for(NSString *key in array)
    {
        
          NSString *strdata=[NSString stringWithFormat:@"%@",[[arrtemp valueForKey:key]objectAtIndex:0]];
            
            NSLog(@"%@",strdata);
            if ([dataforshare isEqualToString:@""]) {
                
                if([strdata isEqualToString:@""]||[strdata isEqualToString:@"<null>"]||[strdata isEqualToString:@"(null)"])
                {
                    
                }
                else
                {
                    dataforshare =[NSString stringWithFormat:@"%@\n",strdata];
                }
                
            }
            else
            {
                if([strdata isEqualToString:@""]||[strdata isEqualToString:@"<null>"]||[strdata isEqualToString:@"(null)"])
                {
                    
                }
                else
                {
                  dataforshare = [dataforshare stringByAppendingString:[NSString stringWithFormat:@"%@\n",strdata]];
                }
            }

    }
    NSLog(@"%@",dataforshare);
}

//for the email action
-(void)sendViaEmail:(NSString *)emailId
{
    
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    NSArray *toRecipients = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",emailId],nil];
   
    
    if ([MFMailComposeViewController canSendMail])
    {
        [mailer setTitle:APP_NAME];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:@""];
        [mailer setMessageBody:[NSString stringWithFormat:@"%@",dataforshare]isHTML:NO];
  
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
       [UIAlertView infoAlertWithMessage:@"Your device doesn't support the composer sheet" andTitle:APP_NAME];
  
    }

}


#pragma mark - MFMAIL DELEGATE

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            [UIAlertView infoAlertWithMessage:@"Mail has been canceled." andTitle:APP_NAME];
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //            [UIAlertView infoAlertWithMessage:@"Mail has been saved in the drafts folder." andTitle:APP_NAME];
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [UIAlertView infoAlertWithMessage:@"Email sent successfully." andTitle:APP_NAME];
            
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            //            [UIAlertView infoAlertWithMessage:@"Mail failed: the email message was not saved or queued, possibly due to an error." andTitle:APP_NAME];
            break;
        default:
            //            NSLog(@"Mail not sent.");
            [UIAlertView infoAlertWithMessage:@"Mail not sent." andTitle:APP_NAME];
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

//for the sms Action
-(void)sendViaSMS:(NSString *)mobileno
{
    if ([MFMessageComposeViewController canSendText]) {
    
        MFMessageComposeViewController *messageComposer =
        [[MFMessageComposeViewController alloc] init];
       
        NSString *message =[NSString stringWithFormat:@"%@",dataforshare];
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"Your device doesn't support the composer sheet" andTitle:APP_NAME];
    }

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
