//
//  MoreOption.m
//  Tapt
//
//  Created by Parth on 01/06/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "MoreOptionView.h"

@implementation MoreOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
}


- (IBAction)btnByNameAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(sortByName)]) {
        [self.delegate sortByName];
    }
    
}

- (IBAction)btnBySurNameAction:(id)sender {

    if ([self.delegate respondsToSelector:@selector(sortBySurName)]) {
        [self.delegate sortByName];
    }
    
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
