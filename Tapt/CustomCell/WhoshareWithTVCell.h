//
//  WhoshareWithTVCell.h
//  Tapt
//
//  Created by TriState  on 7/14/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhoSharewithdelegate
-(void)btnRemoveSharefeildAction:obj;
-(void)switchDeleteContactValuechange:obj;
@end

@interface WhoshareWithTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblShareFeild;

//first cell
- (IBAction)btnRemoveSharefeildAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveSharefeild;
//second cell
@property (strong, nonatomic) IBOutlet UILabel *lblRemoveContact;



//third cell
- (IBAction)switchDeleteContactValuechange:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *switchDeleteContact;


@property(weak,nonatomic) id delegate;
@end
