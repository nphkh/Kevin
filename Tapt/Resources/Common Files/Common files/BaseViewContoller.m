

#import "BaseViewContoller.h"
//#import "MFSideMenuContainerViewController.h"

#define MARGIN_TOP 21

@implementation BaseViewContoller
@synthesize spinner;
@synthesize topSpaceConst;
@synthesize containerViewBase;
@synthesize service;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)isNetworkReachable{
    return [self isNetworkReachable:@"http://www.google.com"];
}
- (BOOL)isNetworkReachable:(NSString*)NetPath 
{
	[[NetworkReachability sharedReachability] setHostName:[NSString stringWithFormat:@"%@",NetPath]];
	NetworkReachbilityStatus remoteHostStatus = [[NetworkReachability sharedReachability] internetConnectionStatus];
	
	if (remoteHostStatus == NetworkNotReachable)
		return NO;
	else if((remoteHostStatus == ReachableViaCarrierDataNetwork) || (remoteHostStatus == ReachableViaWiFiNetwork))
		return YES;
	return NO;
}
- (void)showHud
{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Loading";
        [HUD show:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }  
}

- (void)hidHud
{
    if (HUD) {
        [HUD show:NO];
        [HUD removeFromSuperview];
        HUD = nil;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (void)showSpinnerWithUserActionEnable:(BOOL)isEnable
{
    [spinner startAnimating];
    self.view.userInteractionEnabled = isEnable;
}

- (void)hideSpinner
{
    [spinner stopAnimating];
    self.view.userInteractionEnabled = YES;
}
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 )
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    userDefault=[NSUserDefaults standardUserDefaults];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
//    return UIStatusBarStyleDefault;
}


-(void) viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
  
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}

//
//-(void) addCenterGesture:(BOOL) addremoveGesture
//{
//    UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
//    UINavigationController *navController=(UINavigationController *)[window rootViewController];
//    
//    for (UIViewController *vcInner in navController.viewControllers )
//    {
//        if([vcInner isKindOfClass:[MFSideMenuContainerViewController class]])
//        {
//            MFSideMenuContainerViewController *mfVc=(MFSideMenuContainerViewController *)vcInner;
//            mfVc.panMode = MFSideMenuPanModeNone;
//            if(!addremoveGesture)
////                [mfVc removeCenterGestureRecognizers];
//                mfVc.panMode = MFSideMenuPanModeNone;
//            else
//                mfVc.panMode = MFSideMenuPanModeDefault;
//
//             //   [mfVc addCenterGestureRecognizers];
//            break;
//        }
//    }
//}



-(void) logout
{
    
  //  UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
    //UINavigationController *navController=(UINavigationController *)window.rootViewController;
    
//    for (UIViewController *vc in navController.viewControllers) {
//        if([vc isKindOfClass:[LoginViewController class]] || [vc isKindOfClass:[SplashWelcomeViewController class]])
//        {
//            [navController popToViewController:vc animated:YES];
//            break;
//        }
//    }
}



@end
