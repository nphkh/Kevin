//
//  AskPermissionTVCell.h
//  Tapt
//
//  Created by Parth on 18/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDelegatShareCell <NSObject>

@required

- (void)sharePermissionChage:(NSInteger)intIndex select:(BOOL)selected;

@end

@interface AskPermissionTVCell : UITableViewCell
@property (strong,nonatomic) id<CustomDelegatShareCell>delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblField;
@property (strong, nonatomic) IBOutlet UIButton *btnColor;
@property (strong, nonatomic) IBOutlet UIButton *btnClick;

- (IBAction)btnClickToChangeAction:(id)sender;

@end
