//
//  DestinationViewController.h
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/13/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyModel.h"
#import "ContactViewController.h"
#import "Database.h"
#import "UILabel+Autosize.h"

@protocol categorydestinationdelegate
-(void)categoryAction:(NSIndexPath *)indexPath;
-(void)hideCategoryButtonAction;
@end

@interface DestinationViewController : BaseViewContoller
{
    UILabel *lblData;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
- (void)addModel:(MyModel *)model;
@property(weak,nonatomic) id delegate;
@end
