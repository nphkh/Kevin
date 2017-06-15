//
//  FavoriteContectViewController.h
//  Tapt
//
//  Created by TriState  on 7/17/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyImageViewControllerCollectionView.h"
#import "FavoriteContactCVCell.h"
#import "ContactDetailViewController.h"
#import "Database.h"
#import "SettingMenuView.h"
@interface FavoriteContectViewController : LazyImageViewControllerCollectionView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *arrFavoriteContact;
     NSMutableArray *arrUserDetail;
    int flagMenuopen;
    UIView  *settingView;
}
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collVIewFavoriteContect;
- (IBAction)btnPersonTabAction:(id)sender;
- (IBAction)btnSendTabAction:(id)sender;
- (IBAction)btnReceiveTabAction:(id)sender;
- (IBAction)btnSettingAction:(id)sender;
- (IBAction)btnFavoriteTabAction:(id)sender;


@end
