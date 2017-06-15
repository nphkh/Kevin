//
//  AboutTaptViewController.h
//  Tapt
//
//  Created by TriState  on 7/23/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"

@interface AboutTaptViewController : BaseViewContoller
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet UIView *ContentView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *lblTapt;
@property (strong, nonatomic) IBOutlet UILabel *lblCopyRight;
@property (strong, nonatomic) IBOutlet UILabel *lblAllRight;
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;

@property (strong, nonatomic) IBOutlet UIView *viewLoveTapt;

@property (strong, nonatomic) IBOutlet UILabel *lblLoveTapt;
@property (strong, nonatomic) IBOutlet UILabel *lblRateUs;

- (IBAction)btnRateAppAction:(id)sender;



@end
