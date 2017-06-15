//
//  CustomDetailMapView.h
//  mPhletDesign
//
//  Created by Parth on 09/02/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
#import "AskPermissionTVCell.h"

@protocol CustomDelegatShare <NSObject>

@required

- (void)sharePermissionChage:(NSMutableDictionary *)dict;

@end

@interface AskSharePermissionView : UIView<UITableViewDelegate,UITableViewDataSource,CustomDelegatShareCell>
{
    NSUserDefaults *userDefault;

}
@property (strong,nonatomic) id<CustomDelegatShare>delegate;
- (IBAction)btnHideAction:(id)sender;
-(void) showInView:(UIView *) superView;
@property (strong, nonatomic) IBOutlet UIView *viewSubDialoge;
@property (strong,nonatomic) NSMutableArray *arrFieldName;
@property (strong,nonatomic) NSMutableArray *arrUDName;
@property (strong,nonatomic) NSMutableArray *arrFieldNameSort;

@property (strong,nonatomic) NSMutableDictionary *dictShare;

@property (strong, nonatomic) IBOutlet UITableView *tblViewField;

- (IBAction)btnOkAction:(id)sender;
- (IBAction)btnCancelAction:(id)sender;

@end
