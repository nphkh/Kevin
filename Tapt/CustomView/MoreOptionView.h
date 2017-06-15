//
//  MoreOption.h
//  Tapt
//
//  Created by Parth on 01/06/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDelegatSorting <NSObject>

@required

-(void)sortByName;
-(void)sortBySurName;

@end

@interface MoreOptionView : UIView

@property (strong,nonatomic) id<CustomDelegatSorting>delegate;
- (IBAction)btnByNameAction:(id)sender;

- (IBAction)btnBySurNameAction:(id)sender;

@end
