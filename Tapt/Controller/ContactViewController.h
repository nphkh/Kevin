//
//  ContactViewController.h
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyImageViewControllerCollectionView.h"
#import "ContactViewController.h"
#import "MyModel.h"
#import "AppDelegate.h"
#import "DestinationViewController.h"
#import "categoryCVCell.h"
#import "SettingMenuView.h"
#import "FavoriteContectViewController.h"
#import "ReceiveTagViewController.h"
#import "TagSelectionView.h"

@interface ContactViewController : LazyImageViewControllerCollectionView<UITextFieldDelegate,TagSelectionViewDelegate>
{
    NSMutableArray *arrUserDetail;
    NSMutableArray *arrCategoryContacts;
    NSArray *arrtotalContact;
    int categoryindex;
    UIView  *settingView;
    int flagMenuopen;
    NSMutableArray *_models;

    NSMutableArray *arrSearchContact;
    NSMutableArray *arrTag;
    NSMutableArray *arrSearchTag;
    
    UIButton *btnTags;
    TagSelectionView *TagSelect;
    int isTagButtonSearch;
    int flagCateGorydata;
    
   
    int CountForTagSearch;
}
- (IBAction)btnTopLogoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnTopLogo;

@property(strong,nonatomic) NSMutableDictionary *dictContactResponse;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property(strong,nonatomic)NSArray *arrImages;
@property(strong, nonatomic)NSMutableArray *arrContacts;
@property(strong,nonatomic) NSMutableArray *arrCategory;

@property (nonatomic, weak) IBOutlet UICollectionView *cvContact;

//30-Jun-15
- (IBAction)btnPersonTabAction:(id)sender;
- (IBAction)btnSendTabAction:(id)sender;
- (IBAction)btnReceiveTabAction:(id)sender;
- (IBAction)btnSettingAction:(id)sender;
- (IBAction)btnFavoriteTabAction:(id)sender;
- (IBAction)btnCategoryAction:(id)sender;

- (void)setSelectedModel:(MyModel *)model atPoint:(CGPoint)point;

@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UICollectionView *categoryCollectionView;

//search
- (IBAction)btnSearchAction:(id)sender;
- (IBAction)btnTagAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *ScrlViewSearch;
@property (strong, nonatomic) IBOutlet UIView *ContentViewSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIView *viewSearchTag;
@property (strong, nonatomic) IBOutlet UIButton *btnTag;


@property (strong, nonatomic) IBOutlet UIView *moreOptionView;
- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnMoreAction:(id)sender;
- (IBAction)btnByNameListAction:(id)sender;
- (IBAction)btnBySurNameListAction:(id)sender;
- (IBAction)btnTilesDisplayAction:(id)sender;
- (IBAction)btnListDisplayAction:(id)sender;

@property (nonatomic,assign)BOOL isfromSearch;
@end
