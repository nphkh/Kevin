//
//  UILabel+Autosize.h
//  Spoon It Forward 
//
//  Created by Bharat Aghera on 04/07/14.
//  Copyright (c) 2014 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel (AutoSize)

- (void) autosizeForHeight: (int) Height;
- (void) autosizeWidth: (int) width;
@end