//
//  CardView.h
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/9/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imgUser;
@property (nonatomic, strong) UILabel *name;

- (void)setHighlightSelection:(BOOL)highlight;

@end
