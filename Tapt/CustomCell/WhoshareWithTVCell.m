//
//  WhoshareWithTVCell.m
//  Tapt
//
//  Created by TriState  on 7/14/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "WhoshareWithTVCell.h"

@implementation WhoshareWithTVCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (IBAction)btnRemoveSharefeildAction:(id)sender {
    
    self.btnRemoveSharefeild.selected=!self.btnRemoveSharefeild.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(btnRemoveSharefeildAction:)]) {
        [self.delegate btnRemoveSharefeildAction:self];
    }
}
- (IBAction)switchDeleteContactValuechange:(id)sender {
    
    self.switchDeleteContact.selected=!self.switchDeleteContact.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(switchDeleteContactValuechange:)]) {
        [self.delegate switchDeleteContactValuechange:self];
    }
}
@end
