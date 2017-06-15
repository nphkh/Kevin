
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface CustomTabbarController : NSObject{
    NSMutableArray *viewControllers;
    NSInteger selectedIndex;

    CGRect frame;
}

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) UIView *view;
-(id)initWithBaseView:(UIView *)baseView navigationControllerArray:(NSMutableArray*)array frame:(CGRect)rect;

@end
