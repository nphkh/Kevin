//
//  NotesTVCell.m
//  Tapt
//
//  Created by TriState  on 7/4/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "NotesTVCell.h"

@implementation NotesTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnAddNoteAction:(id)sender {
    
    self.btnAddNotes.selected=!self.btnAddNotes.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(btnAddNoteAction:)]) {
        [self.delegate btnAddNoteAction:self];
    }
    
}
- (IBAction)btnRemoveNoteAction:(id)sender {
    self.btnRemoveNote.selected=!self.btnRemoveNote.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(btnRemoveNoteAction:)]) {
        [self.delegate btnRemoveNoteAction:self];
    }
}
@end
