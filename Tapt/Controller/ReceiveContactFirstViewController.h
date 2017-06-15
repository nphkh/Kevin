//
//  ReceiveContactFirstViewController.h
//  Tapt
//
//  Created by TriState  on 6/26/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveContactViewController.h"
#import "ContactViewController.h"
@interface ReceiveContactFirstViewController : BaseViewContoller
- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnReceveQrcode:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)btnCancelAction:(id)sender;

@end
