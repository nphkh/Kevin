//
//  WhoSharedWithDetailViewController.m
//  Tapt
//
//  Created by TriState  on 7/13/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "WhoSharedWithDetailViewController.h"

@interface WhoSharedWithDetailViewController ()

@end

@implementation WhoSharedWithDetailViewController
@synthesize sharedFeildContact;
- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    
    bufferArray = [NSMutableArray array];
    NSLog(@"%@",sharedFeildContact);
    self.lblName.text=[NSString stringWithFormat:@"%@ %@",[sharedFeildContact objectForKey:@"given_name"],[sharedFeildContact objectForKey:@"family_name"]];
    
    [self callWebserviceForGetshareFeildList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview datasource delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // return [arrNotesdetail count];
    if(section==0)
    {
        return arrsharedFeiled.count;
    }
    else
    {
        return 2;

    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   if(indexPath.section==0)
   {
       WhoshareWithTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WhoshareWithTVCell1"];
       
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.delegate=self;
       cell.tag=indexPath.row;
       
       
       NSString *str=[NSString stringWithFormat:@"%@",[[arrsharedFeiled valueForKey:@"ShareFeild"]objectAtIndex:indexPath.row]];
       cell.lblShareFeild.text=str;
       //cell.lblShareFeild.text=[[arrsharedFeiled valueForKey:@"ShareFeild"]objectAtIndex:indexPath.row];
       
       return cell;

   }
   else
   {
       if(indexPath.row==0)
       {
           WhoshareWithTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WhoshareWithTVCell2"];
            return cell;
       }
       else if(indexPath.row==1)
       {
            WhoshareWithTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WhoshareWithTVCell3"];
           cell.delegate=self;
            return cell;
       }
       else
       {
           return 0;
       }
      
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section==0)
    {
        return 40;
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            return 80;
        }
        else
        {
            return 60;
        }
    
    }
    else
    {
        return 0;
    }
}
#pragma mark - calling webservices
-(void)callWebserviceForGetshareFeildList
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"showSharedFields" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"userPass"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:[sharedFeildContact objectForKey:@"contactId"] forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
         {
            [self hidHud];
            NSLog(@"dict %@",dict);
             [dict removeObjectForKey:@"Response"];
             arrsharedFeiled=[[NSMutableArray alloc]init];
//              NSString *strfeiled=@"";
//              for (NSString *strkey in dict)
//              {
//                  if ([strfeiled isEqualToString:@""]) {
//                      strfeiled = [NSString stringWithFormat:@"%@",[dict objectForKey:[NSString stringWithFormat:@"%@",strkey]]];
//                  }
//                  else
//                  {
//                      
//                      strfeiled = [strfeiled stringByAppendingString:[NSString stringWithFormat:@",%@",[dict objectForKey:[NSString stringWithFormat:@"%@",strkey]]]];
//                  }
//              }
//             NSLog(@"%@",strfeiled);
           
             
           /*  arrFieldkey= [[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Mobile",@"Picture",@"Home Phonenumber",@"Home Email",@"Home Address",@"Home Street",@"Home City",@"Home state",@"Home Country",@"Home Postcode",@"Company",@"Title",
                                @"Office Phone",@"Office MObile",@"Office Email",@"Website",@"Logo",@"Office Address",@"Office Street",@"Office City",@"Office State",@"Office Country",@"Office Postcode",@"Facebook",@"Twitter",@"Linked In",@"Skype",nil];
             
             for(NSString *key in temparray)
             {
                 [arrsharedFeiled addObject:[arrFieldkey objectAtIndex:[temparray indexOfObject:key]]];
             }
             NSLog(@"%@",arrsharedFeiled);  */
             
             
             
             NSMutableDictionary *dictallfeild=[[NSMutableDictionary alloc]init];
             [dictallfeild setObject:@"First Name" forKey:@"given_name"];
             [dictallfeild setObject:@"Last Name" forKey:@"family_name"];
             [dictallfeild setObject:@"Picture" forKey:@"image"];
             [dictallfeild setObject:@{@"home":@"Mobile",@"work":@"Office Mobile"} forKey:@"mobile_phone"];
             
             [dictallfeild setObject:@"Phonenumber" forKey:@"phone"];
             [dictallfeild setObject:@{@"home":@"Home Email",@"work":@"Office Email"} forKey:@"email"];
             [dictallfeild setObject:@{@"home":@"Home Address",@"work":@"Office Address"} forKey:@"address1"];
             [dictallfeild setObject:@{@"home":@"Home Street",@"work":@"Office Street"} forKey:@"suburb"];
             [dictallfeild setObject:@{@"home":@"Home City",@"work":@"Office City"} forKey:@"city"];
             [dictallfeild setObject:@{@"home":@"Home State",@"work":@"Office State"} forKey:@"state"];
             [dictallfeild setObject:@{@"home":@"Home Country",@"work":@"Office Country"} forKey:@"country"];
             [dictallfeild setObject:@{@"home":@"Home Postcode",@"work":@"Office Postcode"} forKey:@"post_code"];
             
             [dictallfeild setObject:@"Company" forKey:@"company"];
             [dictallfeild setObject:@"Title" forKey:@"title"];
             [dictallfeild setObject:@"Logo" forKey:@"logo"];
             [dictallfeild setObject:@"Phone" forKey:@"mobile_phone"];
             [dictallfeild setObject:@"Mobile" forKey:@"phone"];
             [dictallfeild setObject:@"Website" forKey:@"www"];
             
             [dictallfeild setObject:@"Facebook" forKey:@"facebook"];
             [dictallfeild setObject:@"Twitter" forKey:@"twitter"];
             [dictallfeild setObject:@"Linked In" forKey:@"linkedin"];
             [dictallfeild setObject:@"Skype" forKey:@"Skype"];
             
             NSArray *groups = @[@"fields",@"home",@"social",@"work"];
             for(NSString *strkey in groups)
             {
                 if(![[dict objectForKey:[NSString stringWithFormat:@"%@",strkey]]isKindOfClass:[NSNull class]])
                 {
                         NSArray *tmparray=[[dict objectForKey:[NSString stringWithFormat:@"%@",strkey]] componentsSeparatedByString:@","];
                         for(NSString *key in tmparray)
                         {
                             NSMutableDictionary *tempdict=[[NSMutableDictionary alloc]init];
                             NSString *strFieldName = [dictallfeild objectForKey:[NSString stringWithFormat:@"%@",key]];
                             if([strFieldName isKindOfClass:[NSDictionary class]]){
                                 strFieldName = [(NSMutableDictionary*)strFieldName objectForKey:strkey];
                             }
                             
                              if(strFieldName.length>0)
                              {
                                  [tempdict setObject:strFieldName forKey:@"ShareFeild"];
                                  
                                 
                                  
                                  
                                  [tempdict setObject:key forKey:@"actualFeild"];
                                  [tempdict setObject:strkey forKey:@"group"];
                                  [arrsharedFeiled addObject:tempdict];
                              }
                        }

                    }
                 
                }
             NSLog(@"%@",arrsharedFeiled);
             
//             NSLog(@"%@",dictallfeild);
//             for(NSString *key in temparray)
//             {
//                 NSMutableDictionary *tempdict=[[NSMutableDictionary alloc]init];
//                 [tempdict setObject:[dictallfeild objectForKey:[NSString stringWithFormat:@"%@",key]] forKey:@"ShareFeild"];
//                 [tempdict setObject:key forKey:@"actualFeild"];
//                 
//                 [arrsharedFeiled addObject:tempdict];
//             }
//             NSLog(@"%@",arrsharedFeiled);
             [self.tblSharedFeilddetail reloadData];
             
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
-(void)callWebserviceForUpdateshareFeilds:(NSMutableDictionary*)dict
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
   //     NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"updateSharedFields" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"userPass"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:[sharedFeildContact objectForKey:@"contactId"] forKey:@"senderId"];
        
//        [dict setObject:[NSString stringWithFormat:@"%@",]; forKey:@"fields"];
//        [dict setObject:[NSString stringWithFormat:@"%@",]; forKey:@"home"];
//        [dict setObject:[NSString stringWithFormat:@"%@",]; forKey:@"work"];
//        [dict setObject:[NSString stringWithFormat:@"%@",]; forKey:@"social"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
         {
             [self hidHud];
             [arrsharedFeiled removeAllObjects];
             [arrsharedFeiled addObjectsFromArray:bufferArray];
             [self.tblSharedFeilddetail reloadData];
             NSLog(@"%@",dict);
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
-(void)callWebserviceForDeleteContact{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"deleteContact" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"userPass"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:[sharedFeildContact objectForKey:@"contactId"] forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
         {
             [self hidHud];
             NSLog(@"%@",dict);
               if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
               {
                   
                   NSString *query1= [NSString stringWithFormat:@"delete from Contact_Detail where contact_id=%@",[sharedFeildContact objectForKey:@"contactId"]];
                   NSMutableArray *arrResponse1=[NSMutableArray arrayWithArray:[Database executeQuery:query1]];
                   
                   
                   
                   
                   for (UIViewController *controller in self.navigationController.viewControllers) {
                       
                       if ([controller isKindOfClass:[ContactViewController class]]) {
                           
                           [self.navigationController popToViewController:controller
                                                                 animated:YES];
                           break;
                       }
                   }

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

#pragma mark - cell delegate method
-(void)btnRemoveSharefeildAction:(WhoshareWithTVCell*)cell
{
    
    [bufferArray removeAllObjects];
    [bufferArray addObjectsFromArray:arrsharedFeiled];
    
    [bufferArray removeObjectAtIndex:cell.tag];
    NSArray *groups = @[@"fields",@"home",@"social",@"work"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *strKey in groups){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Self.group == [c] %@",strKey];
        NSArray *filterArray = [bufferArray filteredArrayUsingPredicate:predicate];
        
        NSMutableArray *fields = [NSMutableArray array];
        for(NSMutableDictionary *dict in filterArray){
            [fields addObject:[dict objectForKey:@"actualFeild"]];
        }
        
        NSString *strVal = [fields componentsJoinedByString:@","];
        [params setObject:strVal forKey:strKey];
    }
    
   
    
   /* for(NSString *key in temparray)
    {
       strtemp=[temparray objectAtIndex:[arrsharedFeiled indexOfObject:key]];
    }*/
    [self callWebserviceForUpdateshareFeilds:params];

}
-(void)switchDeleteContactValuechange:(WhoshareWithTVCell*)cell
{
    if([cell.switchDeleteContact isOn])
    {
        [self callWebserviceForDeleteContact];
    }
    else
    {
        NSLog(@"off");
    }
}
#pragma mark- tabbar button action method


- (IBAction)btnPersoneTabAction:(id)sender {
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

- (IBAction)btnFavoriteTabAction:(id)sender {
}

- (IBAction)btnSettingTabAction:(id)sender {
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
- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
