//
//  AskPermissionTVCell.m
//  Tapt
//
//  Created by Parth on 18/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "AskPermissionTVCell.h"

@implementation AskPermissionTVCell

@synthesize btnColor,btnClick;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClickToChangeAction:(id)sender {
    
    UIButton *btn=(UIButton * )sender;
    
    if (btn.selected) {
//        [btnColor setBackgroundColor:[UIColor yellowColor]];
        btn.selected=NO;
        btnColor.selected=NO;
        [self.delegate sharePermissionChage:btn.tag select:btn.selected];
    }
    else
    {
//        [btnColor setBackgroundColor:[UIColor greenColor]];
        btn.selected=YES;
        btnColor.selected=YES;
        [self.delegate sharePermissionChage:btn.tag select:btn.selected];
    }
}


@end
