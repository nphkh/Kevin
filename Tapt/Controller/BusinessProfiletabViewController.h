//
//  BusinessProfiletabViewController.h
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
#import "ContactViewController.h"

@interface BusinessProfiletabViewController : BaseViewContoller<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITabBarControllerDelegate>
{
      ACAccountStore *accountStore;
    NSMutableArray *arrUserDetail;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) UITextField *currentTextField;
@property (strong, nonatomic, readonly) MaskedTextField *mask;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (strong, nonatomic) UITextField *txtFieldCheck;
@property (strong,nonatomic) NSMutableArray *arrKeyForShare;


@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtCompanyname;
@property (strong, nonatomic) IBOutlet UITextField *txtOfficeMobileNumber;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtTitle;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtOfficePhonenumber;
@property (strong, nonatomic) IBOutlet UITextField *txtOfficeEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtWebsite;

- (IBAction)btnShareFieldStatusAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;


@property (strong, nonatomic) IBOutlet UIButton *btnCompanyname;
@property (strong, nonatomic) IBOutlet UIButton *btnTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnOfficePhonenumber;
@property (strong, nonatomic) IBOutlet UIButton *btnOfficeMobileNumber;

@property (strong, nonatomic) IBOutlet UIButton *btnOfficeEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnWebsite;
@property (strong, nonatomic) IBOutlet UIButton *btnLogo;
- (IBAction)btnLogoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;

@end
