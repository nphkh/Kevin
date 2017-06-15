//
//  ReceiveContactViewController.h
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewContoller.h"

@interface ReceiveContactViewController : BaseViewContoller<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (weak,nonatomic)IBOutlet UIView *viewPreview;

@property (strong , nonatomic) NSString *strSenderId;

- (IBAction)btnBackAction:(id)sender;

- (IBAction)QRCodeReceiveAction:(id)sender;
- (IBAction)btnReceiveSMSAction:(id)sender;
- (IBAction)btnReceiveEmailAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnCancelAction:(id)sender;
- (IBAction)btnGoToTag:(id)sender;


@end
