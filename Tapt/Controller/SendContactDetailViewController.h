//
//  SendContactDetailViewController.h
//  Tapt
//
//  Created by TriState  on 7/1/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "Database.h"

@interface SendContactDetailViewController : BaseViewContoller <UITextFieldDelegate,UIAlertViewDelegate>
{
    
   
    
    
}
- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnCancelAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIImageView *imgQRPreview;
@property (strong, nonatomic) NSMutableString *strsharefeild;



@end
