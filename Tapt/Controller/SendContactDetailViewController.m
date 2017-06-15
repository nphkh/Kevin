//
//  SendContactDetailViewController.m
//  Tapt
//
//  Created by TriState  on 7/1/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "SendContactDetailViewController.h"
#include <stdlib.h>

@interface SendContactDetailViewController ()
{
    NSUserDefaults *userDefault;
    int randomNumber;
    int CountForShare;
}
@end

@implementation SendContactDetailViewController
@synthesize imgQRPreview;
@synthesize strsharefeild;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefault=[NSUserDefaults standardUserDefaults];
    
    self.btnCancel.layer.cornerRadius=self.btnCancel.frame.size.height/2;
    self.btnCancel.layer.masksToBounds=YES;
    self.btnCancel.layer.borderWidth = 1;
    self.btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.userInteractionEnabled=YES;
    [super viewWillAppear:animated];
    
    [self generateRandomNumber];
    
    NSString *strForQR=[NSString stringWithFormat:@"%@,%d", [userDefault objectForKey:@"ID"] ,randomNumber];
    
    CIImage *img=[self createQRForString:strForQR];
    
    imgQRPreview.image=[self createNonInterpolatedUIImageFromCIImage:img withScale:2*[[UIScreen mainScreen] scale]];
    
    [self callWebservice];
    
}

#pragma mark - Custom Method
-(void)generateRandomNumber{
    randomNumber = 1000 + rand() % (5000-1000);
}


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
}
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
        // [dict setObject:SAFESTRING([userDefault objectForKey:@"event"]) forKey:@"event"];
        
        
        NSLog(@"%@",strsharefeild);
        
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        [dict setObject:strsharefeild forKey:@"fields"];
        
        NSLog(@"dict := %@", dict);

        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
                //                [UIAlertView infoAlertWithMessage:@"Successfully Share Contact" andTitle:APP_NAME];
               
                
                //code for seding count  to usage statastic webservice
                NSString *str=[NSString stringWithFormat:@"Select send2friend from SubmitUsageStatistics"];
                NSArray *a=[Database executeQuery:str];

                
                CountForShare=[[[a valueForKey:@"send2friend"]objectAtIndex:0]intValue];
                
                if([[[a valueForKey:@"send2friend"]objectAtIndex:0]isEqualToString:@"0"])
                {
                    CountForShare=1;
                    NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set send2friend='%d'",CountForShare];
                    [Database executeQuery:query];

                }
                else
                {
                    NSLog(@"%d",CountForShare);
                    CountForShare++;
                    NSString *query= [NSString stringWithFormat:@"update SubmitUsageStatistics set send2friend='%d'",CountForShare];
                    [Database executeQuery:query];

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
    
    self.view.userInteractionEnabled=YES;
    
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCancelAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
