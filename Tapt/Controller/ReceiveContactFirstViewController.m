//
//  ReceiveContactFirstViewController.m
//  Tapt
//
//  Created by TriState  on 6/26/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ReceiveContactFirstViewController.h"

@interface ReceiveContactFirstViewController ()

@end

@implementation ReceiveContactFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
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



- (IBAction)btnBackAction:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
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
       
        //[self.navigationController popViewControllerAnimated:YES];
        
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[IntroPageViewController class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }

    }
 }

- (IBAction)btnReceveQrcode:(id)sender {
    
    ReceiveContactViewController *vcReceive=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveContactViewController"];
    [self.navigationController pushViewController:vcReceive animated:YES];
}
- (IBAction)btnCancelAction:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
