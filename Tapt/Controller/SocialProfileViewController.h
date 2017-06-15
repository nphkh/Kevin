//
//  SocialProfileViewController.h
//  Tapt
//
//  Created by TriState  on 6/20/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "OAuthLoginView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MaskedTextField.h"
#import "MaskFormatter.h"
#import "UserDetail.h"
#import "ContactViewController.h"

@interface SocialProfileViewController : BaseViewContoller<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
     ACAccountStore *accountStore;
    NSMutableArray *arrUserDetail;
}
@property(strong,nonatomic) UITextField *currentTextField;
@property (strong, nonatomic, readonly) MaskedTextField *mask;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (strong, nonatomic) UITextField *txtFieldCheck;
@property (strong,nonatomic) NSMutableArray *arrKeyForShare;


@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebookLogin;
- (IBAction)btnFacebookAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblFacebookName;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebookSetup;
@property (strong, nonatomic) IBOutlet UILabel *lblTwitterName;
- (IBAction)btnShareFieldStatusAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitterLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitterSetup;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkedInName;
- (IBAction)btnLinkedInAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedInLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedInSetup;
@property (strong, nonatomic) IBOutlet UITextField *txtSkypename;


@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIButton *btnSkyp;

@end
