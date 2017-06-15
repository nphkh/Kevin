//
//  ContactDetailViewController.h
//  Tapt
//
//  Created by Pragnesh Dixit on 16/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "OAuthLoginView.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UserDetail.h"
#import "Database.h"
#import "ProfileTabbarViewController.h"
#import "SendContactViewController.h"
#import "ReceiveContactFirstViewController.h"
#import "InformationViewController.h"
#import "ReceiveTagViewController.h"
#import <MessageUI/MessageUI.h>
//#import "Sharekit.h"

@interface ContactDetailViewController : BaseViewContoller<OAuthDelegate,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *arrUserDetail;
    UIView  *settingView;
    int flagMenuopen;
    NSMutableArray *arrfavorite;
}

@property (strong, nonatomic) NSDictionary *dictContact;
@property (strong, nonatomic) IBOutlet UILabel *lblHeadertext;
- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnaddress:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewLayout1;
@property (strong, nonatomic) IBOutlet UIView *viewLayout2;
@property (strong, nonatomic) IBOutlet UIView *viewLayout3;
@property (strong, nonatomic) IBOutlet UIView *viewLayout4;

- (IBAction)btnMoreAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;


//view1
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;


@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG;

@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG;

@property (strong, nonatomic) IBOutlet UILabel *lblMobile;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG;



//view2
@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress3;
@property (strong, nonatomic) IBOutlet UILabel *lblStatePostcode;

@property (strong, nonatomic) IBOutlet UILabel *lblWebsite2;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG2;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle2;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail2;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG2;

@property (strong, nonatomic) IBOutlet UILabel *lblName2;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile2;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG2;



//view3
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite3;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG3;

@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic3;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle3;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail3;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG3;

@property (strong, nonatomic) IBOutlet UILabel *lblName3;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile3;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG3;


@property (strong, nonatomic) IBOutlet UIImageView *imgLogo3;

//view4
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo4;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail4;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG4;

@property (strong, nonatomic) IBOutlet UILabel *lblWebsite4;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG4;

@property (strong, nonatomic) IBOutlet UILabel *lblMobile4;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG4;

@property (strong, nonatomic) IBOutlet UILabel *lblName4;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle4;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderBG;

//other detail

@property (strong, nonatomic) IBOutlet UILabel *lblViewHomePhone;
@property (strong, nonatomic) IBOutlet UILabel *lblViewHomeEmail;

//@property (strong, nonatomic) IBOutlet UITextView *txtViewHomeAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblHOmeAddress;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblHomeAddressHeight;

- (IBAction)btnNoteAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewMoreItem;
- (IBAction)btnInformationAction:(id)sender;
- (IBAction)btnTagAction:(id)sender;
- (IBAction)btnAddtoFavoriteAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;

@property (strong, nonatomic) IBOutlet UIImageView *imgAddtoFavorite;



@property (strong, nonatomic) IBOutlet UIView *viewHomephone;
@property (strong, nonatomic) IBOutlet UIView *viewHomeMail;
@property (strong, nonatomic) IBOutlet UILabel *lblViewCompanyname;
@property (strong, nonatomic) IBOutlet UIView *viewHomeAddress;

@property (strong, nonatomic) IBOutlet UILabel *lblViewOffiecePhoneno;
@property (strong, nonatomic) IBOutlet UILabel *lblViewOfficeMobileno;
@property (strong, nonatomic) IBOutlet UILabel *lblViewOfficeEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblViewWebsite;
//@property (strong, nonatomic) IBOutlet UITextView *txtViewOfficeAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblOfficeAddress;

@property (strong, nonatomic) IBOutlet UIView *viewCompanyName;

@property (strong, nonatomic) IBOutlet UIView *viewCompanyPhone;

@property (strong, nonatomic) IBOutlet UIView *viewCompanyMobileNo;

@property (strong, nonatomic) IBOutlet UIView *viewOffieceEmail;
@property (strong, nonatomic) IBOutlet UIView *viewWebsite;
@property (strong, nonatomic) IBOutlet UIView *viewCompanyAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imgGreycellHomeAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imgGreycellCompanyAddress;


//height constrints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homePhoneTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homeEmailTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homeAddressTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyNameTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyNumberTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyMobilePhonetop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *officeEmailTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *websiteTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *officeAddressTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homePhoneHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homeEmailAddHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *HomeAddressHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyNameHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyPhoneHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyMobileHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *officeEmailHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *websiteHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *companyAddHeight;
@property (strong, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrlViewHeight;

@end
