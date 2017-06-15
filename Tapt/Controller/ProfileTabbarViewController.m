//
//  ProfileTabbarViewController.m
//  Tapt
//
//  Created by TriState  on 6/20/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ProfileTabbarViewController.h"

@interface ProfileTabbarViewController (){
    BOOL isResized;
}

@end

@implementation ProfileTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabbarcontroller];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear) name:@"viewWillAppear" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillDisAppear) name:@"viewWillDisappear" object:nil];
  
   // [self.tabBarController.tabBar setBackgroundColor:[UIColor redColor]];
//    self.customizableViewControllers = @[];
//    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillDisAppear{
    isResized = NO;
}
-(void)viewWillAppear{
    NSArray *array=[self.view subviews];
    if(isResized){
        isResized = NO;
        return;
    }
    for(UIView *view in [self.view subviews]){
        NSLog(@"View : %@",view);
        isResized = YES;
        [view setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-53)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTabbarcontroller{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"MyProfiletabViewController",@"HomeProfileViewController",@"BusinessProfiletabViewController",@"OfficeProfileViewController",@"CardLayoutViewController",@"SocialProfileViewController", nil];
    NSMutableArray *vcArray = [NSMutableArray array];
    for(NSString *className in array){
        UINavigationController *navVC = [self createNavigationViewController:className];
        [vcArray addObject:navVC];
    }
    
    tabbarVC = [[CustomTabbarController alloc] initWithBaseView:self.view navigationControllerArray:vcArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-53)];
    [tabbarVC setSelectedIndex:0];
}
-(UINavigationController*)createNavigationViewController:(NSString*)strVCName{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:strVCName];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
   // [navController.view setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-103)];
    navController.navigationBarHidden = YES;
    return navController;
}
-(IBAction)btnMenuSelected:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    [tabbarVC setSelectedIndex:index];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)dealloc{
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"viewWillAppear" object:nil];

}
@end
