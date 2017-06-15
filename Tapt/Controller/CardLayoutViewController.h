//
//  CardLayoutViewController.h
//  Tapt
//
//  Created by Parth on 18/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "LayoutPreviewViewController.h"
#import "CardPreviewView.h"
#import "ContactViewController.h"

@interface CardLayoutViewController : BaseViewContoller<UICollectionViewDelegate, UICollectionViewDataSource, customLayoutDelegate,UIAlertViewDelegate,customDelegatePreview>
{
   // NSMutableArray *arrUserDetail;
}

@property (nonatomic,assign) NSInteger intIndex;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)btnDoneAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackAction:(id)sender;

@end
