//
//  SettingMenuView.m
//  Tapt
//
//  Created by Pragnesh Dixit on 7/18/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "SettingMenuView.h"

@implementation SettingMenuView
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*-(IBAction)btnclickAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(buttontapped:)]) {
       [self.delegate buttontapped:btn.tag];  
    }
   
}*/


- (IBAction)btnDeleteAccountAction:(id)sender {
   
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    DeleteContactViewController *DeleteContactViewController=[storyboard instantiateViewControllerWithIdentifier:@"DeleteContactViewController"];
    [navVc pushViewController:DeleteContactViewController animated:YES];
    
}

- (IBAction)btnWhoihaveShareAction:(id)sender {
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    WhoShareWithViewController *vcWhosharewith=[storyboard instantiateViewControllerWithIdentifier:@"WhoShareWithViewController"];
    [navVc pushViewController:vcWhosharewith animated:YES];
}

- (IBAction)btnHelpAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isFromHelp"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    IntroPageViewController *vcIntro=[storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
    [navVc pushViewController:vcIntro animated:YES];
    
}

- (IBAction)btnTaptonWebAction:(id)sender {
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    WebViewViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    vc.strTitle=@"TAPT on the Web";
    vc.strUrl=[NSString stringWithFormat:@"http://tapt-app.com"];
    [navVc pushViewController:vc animated:YES];
    
}

- (IBAction)btnCreditAction:(id)sender {
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    WebViewViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    vc.strTitle=@"Credits";
    vc.strUrl=[NSString stringWithFormat:@"http://tapt-app.com/credits"];
    [navVc pushViewController:vc animated:YES];

}

- (IBAction)btnTermsCondition:(id)sender {
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    WebViewViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    vc.strTitle=@"Terms & Conditions";
    vc.strUrl=[NSString stringWithFormat:@"http://tapt-app.com/legal"];
    [navVc pushViewController:vc animated:YES];

}


- (IBAction)btnTellaFriendAction:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-(self.frame.size.width), [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
    }];
   
    NSString *message = @"Check out TAPT for your smartphone. It’s your electronic business card and much more. Download it today from:";
    NSString *shareBody =@"http://get.tapt­app.com";
    
    // NSLog(@"%@",shareBody);
    NSArray *postItems = @[message,shareBody];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];

   [[self parentViewController] presentViewController:activityVC animated:YES completion:nil];

    
}

#pragma maek - get viewcontroller method
//get view controller for present activity view controller for sharing
- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return responder;
}

- (IBAction)btnFindAFriendAction:(id)sender {
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    FindMeViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"FindMeViewController"];
    
    [navVc pushViewController:vc animated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)BuyTaptAction:(id)sender {
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    BuyTaptViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"BuyTaptViewController"];
  
    [navVc pushViewController:vc animated:YES];
}

- (IBAction)AboutTaptAction:(id)sender {
    
    UINavigationController *navVc  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    AboutTaptViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"AboutTaptViewController"];
    [navVc pushViewController:vc animated:YES];
}
@end
