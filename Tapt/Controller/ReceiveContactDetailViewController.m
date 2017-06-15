//
//  ReceiveContactDetailViewController.m
//  Tapt
//
//  Created by Parth on 25/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ReceiveContactDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ReceiveContactDetailViewController ()

@end

@implementation ReceiveContactDetailViewController

@synthesize dictContact;
@synthesize imgUserPhoto;
@synthesize lblFirstName,lblLastName,lblMobile;

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [appDelegate setShouldRotate:NO];
    
    NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@", [dictContact objectForKey:@"image_url"]];
    strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url=[NSURL URLWithString:strImgUrl];
    [imgUserPhoto sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
    
    lblFirstName.text= [dictContact objectForKey:@"first_name"];
    lblLastName.text=[dictContact objectForKey:@"last_name"];
    
    if ([[dictContact objectForKey:@"mobile_phone"] isEqualToString:@""]) {
        lblMobile.text=@"--";
    }
    else
    {
        NSString *filter = @"### ### ####";
        
        NSString *strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"mobile_phone"], filter);
        lblMobile.text=strContact;
        //            lblMobile4.text=[userDefault objectForKey:@"mobile"];
    }
    
    //    lblMobile.text=[dictContact objectForKey:@"mobile_phone"];
    
    imgUserPhoto.layer.cornerRadius=imgUserPhoto.frame.size.height/2;
    imgUserPhoto.layer.masksToBounds=YES;
    imgUserPhoto.layer.borderWidth=0;
}

- (IBAction)btnOkAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
