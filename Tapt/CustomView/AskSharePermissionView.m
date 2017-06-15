//
//  CustomDetailMapView.m
//  mPhletDesign
//
//  Created by Parth on 09/02/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "AskSharePermissionView.h"
#import "AskPermissionTVCell.h"
#import "UITableViewCell+NIB.h"


@implementation AskSharePermissionView
@synthesize arrFieldName,arrFieldNameSort,arrUDName;
@synthesize dictShare;
@synthesize tblViewField;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [self.tblViewField registerNib:[UINib nibWithNibName:@"cellField" bundle:nil] forCellReuseIdentifier:@"cellField"];
    tblViewField.backgroundColor=[UIColor clearColor];
    userDefault=[NSUserDefaults standardUserDefaults];
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
//    self.viewSubDialoge.layer.borderWidth=1.0f;
//    self.viewSubDialoge.layer.borderColor=[[UIColor blackColor] CGColor];
//    self.viewSubDialoge.layer.cornerRadius=10.0f;
//    self.viewSubDialoge.layer.masksToBounds=YES;
}


-(void) showInView:(UIView *) superView
{
    
    self.alpha=1.0f;
    self.center=superView.center;
    self.userInteractionEnabled = YES;
    [superView addSubview:self];
    
    self.viewSubDialoge.transform=CGAffineTransformMakeScale(0.0f, 0.0f);
    [UIView animateWithDuration:0.3f animations:^{
        self.viewSubDialoge.transform=CGAffineTransformMakeScale(1.1f, 1.1f);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f animations:^{
            self.viewSubDialoge.transform=CGAffineTransformMakeScale(0.9f, 0.9f);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.viewSubDialoge.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }];
    }];
}



- (IBAction)btnHideAction:(id)sender
{
    [self hideView];
}

-(void) hideView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha=0.0f;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // NSLog(@"touchesBegan:withEvent:");
    [self.superview endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - UITableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int cnt=0;
    
    arrFieldNameSort=[[NSMutableArray alloc]init];
    
    for (NSString *key in arrUDName) {
        if([[userDefault objectForKey:key] isEqualToString:@"2"])
        {
            cnt++;
            [arrFieldNameSort addObject:[arrFieldName objectAtIndex:[arrUDName indexOfObject:key]]];
          
        }
    }
    
    return cnt;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskPermissionTVCell *cell =[AskPermissionTVCell dequeOrCreateInTable:self.tblViewField];

    cell.backgroundColor=[UIColor clearColor];
    cell.delegate=self;
    cell.lblField.text= [arrFieldNameSort objectAtIndex:indexPath.row] ;
    cell.btnClick.tag=indexPath.row;
    return cell;
}



- (IBAction)btnOkAction:(id)sender {
    
    [self.delegate sharePermissionChage:dictShare];
    [self hideView];
}

- (IBAction)btnCancelAction:(id)sender {
    [self hideView];
}


#pragma mark - CustomDelegatShareCell

-(void)sharePermissionChage:(NSInteger)intIndex select:(BOOL)selected{
    
    if (selected) {
        [dictShare setObject:@"1" forKey:[arrUDName objectAtIndex:[arrFieldName indexOfObject:[arrFieldNameSort objectAtIndex:intIndex]]]];
    }
    else
    {
        [dictShare setObject:@"2" forKey:[arrUDName objectAtIndex:[arrFieldName indexOfObject:[arrFieldNameSort objectAtIndex:intIndex]]]];
    }
    
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
