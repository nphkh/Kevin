//
//  HomeProfileViewController.h
//  Tapt
//
//  Created by TriState  on 6/20/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
#import "BaseViewContoller.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "OAuthLoginView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MaskedTextField.h"
#import "MaskFormatter.h"
#import "UserDetail.h"
#import "IntroPageViewController.h"
#import "ContactViewController.h"


@interface HomeProfileViewController : BaseViewContoller<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITabBarControllerDelegate>
{
     ACAccountStore *accountStore;
     NSMutableArray *arrUserDetail;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic, readonly) MaskedTextField *mask;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (strong, nonatomic) UITextField *txtFieldCheck;
@property (strong,nonatomic) NSMutableArray *arrKeyForShare;
@property(strong,nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtHomePhonenumber;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtEmail;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtHomeAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtStreet;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtPostCode;
@property (strong, nonatomic) IBOutlet UIButton *btnHomePhonenumber;
@property (strong, nonatomic) IBOutlet UIButton *btnHomeEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnHomeAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnStreet;
@property (strong, nonatomic) IBOutlet UIButton *btnState;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;
@property (strong, nonatomic) IBOutlet UIButton *btnPostCode;
- (IBAction)btnShareFieldStatusAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackAction:(id)sender;

@end
