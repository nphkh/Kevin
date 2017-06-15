//
//  ProfileTabbarViewController.h
//  Tapt
//
//  Created by TriState  on 6/20/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabbarController.h"
@interface ProfileTabbarViewController : UIViewController
{
    CustomTabbarController *tabbarVC;
    
}
-(IBAction)btnMenuSelected:(id)sender;
@end
