//
//  ContactCVCell.h
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

@interface ContactCVCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgContact;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSurname;

@property (nonatomic, strong) MyModel *model;


//cell use for eventcontact list

@end
