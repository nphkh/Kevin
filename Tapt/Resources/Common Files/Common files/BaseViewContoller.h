#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NSString+Extensions.h"
#import "Constants.h"
#import "NetworkReachability.h"
#import "UIAlertView+utils.h"
#import "Webservice.h"
#import "UIView+NIB.h"

@class PanEnableCell;

@interface BaseViewContoller : UIViewController<UIGestureRecognizerDelegate>
{
    
    MBProgressHUD *HUD;
    AppDelegate *appDelegate;
    NSUserDefaults *userDefault;

}


@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic,weak)IBOutlet  NSLayoutConstraint *topSpaceConst;
@property (nonatomic,weak) IBOutlet UIView *containerViewBase;
@property (nonatomic,strong) Webservice *service;

- (BOOL)isNetworkReachable:(NSString*)NetPath;
- (BOOL)isNetworkReachable;
- (void)showHud;
- (void)hidHud;
- (void)showSpinnerWithUserActionEnable:(BOOL)isEnable;
- (void)hideSpinner;
//-(void) addCenterGesture:(BOOL) addremoveGesture;

-(void) logout;


@end
