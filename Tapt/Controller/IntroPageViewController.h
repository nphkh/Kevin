//
//  IntroPageViewController.h
//  Tapt
//
//  Created by TriState  on 6/19/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTabbarViewController.h"
#import "SendContactViewController.h"
#import "ReceiveContactFirstViewController.h"
#import "Database.h"
#import "UserDetail.h"


@interface IntroPageViewController : BaseViewContoller<UIAlertViewDelegate>
{
    UIView *imgview;
    NSInteger pageIndex;
    NSMutableArray *arrUserDetail;
    
    UIView  *settingView;
    int flagMenuopen;
}

//outlates
@property (weak, nonatomic) IBOutlet UIScrollView *scrIntro;
@property (weak, nonatomic) IBOutlet UIPageControl *pgctrlIntro;
@property (weak, nonatomic) IBOutlet UIView *viewIntroImages;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
//actions
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackAction:(id)sender;

- (IBAction)pagechangeAction:(id)sender;
- (IBAction)btnPersonTabAction:(id)sender;
- (IBAction)btnSendTabAction:(id)sender;
- (IBAction)btnReceiveTabAction:(id)sender;
- (IBAction)btnSettingAction:(id)sender;


- (IBAction)btnFavoriteTabAction:(id)sender;
//property

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstForImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstForView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBg;

@end
