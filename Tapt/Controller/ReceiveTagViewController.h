//
//  ReceiveTagViewController.h
//  Tapt
//
//  Created by TriState  on 7/2/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "Database.h"

@interface ReceiveTagViewController : BaseViewContoller<UITextFieldDelegate>
{
    NSMutableArray *arrTags;
    NSMutableDictionary *dictTag;
    UIButton *btnTags;
    NSMutableArray *arrSelectedTags;
}
@property (strong, nonatomic) NSString *senderIDForTag;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIView *viewAddTag;
@property (strong, nonatomic) IBOutlet UIButton *btnAddTag;

- (IBAction)btnAddtagAction:(id)sender;


@property (strong, nonatomic) IBOutlet UIScrollView *scrlTagContainer;
@property (strong, nonatomic) IBOutlet UIView *viewTags;
@property (strong, nonatomic) IBOutlet UITextField *txtAddTag;
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;

@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ViewAddTagHeightConstrints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnAddTagHeightConstrints;

@end
