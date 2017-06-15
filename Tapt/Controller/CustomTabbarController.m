

#import "CustomTabbarController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "Webservice.h"

@implementation CustomTabbarController
{
    MBProgressHUD *HUD;
}
@synthesize viewControllers;
@synthesize view;
@synthesize selectedIndex;

-(id)initWithBaseView:(UIView *)baseView navigationControllerArray:(NSMutableArray*)array frame:(CGRect)rect{
    if(self = [super init]){
        self.view = baseView;
        frame = rect;
        self.viewControllers =  array;
    }
    return self;
}

-(void)setSelectedIndex:(NSInteger)index{

    UINavigationController *navVC = [viewControllers objectAtIndex:index];
    UIViewController *viewController=[navVC visibleViewController];
    UIView *navView = navVC.view;
    [navView setFrame:frame];
    [view addSubview:navView];
}

-(void)dealloc{
    self.viewControllers = nil;
    self.view = nil;
}

@end
