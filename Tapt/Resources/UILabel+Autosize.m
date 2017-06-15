//
//  UILabel+Autosize.m
//  Spoon It Forward 
//
//  Created by Bharat Aghera on 04/07/14.
//  Copyright (c) 2014 Tristate. All rights reserved.
//

#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)

- (void) autosizeForHeight: (int) Height{
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 1;
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, Height);
    CGSize expectedLabelSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:self.lineBreakMode];
    CGRect newFrame = self.frame;
    newFrame.size.width = expectedLabelSize.width;
    self.frame = newFrame;
}


- (void) autosizeWidth: (int) width1 {
    CGFloat width =  [self.text sizeWithFont:self.font forWidth:width1 lineBreakMode:NSLineBreakByWordWrapping].width;
    CGRect frameProPhoto=self.frame;
    frameProPhoto.size.width=width+8;
    self.frame=frameProPhoto;
}

@end