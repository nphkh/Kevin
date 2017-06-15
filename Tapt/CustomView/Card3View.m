//
//  Card3View.m
//  Tapt
//
//  Created by Parth on 29/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "Card3View.h"

@implementation Card3View

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

@end
