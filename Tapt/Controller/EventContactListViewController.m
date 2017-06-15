//
//  EventContactListViewController.m
//  Tapt
//
//  Created by TriState  on 7/10/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "EventContactListViewController.h"

@interface EventContactListViewController ()

@end

@implementation EventContactListViewController
@synthesize strEventContactId,dictContactResponse;
@synthesize strEventName;
- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate setShouldRotate:NO];
    arrEventContectlist=[[NSMutableArray alloc]init];
    
    
    self.lblEventName.text=strEventName;
    [self callWebserviceForGetContectFromEvent];
}

#pragma mark - UICollectionViewDelegate Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrEventContectlist count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    EventContectListCVCell *cell = (EventContectListCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EventContectListCVCell" forIndexPath:indexPath];
    if (cell==Nil) {
        cell = [[EventContectListCVCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
 
    cell.lblNameSurname.text=[NSString stringWithFormat:@"%@ %@",[[arrEventContectlist valueForKey:@"given_name"]objectAtIndex:indexPath.row],[[arrEventContectlist valueForKey:@"family_name"]objectAtIndex:indexPath.row]];
 

     //Lazy Loading--------BEGIN
    NSString *strPhotoURL=nil;
    NSString *urlFromDict=[[arrEventContectlist valueForKey:@"image"]objectAtIndex:indexPath.row];
    if(urlFromDict!=nil && ![urlFromDict isKindOfClass:[NSNull class]])
    {
        strPhotoURL=[WEBSERVICE_IMG_BASE_URL stringByAppendingPathComponent:urlFromDict];
        
    }
    
    cell.imgUserProfile.image = nil;
    if(strPhotoURL != nil){
        UIImage *image = [self imageIfExist:strPhotoURL];
        [self setImageURL:strPhotoURL forIndexPath:indexPath];
        
        if(image){
            cell.imgUserProfile.image = image;
            [cell.indicator stopAnimating];
        }
        else{
            [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
            [cell.indicator startAnimating];
        }
    }
    else{
        [cell.indicator stopAnimating];
        cell.imgUserProfile.image = [UIImage imageNamed:IMAGE_PLACEHOLDER];
    }
    //Lazy Loading-------- END
    
    cell.imgUserProfile.layer.cornerRadius=cell.imgUserProfile.frame.size.height/2;
    cell.imgUserProfile.layer.masksToBounds=YES;
    cell.imgUserProfile.layer.borderWidth=0;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",arrEventContectlist);
    
    NSString *str=[NSString stringWithFormat:@"Select * from Contact_Detail where contact_id='%@'",[[arrEventContectlist valueForKey:@"contectId"]objectAtIndex:indexPath.row]];
    NSMutableArray *arrtemp=[Database executeQuery:str];
    
    ContactDetailViewController *vcContactDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactDetailViewController"];
    vcContactDetail.dictContact=[arrtemp objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcContactDetail animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[userDefault objectForKey:@"displayList"] isEqualToString:@"2"])
        return CGSizeMake(300, 115);
    else
        return CGSizeMake(95, 115);
}

#pragma mark- calling Webservice
-(void)callWebserviceForGetContectFromEvent
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"getEvents" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:strEventContactId forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            NSLog(@"dict %@",dict);
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                arrtotalContact=[[NSArray alloc]init];
               arrtotalContact = [[dict objectForKey:@"Contacts"] componentsSeparatedByString:@","];
                  totalContact=arrtotalContact.count;
                dictContactResponse=dict;
                [self callPaging];
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
-(void)callPaging{
    
    startIndex=1;
    count=50;
    page=totalContact/50;
    
    for (int i=0; i<=page; i++) {
       
        NSLog(@"%ld",(long)startIndex);
         if (totalContact>=count) {
                
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
                [dict setObject:@"1.14" forKey:@"version"];
                [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        
        
        
                NSString *strId=@"";
                NSString *strTemp=@"";
             

        
                for (startIndex; startIndex<count; startIndex++) {
                    if ([strId isEqualToString:@""]) {
                        
                      //  strId=[NSString stringWithFormat:@"%@",[arrtotalContact objectAtIndex:startIndex]];
                        strTemp=[NSString stringWithFormat:@"%@",[arrtotalContact objectAtIndex:startIndex]];
                        
                        if (![strTemp isEqualToString:[userDefault objectForKey:@"ID"]]) {
                            strId=[NSString stringWithFormat:@"%@",strTemp];
                        }
                        
                    }
                    else
                    {
                       // strId=[strId stringByAppendingFormat:@",%@",[NSString stringWithFormat:@"%@",[arrtotalContact objectAtIndex:startIndex]]];
                        strTemp=[NSString stringWithFormat:@"%@",[arrtotalContact objectAtIndex:startIndex]];
                        
                        if (![strTemp isEqualToString:[userDefault objectForKey:@"ID"]]) {
                            strId=[strId stringByAppendingFormat:@",%@",strTemp];
                        }
                    }
                }
                startIndex=count+1;
                count=count+50;
                
                [dict setObject:strId forKey:@"senders"];
                strId=@"";
               [self callWebserviceForGetMyContact:dict];
        
            }
            else
            {
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:@"getSharedFieldsBatch" forKey:@"action"];
                [dict setObject:@"1.14" forKey:@"version"];
                [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
                
                NSString *strId=@"";
                NSString *strTemp=@"";
                
                
                for (startIndex; startIndex<totalContact; startIndex++) {
                    
                    if ([strId isEqualToString:@""]) {
                       
                        strTemp=[NSString stringWithFormat:@"%@",[arrtotalContact objectAtIndex:startIndex]];
                        
                        if (![strTemp isEqualToString:[userDefault objectForKey:@"ID"]]) {
                            strId=[NSString stringWithFormat:@"%@",strTemp];
                        }
                        
                        
                    }
                    else
                    {
                     
                       strTemp=[NSString stringWithFormat:@"%@",[arrtotalContact objectAtIndex:startIndex]];
                        
                        if (![strTemp isEqualToString:[userDefault objectForKey:@"ID"]]) {
                            strId=[strId stringByAppendingFormat:@",%@",strTemp];
                        }
                    }
                }
                startIndex=count+1;
                
                [dict setObject:strId forKey:@"senders"];
                
                strId=@"";
                
                [self callWebserviceForGetMyContact:dict];
            }
        
        
    }
 }
-(void)callWebserviceForGetMyContact:(NSMutableDictionary *)dict
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        NSLog(@"dict := %@", dict);
        
        Webservice *service1=[[Webservice alloc]init];
        
        [service1 callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                [dict removeObjectForKey:@"Count"];
                [dict removeObjectForKey:@"Response"];
                for (NSString *strkey in dict)
                {
                    NSMutableDictionary *tempdata =[dict objectForKey:strkey];
                    NSMutableDictionary *dictData=[[NSMutableDictionary alloc]init];
                    [tempdata setObject:[strkey stringByReplacingOccurrencesOfString:@"id " withString:@""] forKey:@"contectId"];
                    [arrEventContectlist addObject:tempdata];
                 }
             
                [self.EventContectCollectionView reloadData];
                NSLog(@"%@",arrEventContectlist);
                
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

/*#pragma mark - tableview datasource delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrEventContectlist count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//    cell.textLabel.layer.borderWidth = 1.0;
    
    cell.textLabel.textColor=[UIColor whiteColor];
      
    NSString *strContactName=[NSString stringWithFormat:@"%@ %@",[[arrEventContectlist valueForKey:@"given_name"]objectAtIndex:indexPath.row],[[arrEventContectlist valueForKey:@"family_name"]objectAtIndex:indexPath.row]];
    cell.textLabel.text =strContactName;
  
    return cell;
 } */



- (IBAction)btnBavkAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
