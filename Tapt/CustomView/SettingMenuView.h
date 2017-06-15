//
//  SettingMenuView.h
//  Tapt
//
//  Created by Pragnesh Dixit on 7/18/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhoShareWithViewController.h"
#import "DeleteContactViewController.h"
#import "IntroPageViewController.h"
#import "WebViewViewController.h"
#import "FindMeViewController.h"
#import "AboutTaptViewController.h"
#import "BuyTaptViewController.h"

@protocol SettingMenuViewDelegate<NSObject>
//- (void)btnTellAFriendAction:obj;
@end

@interface UIView (mxcl)
- (UIViewController *)parentViewController;
@end


@interface SettingMenuView : UIView
@property (nonatomic, assign) id <SettingMenuViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewBg;

- (IBAction)btnDeleteAccountAction:(id)sender;
- (IBAction)btnWhoihaveShareAction:(id)sender;
- (IBAction)btnHelpAction:(id)sender;
- (IBAction)btnTaptonWebAction:(id)sender;
- (IBAction)btnCreditAction:(id)sender;
- (IBAction)btnTellaFriendAction:(id)sender;
- (IBAction)btnTermsCondition:(id)sender;
- (IBAction)btnFindAFriendAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnTellAFriend;
- (IBAction)BuyTaptAction:(id)sender;
- (IBAction)AboutTaptAction:(id)sender;

@end
