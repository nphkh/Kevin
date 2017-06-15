//
//  OfficeProfileViewController.h
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

@interface OfficeProfileViewController : BaseViewContoller<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITabBarControllerDelegate>
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


@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtOfficeAddress;

@property (strong, nonatomic) IBOutlet TextFieldValidator *txtStreet;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;

@property (strong, nonatomic) IBOutlet UITextField *txtPostCode;

- (IBAction)btnShareFieldStatusAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;

@property (strong, nonatomic) IBOutlet UIButton *btnOfficeAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnStreet;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;
@property (strong, nonatomic) IBOutlet UIButton *btnState;
@property (strong, nonatomic) IBOutlet UIButton *btnPostCode;

@end
