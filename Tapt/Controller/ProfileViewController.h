//
//  ViewController.h
//  Tapt
//
//  Created by Parth on 08/05/15.
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

@interface ProfileViewController: BaseViewContoller<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
        ACAccountStore *accountStore;
}

@property (strong, nonatomic, readonly) MaskedTextField *mask;

@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (strong, nonatomic) UITextField *txtFieldCheck;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
//@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
//@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
//@property (strong, nonatomic) IBOutlet UITextField *txtMobile;

@property (strong,nonatomic) NSMutableArray *arrKeyForShare;


@property (strong, nonatomic) IBOutlet TextFieldValidator *txtFirstName;

@property (strong, nonatomic) IBOutlet TextFieldValidator *txtLastName;

@property (strong, nonatomic) IBOutlet UITextField *txtMobile;

@property (strong, nonatomic) IBOutlet UITextField *txtWorkContact;
@property (strong, nonatomic) IBOutlet UITextField *txtHomeContact;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtPersonalEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtWebsite;


@property (strong, nonatomic) IBOutlet UITextField *txtCompany;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress1;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress2;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress3;
@property (strong, nonatomic) IBOutlet UITextField *txtSuburb;
@property (strong, nonatomic) IBOutlet UITextField *txtPostCode;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;

@property (strong, nonatomic) IBOutlet UITextField *txtSkypeName;


@property (strong, nonatomic) IBOutlet UIImageView *imgUserPhoto;

//share field buuton outlate
@property (weak, nonatomic) IBOutlet UIButton *btnFirstName;
@property (weak, nonatomic) IBOutlet UIButton *btnLastName;
@property (weak, nonatomic) IBOutlet UIButton *btnMobile;
@property (weak, nonatomic) IBOutlet UIButton *btnWork;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail2;

@property (strong, nonatomic) IBOutlet UIButton *btnWebsite;

@property (weak, nonatomic) IBOutlet UIButton *btnCompany;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress1;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress2;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress3;
@property (weak, nonatomic) IBOutlet UIButton *btnSuburb;
@property (weak, nonatomic) IBOutlet UIButton *btnPostcode;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *btnState;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnCompanyLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIButton *btnSkype;
//Social

@property (strong, nonatomic) IBOutlet UILabel *lblFacebookName;
@property (strong, nonatomic) IBOutlet UILabel *lblTwitterName;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkedInName;

@property (strong, nonatomic) IBOutlet UIButton *btnFacebookLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitterLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedInLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebookSetup;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitterSetup;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedInSetup;






- (IBAction)btnSaveAction:(id)sender;
- (IBAction)btnMyProfile:(id)sender;
- (IBAction)btnCardLayout:(id)sender;
- (IBAction)btnBackAction:(id)sender;

- (IBAction)btnShareFieldStatusAction:(id)sender;

- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)btnLinkedInAction:(id)sender;
- (IBAction)btnCompanyLogoAction:(id)sender;
- (IBAction)btnLogoAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;

@end

