//
//  TagSelectionView.h
//  Tapt
//
//  Created by TriState  on 7/22/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"
#import "Database.h"

@protocol TagSelectionViewDelegate <NSObject>
-(void)btnTagSearchAction:(NSMutableArray *)selectedtagarray;
@end

@interface TagSelectionView : UIView
{
    NSMutableArray *arrTag;
    NSMutableArray *arrSelectedTag;
    UIButton *btnTags;
}

@property (strong,nonatomic) id<TagSelectionViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlTagView;
@property (strong, nonatomic) IBOutlet UIView *ViewForSearchTag;
- (IBAction)btnSearchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;

@end
