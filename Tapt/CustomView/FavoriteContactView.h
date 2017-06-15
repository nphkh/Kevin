//
//  FavoriteContactView.h
//  Tapt
//
//  Created by TriState  on 8/3/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyImageViewControllerCollectionView.h"
#import "FavoriteContactCVCell.h"
#import "ContactDetailViewController.h"
@interface FavoriteContactView :UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
     NSMutableArray *arrFavoriteContact;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collVIewFavoriteContect;
@end
