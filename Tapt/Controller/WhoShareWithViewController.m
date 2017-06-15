//
//  WhoShareWithViewController.m
//  Tapt
//
//  Created by TriState  on 7/13/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "WhoShareWithViewController.h"

@interface WhoShareWithViewController ()

@end

@implementation WhoShareWithViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    arrWhoShareWithContact=[[NSMutableArray alloc]init];
    
    [self callWebserviceForWhoIhaveshare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark -calling Webservice
-(void)callWebserviceForWhoIhaveshare
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"whoSharedWith" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"userPass"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
       
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            [dict removeObjectForKey:@"Count of Shares"];
            [dict removeObjectForKey:@"Response"];
            [dict removeObjectForKey:@"contacts"];
            
            for (NSString *strkey in dict) {
                
                NSMutableDictionary *dictData = [dict objectForKey:strkey];
                [dictData setObject:[strkey stringByReplacingOccurrencesOfString:@"contact" withString:@""] forKey:@"contactId"];
                
                [arrWhoShareWithContact addObject:dictData];
            }
           
           // [self.collectionWhoISharewith  reloadData];
            [self.tblWhoISharedWith reloadData];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrWhoShareWithContact count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor=[UIColor clearColor];
      // cell.textLabel.layer.borderColor = [UIColor whiteColor].CGColor;
       // cell.textLabel.layer.borderWidth = 1.0;
    
    cell.textLabel.textColor=[UIColor whiteColor];
    
   NSString *strname=[NSString stringWithFormat:@"%@ %@",[[arrWhoShareWithContact valueForKey:@"given_name"]objectAtIndex:indexPath.row],[[arrWhoShareWithContact valueForKey:@"family_name"]objectAtIndex:indexPath.row]];
    cell.textLabel.text =strname;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    WhoSharedWithDetailViewController *vcWhoSharewithDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"WhoSharedWithDetailViewController"];
    vcWhoSharewithDetail.sharedFeildContact=[arrWhoShareWithContact objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcWhoSharewithDetail animated:YES];

}
/*#pragma mark - UICollectionViewDelegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrWhoShareWithContact count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventContectListCVCell *cell = (EventContectListCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EventContectListCVCell" forIndexPath:indexPath];
    if (cell==Nil) {
        cell = [[EventContectListCVCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    if(arrWhoShareWithContact.count>0)
    {
        NSString *strname=[NSString stringWithFormat:@"%@ %@",[[arrWhoShareWithContact valueForKey:@"given_name"]objectAtIndex:indexPath.row],[[arrWhoShareWithContact valueForKey:@"family_name"]objectAtIndex:indexPath.row]];
        
       cell.lblNameSurname.text=strname;

        
        
        //Lazy Loading--------BEGIN
        NSString *strPhotoURL=nil;
        NSString *urlFromDict=[[arrWhoShareWithContact valueForKey:@"image"]objectAtIndex:indexPath.row];
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
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        WhoSharedWithDetailViewController *vcWhoSharewithDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"WhoSharedWithDetailViewController"];
        vcWhoSharewithDetail.sharedFeildContact=[arrWhoShareWithContact objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vcWhoSharewithDetail animated:YES];
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    //return CGSizeMake(100, 120);
//      return CGSizeMake(70,70);
//    
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//   // return UIEdgeInsetsMake(0, 10, 0, 10);
//    return UIEdgeInsetsMake(0,5, 0,5);
//} */

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
