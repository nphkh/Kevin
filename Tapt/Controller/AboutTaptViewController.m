//
//  AboutTaptViewController.m
//  Tapt
//
//  Created by TriState  on 7/23/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "AboutTaptViewController.h"

@interface AboutTaptViewController ()

@end

@implementation AboutTaptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Back Button Action
- (IBAction)btnBackAction:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnRateAppAction:(id)sender {
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
