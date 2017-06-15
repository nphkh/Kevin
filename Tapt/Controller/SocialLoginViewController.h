//
//  SocialLoginViewController.h
//  Tapt
//
//  Created by Parth on 25/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
#import "BaseViewContoller.h"
#import "IntroPageViewController.h"
#import "UserDetail.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ContactViewController.h"
@interface SocialLoginViewController : BaseViewContoller<GPPSignInDelegate>
{
  
}
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

@property(strong,nonatomic) NSMutableDictionary *dictContactResponse;
@property(strong, nonatomic)NSMutableArray *arrKeyForShare;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebooklogin;
@property (strong, nonatomic) UITextField *txtFieldCheck;
@property (strong, nonatomic) IBOutlet UIButton *btnGoogleplushlogin;

@property (strong, nonatomic) IBOutlet UILabel *lblOR;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtEmail;

@property (strong, nonatomic) IBOutlet TextFieldValidator *txtPassword;


@property (strong, nonatomic) IBOutlet UIView *viewEmail;

@property (strong, nonatomic) IBOutlet UIView *viewPassword;


- (IBAction)btnFacebookLoginAction:(id)sender;
- (IBAction)btnGoogleplushLoginAction:(id)sender;
- (IBAction)btnSigninAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstrints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticleSpace;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;

@end
