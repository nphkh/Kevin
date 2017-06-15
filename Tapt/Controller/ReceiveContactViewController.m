//
//  ReceiveContactViewController.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ReceiveContactViewController.h"
#import "Constants.h"
#import "Database.h"
#import "ContactDetailViewController.h"
#import "ReceiveContactDetailViewController.h"
#import "LayoutPreviewViewController.h"


@interface ReceiveContactViewController ()
{
    NSUserDefaults *userDefault;
}

@property (nonatomic) BOOL isReading;

@property (nonatomic,strong)AVCaptureSession *captureSession;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic,strong)NSString *strORCode;

-(BOOL)startReading;
-(void)stopReading;
@end

@implementation ReceiveContactViewController

@synthesize strORCode;

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    
    self.btnCancel.layer.cornerRadius=self.btnCancel.frame.size.height/2;
    self.btnCancel.layer.masksToBounds=YES;
    self.btnCancel.layer.borderWidth = 1;
    self.btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    userDefault = [NSUserDefaults standardUserDefaults];
 //   [Database createEditableCopyOfDatabaseIfNeeded];

    _isReading = NO;
    _captureSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDelegate setShouldRotate:NO];
    _viewPreview.hidden=YES;
  
}

#pragma mark - Action Method


- (IBAction)btnBackAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)QRCodeReceiveAction:(id)sender {

    _viewPreview.hidden=NO;
    
//    if (!_isReading) {
//        if ([self startReading]) {
////            [_bbitemStart setTitle:@"Stop"];
////            [_lblStatus setText:@"Scanning for QR code"];
//        }
//    }
//    else
//    {
//        [self stopReading];
////        [_bbitemStart setTitle:@"Start!"];
//    }
//    _isReading=!_isReading;
    
    [self startReading];
}



#pragma mark - Custom Method


- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES; 
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            strORCode=[metadataObj stringValue];
            [userDefault setObject:strORCode forKey:@"ReceiveQrCode"];
            NSLog(@"%@",strORCode);
            
//            _isReading = NO;
            [self stopReading];
//            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(scancode) withObject:nil waitUntilDone:NO];
//            [self scancode];
        }
    }
}

-(void)scancode{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"receive" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];

//        NSString *strRandom=@"";
//        NSString *strId=@"";
//        BOOL flag=YES;
//        
//        for ( int i = 0 ; i< [strORCode length] ; i++ ){
//            char c=[strORCode characterAtIndex:i];
//            if (c == ',') {
//                flag=NO;
//            }
//            else
//            {
//                if (flag) {
//                    strId = [strId stringByAppendingFormat:@"%c", c];
//                }
//                else
//                {
//                    strRandom = [strRandom stringByAppendingFormat:@"%c", c];
//                }                
//            }
//        }
    
        NSArray *arrData=[strORCode componentsSeparatedByString:@","];
//        self.strSenderId=strId;
//        [dict setObject:strId forKey:@"senderId"];
//        [dict setObject:strRandom forKey:@"random"];
        self.strSenderId=[arrData objectAtIndex:0];
        [dict setObject:[arrData objectAtIndex:0] forKey:@"senderId"];
        [dict setObject:[arrData objectAtIndex:1]forKey:@"random"];
        
       // [dict setObject:@"" forKey:@"Latitude"];
       // [dict setObject:@"" forKey:@"Longtitude"];
       // [dict setObject:@"" forKey:@"event"];
        
        
        NSLog(@"dict : = %@",dict);
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
//                [UIAlertView infoAlertWithMessage:@"Contact get Successfully" andTitle:APP_NAME];
                
             /*   NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
                [tmpDict setObject:[userDefault objectForKey:@"ID"] forKey:@"cid"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"given_name"]) forKey:@"first_name"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"family_name"]) forKey:@"last_name"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"mobile_phone"]) forKey:@"mobile_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"desk_phone"]) forKey:@"desk_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_phone"]) forKey:@"home_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"email"]) forKey:@"email"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"company"]) forKey:@"company"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"title"]) forKey:@"title"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"address1"]) forKey:@"address1"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"address2"]) forKey:@"address2"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"address3"]) forKey:@"address3"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"suburb"]) forKey:@"suburb"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"post_code"]) forKey:@"post_code"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"city"]) forKey:@"city"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"state"]) forKey:@"state"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"country"]) forKey:@"country"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"image"]) forKey:@"image_url"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"logo"]) forKey:@"logo_url"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_facebook"]) forKey:@"facebook"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_twitter"]) forKey:@"twitter"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_linkedin"]) forKey:@"linkedIn"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_Skype"]) forKey:@"skype"]; */
                NSLog(@"%@",dict);
                NSLog(@"%@",self.strSenderId);
                NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
                [tmpDict setObject:self.strSenderId forKey:@"contact_id"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"given_name"]) forKey:@"first_name"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"family_name"]) forKey:@"last_name"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_mobile_phone"]) forKey:@"home_mobile_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_phone"]) forKey:@"home_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_email"]) forKey:@"home_email"];
            [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_address1"]) forKey:@"home_address1"];
                 [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_suburb"]) forKey:@"home_suburb"];
                 [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_city"]) forKey:@"home_city"];
                 [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_state"]) forKey:@"home_state"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_country"]) forKey:@"home_country"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_post_code"]) forKey:@"home_post_code"];
                
                
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"company"]) forKey:@"company"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"title"]) forKey:@"title"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_phone"]) forKey:@"work_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_mobile_phone"]) forKey:@"work_mobile_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_email"]) forKey:@"work_email"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_www"]) forKey:@"website"];
                             [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_address1"]) forKey:@"work_address1"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_suburb"]) forKey:@"work_suburb"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_city"]) forKey:@"work_city"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_state"]) forKey:@"work_state"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_country"]) forKey:@"work_country"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"work_post_code"]) forKey:@"work_post_code"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"image"]) forKey:@"image_url"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"logo"]) forKey:@"logo_url"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_facebook"]) forKey:@"facebook"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_twitter"]) forKey:@"twitter"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_linkedin"]) forKey:@"linkedIn"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_Skype"]) forKey:@"skype"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"bizcard"]) forKey:@"layout"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"created"]) forKey:@"ContactSince"];
                NSString *query = [ NSString stringWithFormat:@"select first_name from Contact_Detail where contact_id=%ld", (long)[self.strSenderId integerValue]];
                if ([Database executeScalerQuery:query]) {
//                    NSLog(@"Yes");
//                    
//                    [Database insert:@"tbl_profile" data:tmpDict];
//                    NSLog(@"Data Inserted!");
                    
                    NSString *insertQuery=[NSString stringWithFormat:@"insert into Contact_Detail(first_name,last_name,home_mobile_phone,home_phone,home_email,home_address1,home_suburb,home_city,home_state,home_country,home_post_code,company,title,work_phone,work_mobile_phone,work_email,website,work_address1,work_suburb,work_city,work_state,work_country,work_post_code,layout,image_url,logo_url,facebook,twitter,linkedIn,skype,ContactSince,contact_id)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[dict objectForKey:@"given_name"],[dict objectForKey:@"family_name"],[dict objectForKey:@"home_mobile_phone"],[dict objectForKey:@"home_phone"],[dict objectForKey:@"home_email"],[dict objectForKey:@"home_address1"],[dict objectForKey:@"home_suburb"],[dict objectForKey:@"home_city"],[dict objectForKey:@"home_state"],[dict objectForKey:@"home_country"],[dict objectForKey:@"home_post_code"],[dict objectForKey:@"company"],[dict objectForKey:@"title"],[dict objectForKey:@"work_phone"],[dict objectForKey:@"work_mobile_phone"],[dict objectForKey:@"work_email"],[dict objectForKey:@"work_www"],[dict objectForKey:@"work_address1"],[dict objectForKey:@"work_suburb"],[dict objectForKey:@"work_city"],[dict objectForKey:@"work_state"],[dict objectForKey:@"work_country"],[dict objectForKey:@"work_post_code"],[dict objectForKey:@"bizcard"],[dict objectForKey:@"image"],[dict objectForKey:@"logo"],@"",@"",@"",@"",[dict objectForKey:@"created"],self.strSenderId];
                    
                    
                    
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
                    NSLog(@"No");
                    
                    NSString *query= [NSString stringWithFormat:@"update Contact_Detail set first_name='%@',last_name='%@',home_mobile_phone='%@',home_phone='%@',home_email='%@',home_address1='%@',home_suburb='%@',home_city='%@',home_state='%@',home_country='%@',home_post_code='%@',company='%@',title='%@',work_phone='%@',work_mobile_phone='%@',work_email='%@',website='%@',work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@',@image='%@',@logo='%@',layout='%@',facebook='%@',twitter='%@',linkedIn='%@',skype='%@',ContactSince='%@' where contact_id='%@'",
                                      SAFESTRING([dict objectForKey:@"given_name"]),
                                      SAFESTRING([dict objectForKey:@"family_name"]),
                                      SAFESTRING([dict objectForKey:@"home_mobile_phone"]) ,
                                      SAFESTRING([dict objectForKey:@"home_phone"]) ,
                                      SAFESTRING([dict objectForKey:@"home_email"]) ,
                                      SAFESTRING([dict objectForKey:@"home_address1"]),
                                       SAFESTRING([dict objectForKey:@"home_suburb"]),
                                      SAFESTRING([dict objectForKey:@"home_city"]),
                                      SAFESTRING([dict objectForKey:@"home_state"]),
                                      SAFESTRING([dict objectForKey:@"home_country"]),
                                      SAFESTRING([dict objectForKey:@"home_post_code"]),
                                      
                                      SAFESTRING([dict objectForKey:@"company"]),
                                      SAFESTRING([dict objectForKey:@"title"]),
                                      SAFESTRING([dict objectForKey:@"work_phone"]),
                                      SAFESTRING([dict objectForKey:@"work_mobile_phone"]),
                                      SAFESTRING([dict objectForKey:@"work_email"]),
                                      
                                       SAFESTRING([dict objectForKey:@"work_www"]),
                                       SAFESTRING([dict objectForKey:@"work_address1"]),
                                      
                                     SAFESTRING([dict objectForKey:@"work_suburb"]),
                                     SAFESTRING([dict objectForKey:@"work_city"]),
                                     SAFESTRING([dict objectForKey:@"work_state"]),
                                      
                                      SAFESTRING([dict objectForKey:@"work_country"]),
                                      SAFESTRING([dict objectForKey:@"work_post_code"]),
                                    SAFESTRING([dict objectForKey:@"image"]),
                                      SAFESTRING([dict objectForKey:@"logo"]),
                                      SAFESTRING([dict objectForKey:@"social_facebook"]),
                                      SAFESTRING([dict objectForKey:@"social_twitter"]),
                                      SAFESTRING([dict objectForKey:@"social_linkedin"]),
                                      SAFESTRING([dict objectForKey:@"social_Skype"]),
                                      SAFESTRING([dict objectForKey:@"layout"]), SAFESTRING([dict objectForKey:@"created"]),self.strSenderId];
                    
                    [Database executeQuery:query];
                    NSLog(@"Data Updated!");
                }
                
                NSString *str=[NSString stringWithFormat:@"Select * from Contact_Detail"];
                NSArray *a=[Database executeQuery:str];
                NSLog(@"%@",a);
                
//                [Database insert:@"tbl_profile" data:tmpDict];
//                ReceiveContactDetailViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveContactDetailViewController"];
//                vcContact.dictContact=tmpDict;
//                
//                [self.navigationController pushViewController:vcContact animated:YES];
                
                LayoutPreviewViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"LayoutPreviewViewController"];
                vcContact.dictContact=tmpDict;
                [self.navigationController pushViewController:vcContact animated:YES];
                
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to Receive" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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



- (IBAction)btnCancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnGoToTag:(id)sender {
   
    LayoutPreviewViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"LayoutPreviewViewController"];
    //vcContact.dictContact=tmpDict;
    [self.navigationController pushViewController:vcContact animated:YES];
}

- (IBAction)btnReceiveSMSAction:(id)sender {
    
    [self callWebservice];
    
}

- (IBAction)btnReceiveEmailAction:(id)sender {
    [self callWebservice];
}
-(void)callWebservice{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"getMatch" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        
        NSLog(@"dict : = %@",dict);
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"No Match" ]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to Receive" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //               dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *dictParam=[NSMutableDictionary dictionary];
                [dictParam setObject:@"receive" forKey:@"action"];
                [dictParam setObject:@"1.14" forKey:@"version"];
                [dictParam setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
                [dictParam setObject:[dict objectForKey:@"SenderId"] forKey:@"senderId"];
                
                self.strSenderId=[dict objectForKey:@"SenderId"];
                [dictParam setObject:[dict objectForKey:@"Random"] forKey:@"random"];
                
                [self callWebserviceRecieve:dictParam];
                
                //               });
                
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

-(void)callWebserviceRecieve:(NSMutableDictionary *)dict{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        NSLog(@"dict : = %@",dict);
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
                
                //                [UIAlertView infoAlertWithMessage:@"Contact get Successfully" andTitle:APP_NAME];
                
                
                NSString *query = [ NSString stringWithFormat:@"select first_name from tbl_profile where cid=%ld", (long)[self.strSenderId integerValue]];
                NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
                
                [tmpDict setObject:self.strSenderId forKey:@"cid"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"given_name"]) forKey:@"first_name"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"family_name"]) forKey:@"last_name"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"mobile_phone"]) forKey:@"mobile_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"desk_phone"]) forKey:@"desk_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"home_phone"]) forKey:@"home_phone"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"email"]) forKey:@"email"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"company"]) forKey:@"company"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"title"]) forKey:@"title"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"address1"]) forKey:@"address1"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"address2"]) forKey:@"address2"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"address3"]) forKey:@"address3"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"suburb"]) forKey:@"suburb"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"post_code"]) forKey:@"post_code"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"city"]) forKey:@"city"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"state"]) forKey:@"state"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"country"]) forKey:@"country"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"image"]) forKey:@"image_url"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"logo"]) forKey:@"logo_url"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_facebook"]) forKey:@"facebook"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_twitter"]) forKey:@"twitter"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_linkedin"]) forKey:@"linkedIn"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"social_Skype"]) forKey:@"skype"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"www"]) forKey:@"website"];
                [tmpDict setObject:SAFESTRING([dict objectForKey:@"bizcard"]) forKey:@"layout"];
                
                if ([Database executeScalerQuery:query]) {
                    NSLog(@"Yes");
                    
                    [Database insert:@"tbl_profile" data:tmpDict];
                    NSLog(@"Data Inserted!");
                }
                else
                {
                    NSLog(@"No");
                    
                    NSString *query= [NSString stringWithFormat:@"update tbl_profile set first_name='%@',last_name='%@',mobile_phone='%@',desk_phone='%@',home_phone='%@',email='%@',company='%@',title='%@',address1='%@',address2='%@',address3='%@',suburb='%@',post_code='%@',city='%@',state='%@',country='%@',image_url='%@',logo_url='%@',facebook='%@',twitter='%@',linkedIn='%@',skype='%@',website='%@',layout='%@' where cid='%@'",
                                      SAFESTRING([dict objectForKey:@"given_name"]),
                                      SAFESTRING([dict objectForKey:@"family_name"]),
                                      SAFESTRING([dict objectForKey:@"mobile_phone"]) ,
                                      SAFESTRING([dict objectForKey:@"desk_phone"]),
                                      SAFESTRING([dict objectForKey:@"home_phone"]) ,
                                      SAFESTRING([dict objectForKey:@"email"]) ,
                                      SAFESTRING([dict objectForKey:@"company"]) ,
                                      SAFESTRING([dict objectForKey:@"title"]) ,
                                      SAFESTRING([dict objectForKey:@"address1"]) ,
                                      SAFESTRING([dict objectForKey:@"address2"]) ,
                                      SAFESTRING([dict objectForKey:@"address3"]) ,
                                      SAFESTRING([dict objectForKey:@"suburb"]) ,
                                      SAFESTRING([dict objectForKey:@"post_code"]) ,
                                      SAFESTRING([dict objectForKey:@"city"]) ,
                                      SAFESTRING([dict objectForKey:@"state"]) ,
                                      SAFESTRING([dict objectForKey:@"country"]) ,
                                      SAFESTRING([dict objectForKey:@"image"]),
                                      SAFESTRING([dict objectForKey:@"logo"]),
                                      SAFESTRING([dict objectForKey:@"social_facebook"]),
                                      SAFESTRING([dict objectForKey:@"social_twitter"]),
                                      SAFESTRING([dict objectForKey:@"social_linkedin"]),
                                      SAFESTRING([dict objectForKey:@"social_Skype"]),
                                      SAFESTRING([dict objectForKey:@"www"]),
                                      SAFESTRING([dict objectForKey:@"layout"]),
                                      self.strSenderId];
                    
                    [Database executeQuery:query];
                    NSLog(@"Data Updated!");
                }
                
                LayoutPreviewViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"LayoutPreviewViewController"];
                vcContact.dictContact=tmpDict;
                
                [self.navigationController pushViewController:vcContact animated:YES];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to Receive" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
