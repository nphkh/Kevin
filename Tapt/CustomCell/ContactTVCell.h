//
//  ContactTVCell.h
//  Tapt
//
//  Created by Parth on 02/06/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgContact;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSurname;

@end
