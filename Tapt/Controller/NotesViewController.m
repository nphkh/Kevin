//
//  NotesViewController.m
//  Tapt
//
//  Created by TriState  on 7/4/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize senderIDFornote;
- (void)viewDidLoad {

    [appDelegate setShouldRotate:NO];
    [super viewDidLoad];
    arrNotesdetail=[[NSMutableArray alloc]init];
    self.txtHeadertext.text=self.username;
    //tap gesture
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapOutSide:)];
    [tapOutside setDelegate:self];
    [self.tblNotes addGestureRecognizer:tapOutside];
    
    [self callWebserviceForGetNotes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark -tapgesture method
- (void)TapOutSide:(UITapGestureRecognizer *)gestureRecognizer;
{
    NSLog(@"tap");
    
}
#pragma mark - tableview datasource delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // return [arrNotesdetail count];
    return arrNotesdetail.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
   if (indexPath.row==0) {
        NotesTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AddNotesCell"];
       cell.delegate=self;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.viewNotecell.layer.cornerRadius=5;
       cell.txtAddNotes.text=@"";
       return cell;
    }
    else
    {
        NotesTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GetNotesCell"];
        
        cell.lblNotes.text=[[arrNotesdetail valueForKey:@"note"]objectAtIndex:indexPath.row-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate=self;
        cell.tag=indexPath.row-1;
        
        //set lable height for dynamic height
        NSDictionary *heightDict=[self.heightArrayComment objectAtIndex:indexPath.row-1];
        CGFloat nameHeight=[[heightDict objectForKey:@"name"] floatValue];
        cell.lblNotes.frame=CGRectMake(33, 8, cell.lblNotes.frame.size.width,nameHeight);
        
        //for date
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[arrNotesdetail valueForKey:@"created"]objectAtIndex:indexPath.row-1]doubleValue]];
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm a,ddMMMyyyy"];
         NSString *dateString = [dateFormatter stringFromDate:date];
         cell.lblDate.text=dateString;
        
          return cell;
    }
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 58;
    }
    else
    {
            NSDictionary *dict=[self.heightArrayComment objectAtIndex:indexPath.row-1];
            CGFloat height=[[dict objectForKey:@"total"] floatValue];
            return height;
    }
}

#pragma mark- calculate dynamic height of cell
-(void)calculateHeightComment
{
    self.heightArrayComment=[NSMutableArray array];
    
    for (NSMutableDictionary *dict in arrNotesdetail)
    {
        NSString *strName=SAFESTRING([dict  objectForKey:@"note"]);
    
        CGFloat lblNameHeight=[strName textHeightForFont:[UIFont systemFontOfSize:16.0] withMaxWidth:self.tblNotes.frame.size.width-95];
       
        
        CGFloat totalHeight=lblNameHeight+45;
        NSMutableDictionary *heightDict=[NSMutableDictionary dictionary];
        [heightDict setObject:[NSString stringWithFormat:@"%f",lblNameHeight] forKey:@"name"];
        
        [heightDict setObject:[NSString stringWithFormat:@"%f",totalHeight] forKey:@"total"];
        
        [self.heightArrayComment addObject:heightDict];
    }

}

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
{
    return 58.0;
}


- (CGFloat)heightForBasicCellWithIndexPath:(NSIndexPath *) indexPath
{
    static NotesTVCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    cell=[self.tblNotes dequeueReusableCellWithIdentifier:@"GetNotesCell"];
   
    });
    
    [self configureCell:cell andIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:cell];
}


- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    if(IS_IOS_8)
    {
         return UITableViewAutomaticDimension;
    }
    
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


-(void) configureCell:(NotesTVCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    
       cell.lblNotes.text=[[arrNotesdetail valueForKey:@"note"]objectAtIndex:indexPath.row-1];
        CGRect rectLbl=cell.lblNotes.frame;
        rectLbl.size.width=50;
        cell.lblNotes.frame=rectLbl;
        [self.tblNotes layoutIfNeeded];
} */


#pragma mark - calling Webservices
-(void)callWebserviceForGetNotes
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateNotes" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"get" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:senderIDFornote forKey:@"senderId"];
        
       // [dict setObject:@"2" forKey:@"receiverId"];
       // [dict setObject:@"77" forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
              if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
              {
                  [dict removeObjectForKey:@"Count"];
                  [dict removeObjectForKey:@"Response"];
                  dictNoteDetail=[[NSMutableDictionary alloc]initWithDictionary:dict];
                  for (NSString *strkey in dict) {
                      
                      NSMutableDictionary *dictData = [dict objectForKey:strkey];
                      [dictData setObject:[strkey stringByReplacingOccurrencesOfString:@"noteId" withString:@""] forKey:@"noteId"];
                      //                NSMutableArray *temparr=[[NSMutableArray alloc]init];
                      //                [temparr addObject:dictData];
                      //
                      //                NSSortDescriptor *alphaNumSD = [NSSortDescriptor sortDescriptorWithKey:@"created"
                      //                                ascending:YES
                      //                               comparator:^(NSString *string1, NSString *string2)
                      //                {
                      //                    return [string1 compare:string2 options:NSNumericSearch];
                      //                }];
                      //                [arrNotesdetail addObject:[temparr sortedArrayUsingDescriptors:@[alphaNumSD]]];
                      
                      [arrNotesdetail addObject:dictData];
                      
                      
                  }
                  [self calculateHeightComment];
                  NSLog(@"%@",arrNotesdetail);
                  [self.tblNotes reloadData];
                  
              }
          
          
        }
        onFailure:^(NSError *error)
        {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
         }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}

//save notes
-(void)callWebserviceForSaveNotes:(NSString*)noteText
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateNotes" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"save" forKey:@"operation"];
        [dict setObject:noteText forKey:@"note"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:senderIDFornote forKey:@"senderId"];
       // [dict setObject:@"2" forKey:@"receiverId"];
       // [dict setObject:@"77" forKey:@"senderId"];
        
        
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm a,ddMMMyyyy"];
                NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
                NSLog(@"%@",dateString);
                
                NSMutableDictionary *tempdict=[[NSMutableDictionary alloc]init];
                [tempdict setObject:dateString forKey:@"created"];
                [tempdict setObject:noteText forKey:@"note"];
                [tempdict setObject:[dict objectForKey:@"NoteId"] forKey:@"noteId"];
                
                //[arrNotesdetail addObject:tempdict];
                [arrNotesdetail insertObject:tempdict atIndex:0];
                [dictNoteDetail setObject:tempdict forKey:[NSString stringWithFormat:@"noteId%@",[dict objectForKey:@"NoteId"]]];
                [self calculateHeightComment];
                [self.tblNotes reloadData];
 
            }
            else
            {
                [UIAlertView infoAlertWithMessage:[dict objectForKey:@"Response"] andTitle:APP_NAME];
            }
        }
         onFailure:^(NSError *error)
         {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
         }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}
-(void)callWebserviceForRemoveNotes:(NSString*)noteId tag:(int)notetag
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateNotes" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"delete" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:noteId forKey:@"noteId"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:senderIDFornote forKey:@"senderId"];
        
        //[dict setObject:@"2" forKey:@"receiverId"];
        //[dict setObject:@"77" forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
           [self hidHud];
           NSLog(@"dict %@",dict);
           if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
           {
              // if(![[[dict objectForKey:@"Count"]stringValue]isEqualToString:@"0"])
              // {
                   [arrNotesdetail removeObjectAtIndex:notetag];
               [dictNoteDetail removeObjectForKey:[NSString stringWithFormat:@"noteId%@",noteId]];
               [self calculateHeightComment];

                   [self.tblNotes reloadData];
               
               
              // }
               
           }
            
        }
        onFailure:^(NSError *error)
        {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}

#pragma mark - ManageCellDelegates
-(void)btnAddNoteAction:(NotesTVCell *)cell
{
    NSString *strNotetext=[NSString stringWithFormat:@"%@",cell.txtAddNotes.text];
    if([strNotetext length]>0)
    {
       [self callWebserviceForSaveNotes:strNotetext];
    }
    else
    {
       [UIAlertView infoAlertWithMessage:@"Please Enter Note" andTitle:APP_NAME];
    }
    
}
-(void)btnRemoveNoteAction:(NotesTVCell *)cell
{
  //  NSArray *keyArray=[dictNoteDetail allKeys];
    NSDictionary *dictNote = [arrNotesdetail objectAtIndex:cell.tag];
   // NSString *strTemp=[keyArray objectAtIndex:cell.tag];
    NSLog(@"Tag = %ld",cell.tag);
    [self callWebserviceForRemoveNotes:[dictNote objectForKey:@"noteId"] tag:(int)cell.tag];
}
#pragma mark- back action

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-text feild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int length = [currentString length];
    if (length > 80) {
        return NO;
    }
    return YES;
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - tabbutton action
- (IBAction)btnPersonTabAction:(id)sender {
    
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    
    NSString *query =[NSString stringWithFormat:@"select * from tbl_profile where cid='%@'",[userDefault objectForKey:@"ID"]];
    arrUserDetail=[[NSMutableArray alloc]init];
    arrUserDetail=[Database executeQuery:query];
    NSLog(@"%@",arrUserDetail);
    
    UserDetail *userDtl=[UserDetail sharedInstance];
    if(arrUserDetail.count>0)
    {
        userDtl.firstName=[[arrUserDetail valueForKey:@"first_name"]objectAtIndex:0];
        userDtl.lastName=[[arrUserDetail valueForKey:@"last_name"]objectAtIndex:0];
        userDtl.MobileNumber=[[arrUserDetail valueForKey:@"home_mobile_phone"]objectAtIndex:0];
        userDtl.ProfilePhoto=[[arrUserDetail valueForKey:@"image_url"]objectAtIndex:0];
        userDtl.homePhone=[[arrUserDetail valueForKey:@"home_phone"]objectAtIndex:0];
        userDtl.homeEmail=[[arrUserDetail valueForKey:@"home_email"]objectAtIndex:0];
        userDtl.homeAddress=[[arrUserDetail valueForKey:@"home_address1"]objectAtIndex:0];
        userDtl.homeStreet=[[arrUserDetail valueForKey:@"home_suburb"]objectAtIndex:0];
        userDtl.homeCity=[[arrUserDetail valueForKey:@"home_city"]objectAtIndex:0];
        userDtl.homeState=[[arrUserDetail valueForKey:@"home_state"]objectAtIndex:0];
        userDtl.homeCountry=[[arrUserDetail valueForKey:@"home_country"]objectAtIndex:0];
        userDtl.homePostCode=[[arrUserDetail valueForKey:@"home_post_code"]objectAtIndex:0];
        userDtl.companyName=[[arrUserDetail valueForKey:@"company"]objectAtIndex:0];
        userDtl.title=[[arrUserDetail valueForKey:@"title"]objectAtIndex:0];
        userDtl.officePhonenumber=[[arrUserDetail valueForKey:@"work_phone"]objectAtIndex:0];
        userDtl.officeMobilenumber=[[arrUserDetail valueForKey:@"work_mobile_phone"]objectAtIndex:0];
        userDtl.officeEmail=[[arrUserDetail valueForKey:@"work_email"]objectAtIndex:0];
        userDtl.Website=[[arrUserDetail valueForKey:@"website"]objectAtIndex:0];
        userDtl.Logoimg=[[arrUserDetail valueForKey:@"logo_url"]objectAtIndex:0];
        userDtl.officeAddress=[[arrUserDetail valueForKey:@"work_address1"]objectAtIndex:0];
        userDtl.officeStreet=[[arrUserDetail valueForKey:@"work_suburb"]objectAtIndex:0];
        userDtl.officeCity=[[arrUserDetail valueForKey:@"work_city"]objectAtIndex:0];
        userDtl.officeState=[[arrUserDetail valueForKey:@"work_state"]objectAtIndex:0];
        userDtl.officeCountry=[[arrUserDetail valueForKey:@"work_country"]objectAtIndex:0];
        userDtl.officePostCode=[[arrUserDetail valueForKey:@"work_post_code"]objectAtIndex:0];
        userDtl.cardlayout=[[arrUserDetail valueForKey:@"layout"]objectAtIndex:0];
        userDtl.facebook=[[arrUserDetail valueForKey:@"facebook"]objectAtIndex:0];
        userDtl.twitter=[[arrUserDetail valueForKey:@"twitter"]objectAtIndex:0];
        userDtl.linkedin=[[arrUserDetail valueForKey:@"linkedIn"]objectAtIndex:0];
        userDtl.skype=[[arrUserDetail valueForKey:@"skype"]objectAtIndex:0];
    }
    
    ProfileTabbarViewController *vcProfiletab=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTabbarViewController"];
    [self.navigationController pushViewController:vcProfiletab animated:YES];
    
}

- (IBAction)btnSendTabAction:(id)sender {
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    SendContactViewController *vcsend=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactViewController"];
    [self.navigationController pushViewController:vcsend animated:YES];
    
    
}

- (IBAction)btnReceiveTabAction:(id)sender {
    [userDefault setObject:@"1" forKey:@"isFromContact"];
    ReceiveContactFirstViewController *vcReceive=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveContactFirstViewController"];
    [self.navigationController pushViewController:vcReceive animated:YES];
    
}

- (IBAction)btnSettingAction:(id)sender {
    
    if (flagMenuopen==1) {
        flagMenuopen=0;
        [UIView animateWithDuration:1.0 animations:^{
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
        }];
        
    }
    else{
        if (settingView==nil) {
            settingView = [UIView loadView:@"SettingMenu"];
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
            settingView.layer.borderWidth=1.0;
            settingView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.view addSubview:settingView];
        }
        flagMenuopen=1;
        [UIView animateWithDuration:1.0 animations:^{
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height-(settingView.frame.size.height+55), settingView.frame.size.width, settingView.frame.size.height);
        }];
        settingView.hidden=false;
    }
 }

- (IBAction)btnFavoriteTabAction:(id)sender {
    
}*/
@end
