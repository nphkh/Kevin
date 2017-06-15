//
//  WhoShareWithViewController.h
//  Tapt
//
//  Created by TriState  on 7/13/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyImageViewControllerCollectionView.h"
#import "EventContectListCVCell.h"
#import "WhoSharedWithDetailViewController.h"
#import "SettingMenuView.h"
@interface WhoShareWithViewController : LazyImageViewControllerCollectionView<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrUserDetail;

    NSMutableArray *arrWhoShareWithContact;
   
    UIView  *settingView;
    int flagMenuopen;
}
@property (strong, nonatomic) IBOutlet UILabel *lblWhoisharewith;
- (IBAction)btnBackAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblWhoISharedWith;

//@property (strong, nonatomic) IBOutlet UICollectionView *collectionWhoISharewith;

@end
