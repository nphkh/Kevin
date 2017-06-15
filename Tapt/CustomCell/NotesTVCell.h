//
//  NotesTVCell.h
//  Tapt
//
//  Created by TriState  on 7/4/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Notecelldelegate
-(void)btnAddNoteAction:obj;
-(void)btnRemoveNoteAction:obj;
@end

@interface NotesTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *txtAddNotes;
@property (strong, nonatomic) IBOutlet UIView *viewNotecell;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNotes;
@property (strong, nonatomic) IBOutlet UIView *viewGetNotecell;

- (IBAction)btnAddNoteAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblNotes;



- (IBAction)btnRemoveNoteAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnRemoveNote;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblSharedFeiled;




@property(weak,nonatomic) id delegate;
@end
