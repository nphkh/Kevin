//
//  ContactCVCell.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ContactCVCell.h"
#import "Constants.h"
#import "CardView.h"
@implementation ContactCVCell
{
    CardView *_cardView;
}

- (void)loadImage:(UIImage*)image{
    
    [self.indicator stopAnimating];
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.3];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    if(image)
        self.imgContact.image = image;
    else
        self.imgContact.image =[UIImage imageNamed:IMAGE_PLACEHOLDER];
    
    [[self.imgContact layer] addAnimation:animation forKey:@"FadeAnimation"];
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cardView = [[CardView alloc] init];
        [self.contentView addSubview:_cardView];
    }
    return self;
}

- (void)setModel:(MyModel *)model {
    _model = model;
    _cardView.label.text = [NSString stringWithFormat:@"%d", _model.value];
    
}

#pragma mark - Overriden methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _cardView.frame = self.bounds;
}

@end
