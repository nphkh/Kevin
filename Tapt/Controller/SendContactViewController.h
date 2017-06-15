//
//  SendContactViewController.h
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "AskSharePermissionView.h"
#import "SendContactDetailViewController.h"
#import "ContactViewController.h"
#import <MessageUI/MessageUI.h>
@interface SendContactViewController : BaseViewContoller<UITextFieldDelegate,UIAlertViewDelegate,CustomDelegatShare,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
   int flagMyprofile;
   int flagHomeprofile;
   int flagBusinessprofile;
   int flagOfficeprofile;
   int flagbusinesscard;
   int flagsocialprofile;
    
   BOOL isaskpermision;
   BOOL isfromQrcode;
    
   int countForEmailShare;
   int countForSmsShare;
    
    NSMutableArray *Feildforemail;
    NSString *dataforshare;
}

@property (strong, nonatomic) IBOutlet UIImageView *imgQRPreview;

@property (strong, nonatomic) NSMutableArray *arrKeyForShare;
@property (strong,nonatomic) NSMutableArray *arrNewKeyForShare;

@property (strong, nonatomic) NSMutableArray *arrFieldForShare;
@property (strong, nonatomic) NSMutableArray *arrNewFieldForShare;

@property (strong, nonatomic) NSMutableArray *arrKeyField;
@property (strong, nonatomic) NSMutableArray *arrNewKeyField;

@property (strong, nonatomic) NSMutableArray *arrDatabaseFeild;

@property (strong, nonatomic) NSMutableDictionary *dictPermissionIndex;
@property (strong, nonatomic) NSMutableDictionary *dictPermission;

@property (strong, nonatomic) NSString *strMobileNo;
@property (strong, nonatomic) NSString *strEmail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintsForAskPermission;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraintsForAskermission;

- (IBAction)btnSendMessageAction:(id)sender;
- (IBAction)btnSendEmailAction:(id)sender;

- (IBAction)btnQRCodeAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;



- (IBAction)btnMyprofileshareAction:(id)sender;
- (IBAction)btnHomeprofileshareAction:(id)sender;
- (IBAction)btnBusinessprofileshareAction:(id)sender;
- (IBAction)btnOfficeprofileshareAction:(id)sender;
- (IBAction)btnBusinesscardshareAction:(id)sender;
- (IBAction)btnSocialprofileshareAction:(id)sender;
- (IBAction)btnCodeAction:(id)sender;




@end
