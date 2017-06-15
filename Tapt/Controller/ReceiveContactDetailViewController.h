//
//  ReceiveContactDetailViewController.h
//  Tapt
//
//  Created by Parth on 25/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"

@interface ReceiveContactDetailViewController : BaseViewContoller

@property (strong, nonatomic) NSDictionary *dictContact;

@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserPhoto;

- (IBAction)btnOkAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;
@end
