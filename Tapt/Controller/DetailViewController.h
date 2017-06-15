//
//  DetailViewController.h
//  Tapt
//
//  Created by Parth on 28/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "UIView+NIB.h"
#import "Card1View.h"
#import "Card2View.h"
#import "Card3View.h"
#import "Card4View.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface DetailViewController : BaseViewContoller<UITableViewDelegate,UITableViewDataSource,Card1CustomDlegate,Card2CustomDlegate,Card3CustomDlegate,Card4CustomDlegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UIView *viewTableViewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;

@property (strong,nonatomic) NSMutableDictionary *dictContact;
@property (strong,nonatomic) NSMutableArray *arrKeys;
@property (strong,nonatomic) NSMutableArray *arrTemp;
@property (strong,nonatomic) NSMutableArray *arrKeysForView;
@property (strong, nonatomic) NSMutableDictionary *dictData;
- (IBAction)btnBackAction:(id)sender;

@end
