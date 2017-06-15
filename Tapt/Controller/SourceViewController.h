//
//  SourceViewController.h
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/10/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContactViewController.h"
#import "ContactDetailViewController.h"
#import "DestinationViewController.h"
#import "ContactFooterReusableView.h"
#import "TagSerchProtocolFIle.h"



@protocol SourceViewDelegate<NSObject>
-(void)tagClickForSearchAction:(int)buttontag;
@end


@interface SourceViewController : LazyImageViewControllerCollectionView
{
    ContactFooterReusableView *footerview;
    UIButton *btnTags;
   // id<SourceViewDelegate>mydelegate;
}
@property (nonatomic,assign)id<SourceViewDelegate>mydelegate;

@property(strong, nonatomic)NSMutableArray *arrContacts;
@property(strong, nonatomic)NSMutableArray *arrtags;

- (instancetype)initWithCollectionView:(UICollectionView *)view
               andParentViewController:(ContactViewController *)parent;

- (void)cellDragCompleteWithModel:(MyModel *)model
               withValidDropPoint:(BOOL)validDropPoint;

- (void)setUpModels:(NSMutableArray *)arr;

@end
