//
//  TagSelectionView.m
//  Tapt
//
//  Created by TriState  on 7/22/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "TagSelectionView.h"

@implementation TagSelectionView
@synthesize delegate;
-(void)awakeFromNib{
    
    arrTag=[NSMutableArray array];
    arrSelectedTag=[[NSMutableArray alloc]init];
    
    self.btnSearch.layer.cornerRadius=self.btnSearch.frame.size.height/2;
    self.btnSearch.layer.masksToBounds=YES;
    self.btnSearch.layer.borderWidth = 1;
    self.btnSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ViewForSearchTag.layer.cornerRadius=5;
    
    NSString *QueryTag = @"select * from Tag";
    arrTag=[Database executeQuery:QueryTag];
   // [self setTagsView];
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self layoutIfNeeded];
    [self setTagsView];
}

- (IBAction)btnSearchAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(btnTagSearchAction:)]) {
        [self.delegate btnTagSearchAction:arrSelectedTag];
    }

}

-(void)setTagsView
{
    
    for (UIButton *btn in self.ViewForSearchTag.subviews) {
        [btn removeFromSuperview];
    }
    
    int x = 2;
    int y = 3;
    
    
    CGRect frame =  self.ViewForSearchTag.frame;
    for (int i = 0; i < arrTag.count; i++) {
        
        NSDictionary *dictTags = [arrTag objectAtIndex:i];
        btnTags= [[UIButton alloc]init];
        btnTags.userInteractionEnabled = true;
        btnTags.tag = i;
        
        btnTags.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
        [btnTags setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [btnTags setTitle:[[arrTag valueForKey:@"tag_name"] objectAtIndex:i] forState:UIControlStateNormal]; //[[arrTags valueForKey:@"tag_name"] objectAtIndex:i]
        [btnTags sizeToFit];
        [btnTags addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        btnTags.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btnTags.layer.borderWidth = 1;
        btnTags.layer.cornerRadius = 7;
        btnTags.layer.masksToBounds = true;
        btnTags.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        CGRect btnframe = btnTags.frame;
        float tempX = x + btnTags.frame.size.width;
        if (tempX > self.ViewForSearchTag.frame.size.width-10) {
            x = 2;
            y = y + 32;
        }
        else{
            
        }
        btnframe.origin.x = x;
        btnframe.origin.y = y;
        btnframe.size.height = 28;
        btnTags.frame = btnframe;
        [self.ViewForSearchTag addSubview:btnTags];
        x = x+btnTags.frame.size.width+3 ;
        frame.size.height = y+31;
    }
    //self.viewTags.frame = frame;
    self.tagViewHeight.constant=frame.size.height;
    self.scrlTagView.contentSize = CGSizeMake(frame.size.width, frame.size.height+20);
}
#pragma mark - select particular tag action
-(void)btnTagAction:(UIButton *)sender
{

    UIButton *btnTag =(UIButton*)sender;
       if(![sender isSelected])
    {
        [sender setSelected:YES];
        //btnTag.layer.borderWidth = 1;
        //btnTag.layer.borderColor = [UIColor blackColor].CGColor;
        [btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [arrSelectedTag addObject:[arrTag objectAtIndex:btnTag.tag]];

    }
    else
    {
        [sender setSelected:NO];
        // btnTag.layer.borderWidth=0;
        [btnTag setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [arrSelectedTag removeObject:[arrTag objectAtIndex:btnTag.tag]];
        
    }
    
}


@end
