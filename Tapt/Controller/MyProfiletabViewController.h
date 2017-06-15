//
//  MyProfiletabViewController.h
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
#import "AppDelegate.h"
@interface MyProfiletabViewController : BaseViewContoller<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITabBarControllerDelegate,UITextFieldDelegate>
{
    
    NSMutableArray *arrUserDetail;
   
}
@property (strong, nonatomic, readonly) MaskedTextField *mask;

@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (strong, nonatomic) UITextField *txtFieldCheck;
@property (strong,nonatomic) NSMutableArray *arrKeyForShare;
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtFirstname;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtLastname;
@property (strong, nonatomic) IBOutlet UIButton *btnFirstName;

//@property (strong, nonatomic) IBOutlet TextFieldValidator *txtMobileNumber;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtMobileNumber;


@property (strong, nonatomic) IBOutlet UIButton *btnMobileNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnLastName;
@property (strong, nonatomic) IBOutlet UIButton *btnPicture;

@property(strong,nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlview;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)btnMyPhoto:(id)sender;

- (IBAction)btnShareFieldStatusAction:(id)sender;
@end
