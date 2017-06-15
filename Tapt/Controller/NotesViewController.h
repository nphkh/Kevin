//
//  NotesViewController.h
//  Tapt
//
//  Created by TriState  on 7/4/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesTVCell.h"
#import "BaseViewContoller.h"
#import "UserDetail.h"
#import "ProfileTabbarViewController.h"
#import "Database.h"
#import "SendContactViewController.h"
#import "ReceiveContactFirstViewController.h"
#import "StringHelper.h"
@interface NotesViewController : BaseViewContoller<UITableViewDataSource,UITabBarDelegate,Notecelldelegate,UITextFieldDelegate>
{
    NSMutableArray *arrNotesdetail;
    NSMutableDictionary *dictNoteDetail;
    NSMutableArray *arrUserDetail;


    UIView  *settingView;
    int flagMenuopen;
}
@property (strong, nonatomic) IBOutlet UITableView *tblNotes;
@property (strong, nonatomic) NSString *senderIDFornote;
@property (strong, nonatomic) NSString *username;
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *txtHeadertext;
@property (strong, nonatomic) NSMutableArray *heightArrayComment;

- (IBAction)btnPersonTabAction:(id)sender;
- (IBAction)btnSendTabAction:(id)sender;
- (IBAction)btnReceiveTabAction:(id)sender;
- (IBAction)btnSettingAction:(id)sender;
- (IBAction)btnFavoriteTabAction:(id)sender;

@end
