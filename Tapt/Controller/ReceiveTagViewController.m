//
//  ReceiveTagViewController.m
//  Tapt
//
//  Created by TriState  on 7/2/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ReceiveTagViewController.h"

@interface ReceiveTagViewController ()

@end

@implementation ReceiveTagViewController
@synthesize senderIDForTag;
- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
   
    
    arrTags=[[NSMutableArray alloc]init];
    arrSelectedTags=[[NSMutableArray alloc]init];
    self.scrlView.contentSize=self.contentView.frame.size;
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
  
    self.viewAddTag.layer.cornerRadius=6;
    self.viewTags.layer.cornerRadius=5;
    
    self.btnSearch.layer.cornerRadius=self.btnSearch.frame.size.height/2;
    self.btnSearch.layer.masksToBounds=YES;
    self.btnSearch.layer.borderWidth = 1;
    self.btnSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSearch.hidden=YES;

  
    //[self callWebserviceForGetTags];
   
    //if([[userDefault objectForKey:@"isFromcontactdetail"]isEqualToString:@"0"])
   // {
    
    
        NSString *SelectQuery=[NSString stringWithFormat:@"select * from Tag"];
        arrTags=[Database executeQuery:SelectQuery];
    
    
    if([[userDefault objectForKey:@"isFromcontactdetail"]isEqualToString:@"1"])
    {
        NSString *selectQ=[NSString stringWithFormat:@"select * from Tag_Contact_relation where contact_id='%@'",senderIDForTag];
        arrSelectedTags=[Database executeQuery:selectQ];
        NSLog(@"%@",arrSelectedTags);
        NSLog(@"%@",arrTags);
        
    }
    
    
  
        
        
  //  }
  /*  else if([[userDefault objectForKey:@"isFromcontactdetail"]isEqualToString:@"1"])
    {
        NSString *SelectQuery=[NSString stringWithFormat:@"select * from Tag"];
        arrTags=[Database executeQuery:SelectQuery];
        [self setTagsView];
        
        
        NSString *selectQ=[NSString stringWithFormat:@"select * from Tag_Contact_relation where contact_id='%@'",senderIDForTag];
        
        
        NSArray *tmparray=[Database executeQuery:selectQ];
         NSLog(@"%@",tmparray);
        
         for(int i=0;i<[tmparray count];i++)
         {
            NSInteger index=[arrTags indexOfObject:[[tmparray valueForKey:@"tag_id"]objectAtIndex:i]];
            NSLog(@"%ld",(long)index);
         }
        
        [self setTagsView];
    }*/
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
     [self setTagsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)btnAddtagAction:(id)sender {
   
    
    NSString *strTagtext=[NSString stringWithFormat:@"%@",self.txtAddTag.text];
    if([strTagtext length]>0)
    {
        //[arrTags addObject:strTagtext];
        [self callWebserviceForAddTags];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"Please Enter TagName" andTitle:APP_NAME];
    }
}

#pragma mark - call webservices
-(void)callWebserviceForGetTags
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateTags" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"get" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        //[dict setObject:@"77" forKey:@"receiverId"];
       
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
         [self hidHud];
          NSLog(@"dict %@",dict);
            if(![[[dict objectForKey:@"Count"]stringValue] isEqualToString:@"0"])
            {
                [dict removeObjectForKey:@"Count"];
                [dict removeObjectForKey:@"Response"];
                dictTag=[[NSMutableDictionary alloc]initWithDictionary:dict];
              
                for (NSString *strkey in dict) {
                    
                    NSDictionary *dictData = [dict objectForKey:strkey];
                    [arrTags addObject:dictData];
                    
                    
                    NSString *query= [NSString stringWithFormat:@"delete from Tag"];
                    NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
                    
                    
                    NSString *insertQuery=[NSString stringWithFormat:@"insert into Tag (tag_id,tag_name)values ('%@','%@')",[strkey stringByReplacingOccurrencesOfString:@"tag" withString:@""],[dict objectForKey:strkey]];
                    if([Database executeScalerQuery:insertQuery])
                    {
                        NSLog(@"Data Inserted!");
                    }
                    else
                    {
                        
                    }
                }
                NSLog(@"%@",arrTags);
                [self setTagsView];
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
-(void)callWebserviceForAddTags
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateTags" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"add" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[NSString stringWithFormat:@"%@",self.txtAddTag.text] forKey:@"tagName"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        //[dict setObject:@"77" forKey:@"receiverId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"dict %@",dict);
            if([[dict objectForKey:@"Response"] isEqualToString:@"Ok"])
            {
                
                //storing in to database
                NSString *insertQuery=[NSString stringWithFormat:@"insert into Tag (tag_id,tag_name)values ('%@','%@')",[dict objectForKey:@"tagId"],[NSString stringWithFormat:@"%@",self.txtAddTag.text]];
                if([Database executeScalerQuery:insertQuery])
                {
                    NSLog(@"Data Inserted!");
                }
                else
                {
                    
                }
                
                //storing in to array
                NSLog(@"%@",self.txtAddTag.text);
                NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]init];
                [tempDict setObject:[dict objectForKey:@"tagId"] forKey:@"tag_id"];
                [tempDict setObject:[NSString stringWithFormat:@"%@",self.txtAddTag.text] forKey:@"tag_name"];
                [arrTags addObject:tempDict];
               
                //calling webservice method
                [self setTagsView];
                self.txtAddTag.text=@"";

            }
            else
            {
                
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
-(void)callWebserviceForDeleteTags:(NSString*)strtagId
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateTags" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"delete" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:@"" forKey:@"tagId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"dict %@",dict);
            if([[dict objectForKey:@"Response"] isEqualToString:@"Ok"])
            {
                [self setTagsView];
            }
            else
            {
                
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

-(void)callWebserviceForputTags:(NSString*)strtagId
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateTags" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"put" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:strtagId forKey:@"tagId"];
    
        if(senderIDForTag)
        {
           [dict setObject:senderIDForTag forKey:@"senderId"];
        }
        //[dict setObject:@"77" forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"dict %@",dict);
            if([[dict objectForKey:@"Response"] isEqualToString:@"Ok"])
            {
                NSString *insertQuery=[NSString stringWithFormat:@"insert into Tag_Contact_relation (tag_id,contact_id)values ('%@','%@')",strtagId,senderIDForTag];
                if([Database executeScalerQuery:insertQuery])
                {
                    NSLog(@"Data inserted!");
                }
                else
                {
                    
                }
               // [self setTagsView];

            }
            else
            {
                
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
-(void)callWebserviceForremoveTags:(NSString*)strtagId
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateTags" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"remove" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:strtagId forKey:@"tagId"];
        [dict setObject:senderIDForTag forKey:@"senderId"];
        //[dict setObject:@"77" forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"dict %@",dict);
            if([[dict objectForKey:@"Response"] isEqualToString:@"Ok"])
            {
                
                NSString *query =[NSString stringWithFormat:@"delete from  Tag_Contact_relation where tag_id='%@'",strtagId];
               
                NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
                
                [self setTagsView];
            }
            else
            {
                
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
-(void)btnTagAction:(UIButton *)sender
{
    UIButton *btnTag =(UIButton*)sender;
   
    //NSArray *arrtemp=[dictTag allKeys];
    if(![btnTag isSelected])
    {
        btnTag.selected=YES;
        [btnTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // btnTag.layer.borderWidth = 1;
       // btnTag.layer.borderColor = [UIColor blackColor].CGColor;
      
     
        NSLog(@"%@",arrSelectedTags);
         if([[userDefault objectForKey:@"isFromcontactdetail"]isEqualToString:@"1"])
         {
            NSMutableDictionary *dicttemp=[[NSMutableDictionary alloc]init];
            [dicttemp setObject:senderIDForTag forKey:@"contact_id"];
            [dicttemp setObject:[[arrTags valueForKey:@"tag_id"]objectAtIndex:btnTag.tag] forKey:@"tag_id"];
            [arrSelectedTags addObject:dicttemp];
         }
         NSLog(@"%@",arrSelectedTags);
           //for directly calling webservice
           //        NSString *strTemp=[arrtemp objectAtIndex:btnTag.tag];
           //        [self callWebserviceForputTags:[strTemp stringByReplacingOccurrencesOfString:@"tag" withString:@""]];
          
          [self callWebserviceForputTags:[[arrTags valueForKey:@"tag_id"]objectAtIndex:btnTag.tag]];
    }
    else
    {
       // btnTag.layer.borderWidth=0;
        btnTag.selected=NO;
        [btnTag setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        
        NSLog(@"%@",arrSelectedTags);
        if([[userDefault objectForKey:@"isFromcontactdetail"]isEqualToString:@"1"])
        {
            NSString *strtag_Id = [[arrTags valueForKey:@"tag_id"]objectAtIndex:btnTag.tag];
            int index = 0;
            for (NSDictionary *dictData in arrSelectedTags) {
                index++;
                if ([[dictData objectForKey:@"tag_id"]isEqualToString:strtag_Id]) {
                    break;
                }
            }
            [arrSelectedTags removeObjectAtIndex:index-1];
            NSLog(@"%@",arrSelectedTags);
        }
        NSLog(@"%@",arrSelectedTags);
        

        //        NSString *strTemp=[arrtemp objectAtIndex:btnTag.tag];
        //        [self callWebserviceForremoveTags:[strTemp stringByReplacingOccurrencesOfString:@"tag" withString:@""]];
        
        [self callWebserviceForremoveTags:[[arrTags valueForKey:@"tag_id"]objectAtIndex:btnTag.tag]];
    }
}
#pragma mark -set tag method
-(void)setTagsView
{
    
    for (UIButton *btn in self.viewTags.subviews) {
        [btn removeFromSuperview];
    }
    
    int x = 2;
    int y = 3;
    
    CGRect frame =  self.viewTags.frame;
     for (int i = 0; i < arrTags.count; i++) {
        
        NSDictionary *dictTags = [arrTags objectAtIndex:i];
        btnTags= [[UIButton alloc]init];
        btnTags.userInteractionEnabled = true;
        btnTags.tag = i;
        
        btnTags.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
        [btnTags setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [btnTags setTitle:[[arrTags valueForKey:@"tag_name"] objectAtIndex:i] forState:UIControlStateNormal]; //[[arrTags valueForKey:@"tag_name"] objectAtIndex:i]
        [btnTags sizeToFit];
        [btnTags addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        if([[userDefault objectForKey:@"isFromcontactdetail"]isEqualToString:@"1"])
        {
            if(arrSelectedTags.count>0)
            {
                if([[arrSelectedTags valueForKey:@"tag_id"] containsObject:[[arrTags valueForKey:@"tag_id"]objectAtIndex:i]])
                {
                    // btnTags.layer.borderColor = [UIColor blackColor].CGColor;
                    // btnTags.layer.borderWidth = 1;
                    [btnTags setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [btnTags setSelected:YES];
                }
            }
            else
            {
                //btnTags.layer.borderColor = [UIColor lightGrayColor].CGColor;
                //btnTags.layer.borderWidth = 1;
                [btnTags setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
            }

            
        }
         
        btnTags.layer.cornerRadius = 7;
        btnTags.layer.masksToBounds = true;
        btnTags.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        CGRect btnframe = btnTags.frame;
        float tempX = x + btnTags.frame.size.width;
        if (tempX > self.viewTags.frame.size.width-10) {
            x = 2;
            y = y + 32;
        }
        else{
            
        }
        btnframe.origin.x = x;
        btnframe.origin.y = y;
        btnframe.size.height = 28;
        btnTags.frame = btnframe;
        [self.viewTags addSubview:btnTags];
        x = x+btnTags.frame.size.width+3 ;
        frame.size.height = y+31;
    }
    //self.viewTags.frame = frame;
    self.tagViewHeight.constant=frame.size.height;
    self.scrlTagContainer.contentSize = CGSizeMake(frame.size.width, frame.size.height+20);
    
}


- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //        [scrlView setViewframe:textField forSuperView:self.view];
    self.txtAddTag=textField;
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [userDefault setObject:textField.text forKey:@"event"];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Autolayout keyboard Method

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrlView.contentInset = contentInsets;
    self.scrlView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.txtAddTag.frame.origin) ) {
        [self.scrlView scrollRectToVisible:self.txtAddTag.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrlView.contentInset = contentInsets;
    self.scrlView.scrollIndicatorInsets = contentInsets;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int length = [currentString length];
    if (length > 50) {
        return NO;
    }
    return YES;
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
