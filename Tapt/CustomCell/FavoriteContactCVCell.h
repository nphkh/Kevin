//
//  FavoriteContactCVCell.h
//  Tapt
//
//  Created by TriState  on 7/17/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteContactCVCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblNameSurname;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
