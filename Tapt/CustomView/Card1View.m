//
//  Card1View.m
//  Tapt
//
//  Created by Parth on 28/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "Card1View.h"

@implementation Card1View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnFacebookAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnFacebook)]) {
        [self.delegate btnFacebook];
    }
}

- (IBAction)btnTwitterAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnTwitter)]) {
        [self.delegate btnTwitter];
    }
}

- (IBAction)btnLinkedInAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnLinkedIn)]) {
        [self.delegate btnLinkedIn];
    }
}

- (IBAction)btnSkypeAction:(id)sender {
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
