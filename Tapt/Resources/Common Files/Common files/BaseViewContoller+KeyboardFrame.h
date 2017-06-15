
#import "BaseViewContoller.h"
#import <UIKit/UIKit.h>

    CGFloat animatedDistance;

@interface BaseViewContoller (KeyboardFrame)

-(UIView *)setViewframe:(UITextField *)textField withContainerView:(UIView *)viewContainer forSuperView:(UIView *)superView;
-(void)resetViewframe;
-(void)resetViewframeWithOutAnim;


@end
