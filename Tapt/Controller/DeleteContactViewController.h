//
//  DeleteContactViewController.h
//  Tapt
//
//  Created by TriState  on 7/13/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "ContactDetailViewController.h"

@interface DeleteContactViewController : BaseViewContoller
{
    NSMutableArray *arrUserDetail;
    
    UIView  *settingView;
    int flagMenuopen;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
- (IBAction)btnBackAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblDeleteContect;
@property (strong, nonatomic) IBOutlet UILabel *lblAllDelete;
@property (strong, nonatomic) IBOutlet UILabel *lblDeleteContact1;
@property (strong, nonatomic) IBOutlet UILabel *lblYes;
@property (strong, nonatomic) IBOutlet UILabel *lblcantundo;

@property (strong, nonatomic) IBOutlet UILabel *lblNo;
- (IBAction)switchContactDelete:(id)sender;

- (IBAction)SliderValueChange:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *sliderDeleteAccount;

@end
