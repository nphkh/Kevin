//
//  BuyTaptViewController.h
//  Tapt
//
//  Created by TriState  on 7/23/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "TextFieldValidator.h"
@interface BuyTaptViewController :BaseViewContoller<MBProgressHUDDelegate>
{
     NSString *strProductId;
}
@property (nonatomic, retain) NSString *strProductId;
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet UIView *contentView;



@property (strong, nonatomic) IBOutlet UILabel *lbltaptaviailable;

@property (strong, nonatomic) IBOutlet UILabel *lblNote1;
@property (strong, nonatomic) IBOutlet UILabel *lblNote2;
@property (strong, nonatomic) IBOutlet UILabel *lblNote3;

@property (strong, nonatomic) IBOutlet UILabel *lblNote4;
- (IBAction)btnBuyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBuy;

@property (strong, nonatomic) IBOutlet TextFieldValidator *txtPromoCode;


- (IBAction)btnOKAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) UITextField *txtFieldCheck;

@property (strong, nonatomic) IBOutlet UILabel *lblOr;

@end
