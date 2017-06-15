//
//  WhoSharedWithDetailViewController.h
//  Tapt
//
//  Created by TriState  on 7/13/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesTVCell.h"
#import "BaseViewContoller.h"
#import "WhoshareWithTVCell.h"
#import "SettingMenuView.h"

@interface WhoSharedWithDetailViewController : BaseViewContoller<UITableViewDataSource,UITableViewDelegate,WhoSharewithdelegate>
{
    NSMutableArray *arrUserDetail;
    
    NSMutableArray *arrsharedFeiled;
    NSMutableArray *arrFieldkey;
    NSMutableArray *bufferArray;
    
    UIView  *settingView;
    int flagMenuopen;
}
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITableView *tblSharedFeilddetail;
@property (strong,nonatomic) NSMutableDictionary *sharedFeildContact;
- (IBAction)btnBackAction:(id)sender;
//tab action
- (IBAction)btnPersoneTabAction:(id)sender;
- (IBAction)btnSendTabAction:(id)sender;
- (IBAction)btnReceiveTabAction:(id)sender;
- (IBAction)btnFavoriteTabAction:(id)sender;

- (IBAction)btnSettingTabAction:(id)sender;



@end
