
#import "BaseViewContoller+KeyboardFrame.h"
#import "UIDevice+Resolutions.h"

@implementation BaseViewContoller (KeyboardFrame)

-(UIView *)setViewframe:(UITextField *)textField withContainerView:(UIView *)viewContainer forSuperView:(UIView *)superView{
    
    CGRect textFieldRect =[viewContainer convertRect:textField.frame toView:superView];
     int movementDistance=(textFieldRect.origin.y+textFieldRect.size.height)-superView.frame.size.height;
    int keyboardHeight=[self getKeyboardHeight];
        keyboardHeight+=44;
    
    movementDistance+=keyboardHeight;
   
    if(movementDistance>0)
    {
    self.topSpaceConst.constant-=movementDistance;

  [UIView animateWithDuration:0.4f animations:^{
      [self.view layoutIfNeeded];
      
  }];
   }

    return viewContainer;
    
}


-(void)resetViewframe
{
    self.topSpaceConst.constant=0;
    
    [UIView animateWithDuration:0.4f animations:^{
        [self.view layoutIfNeeded];
        
    }];

   
}

-(void)resetViewframeWithOutAnim
{
    self.topSpaceConst.constant=0;
    [self.view layoutIfNeeded];
}




-(CGFloat)getAnimatedDistance:(CGFloat)heightFraction{
 
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = floor(264 * heightFraction);
        }
        else
        {
            animatedDistance = floor(352 * heightFraction);
        }
    }
    else {
        UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = floor(216 * heightFraction);
        }
        else
        {
            animatedDistance = floor(162 * heightFraction);
        }
    }
    return animatedDistance;
}


-(CGFloat)getKeyboardHeight
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = 264.0f;
        }
        else
        {
            animatedDistance = 352.0f;
        }
    }
    else {
        UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = 216.0f;
        }
        else
        {
            animatedDistance = 162.0f;
        }
    }
    return animatedDistance;
}




@end
