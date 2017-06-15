//
//  FavoriteContectViewController.m
//  Tapt
//
//  Created by TriState  on 7/17/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "FavoriteContectViewController.h"

@interface FavoriteContectViewController ()

@end

@implementation FavoriteContectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    arrFavoriteContact=[NSMutableArray array];

    NSString *selectQuery = [ NSString stringWithFormat:@"select * from Contact_Detail where Favorite=%@",[NSString stringWithFormat:@"1"]];
     arrFavoriteContact=[Database executeQuery:selectQuery];
    [self.collVIewFavoriteContect reloadData];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UICollectionViewDelegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrFavoriteContact count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteContactCVCell *cell = (FavoriteContactCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteContactCVCell" forIndexPath:indexPath];
    if (cell==Nil) {
        cell = [[FavoriteContactCVCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    NSString *strnamesurname=[NSString stringWithFormat:@"%@ %@",[[arrFavoriteContact valueForKey:@"first_name"]objectAtIndex:indexPath.row],[[arrFavoriteContact valueForKey:@"last_name"]objectAtIndex:indexPath.row]];
    cell.lblNameSurname.text=strnamesurname;
  
    //Lazy Loading--------BEGIN
    NSString *strPhotoURL=nil;
    NSString *urlFromDict=[[arrFavoriteContact valueForKey:@"image_url"]objectAtIndex:indexPath.row];
    if(urlFromDict!=nil && ![[urlFromDict trimSpaces] isEqualToString:@""])
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
    ContactDetailViewController *vcContactDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactDetailViewController"];
    vcContactDetail.dictContact=[arrFavoriteContact objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcContactDetail animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20,5,0,5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   return CGSizeMake(95,115);
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tabbutton action
- (IBAction)btnPersonTabAction:(id)sender {
    
  /*  [userDefault setObject:@"1" forKey:@"isFromContact"];
    
    NSString *query =[NSString stringWithFormat:@"select * from tbl_profile where cid='%@'",[userDefault objectForKey:@"ID"]];
    arrUserDetail=[[NSMutableArray alloc]init];
    arrUserDetail=[Database executeQuery:query];
    NSLog(@"%@",arrUserDetail);
    
    UserDetail *userDtl=[UserDetail sharedInstance];
    if(arrUserDetail.count>0)
    {
        userDtl.firstName=[[arrUserDetail valueForKey:@"given_name"]objectAtIndex:0];
        userDtl.lastName=[[arrUserDetail valueForKey:@"family_name"]objectAtIndex:0];
        userDtl.MobileNumber=[[arrUserDetail valueForKey:@"home_mobile_phone"]objectAtIndex:0];
        userDtl.ProfilePhoto=[[arrUserDetail valueForKey:@"image"]objectAtIndex:0];
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
        userDtl.Website=[[arrUserDetail valueForKey:@"work_www"]objectAtIndex:0];
        userDtl.Logoimg=[[arrUserDetail valueForKey:@"logo"]objectAtIndex:0];
        userDtl.officeAddress=[[arrUserDetail valueForKey:@"work_address1"]objectAtIndex:0];
        userDtl.officeStreet=[[arrUserDetail valueForKey:@"work_suburb"]objectAtIndex:0];
        userDtl.officeCity=[[arrUserDetail valueForKey:@"work_city"]objectAtIndex:0];
        userDtl.officeState=[[arrUserDetail valueForKey:@"work_state"]objectAtIndex:0];
        userDtl.officeCountry=[[arrUserDetail valueForKey:@"work_country"]objectAtIndex:0];
        userDtl.officePostCode=[[arrUserDetail valueForKey:@"work_post_code"]objectAtIndex:0];
        userDtl.cardlayout=[[arrUserDetail valueForKey:@"layout"]objectAtIndex:0];
        userDtl.facebook=[[arrUserDetail valueForKey:@"social_facebook"]objectAtIndex:0];
        userDtl.twitter=[[arrUserDetail valueForKey:@"social_twitter"]objectAtIndex:0];
        userDtl.linkedin=[[arrUserDetail valueForKey:@"social_linkedin"]objectAtIndex:0];
        userDtl.skype=[[arrUserDetail valueForKey:@"social_Skype"]objectAtIndex:0];
    }
    else
    {
        userDtl.firstName=@"";
        userDtl.lastName=@"";
        userDtl.MobileNumber=@"";
        userDtl.ProfilePhoto=@"";
        userDtl.homePhone=@"";
        userDtl.homeEmail=@"";
        userDtl.homeAddress=@"";
        userDtl.homeStreet=@"";
        userDtl.homeCity=@"";
        userDtl.homeState=@"";
        userDtl.homeCountry=@"";
        userDtl.homePostCode=@"";
        userDtl.companyName=@"";
        userDtl.title=@"";
        userDtl.officePhonenumber=@"";
        userDtl.officeMobilenumber=@"";
        userDtl.officeEmail=@"";
        userDtl.Website=@"";
        userDtl.Logoimg=@"";
        userDtl.officeAddress=@"";
        userDtl.officeStreet=@"";
        userDtl.officeCity=@"";
        userDtl.officeState=@"";
        userDtl.officeCountry=@"";
        userDtl.officePostCode=@"";
        userDtl.cardlayout=@"";
        userDtl.facebook=@"";
        userDtl.twitter=@"";
        userDtl.linkedin=@"";
        userDtl.skype=@"";
        
    }
    
    ProfileTabbarViewController *vcProfiletab=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTabbarViewController"];
    [self.navigationController pushViewController:vcProfiletab animated:YES]; */
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)btnSendTabAction:(id)sender {
    
    SendContactViewController *vcsend=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactViewController"];
    [self.navigationController pushViewController:vcsend animated:YES];
    
    
}

- (IBAction)btnReceiveTabAction:(id)sender {
    
    
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
            settingView = [UIView loadView:@"SettingMenu"]; //SettingMenuView
            settingView.frame = CGRectMake(self.view.frame.size.width-(settingView.frame.size.width), self.view.frame.size.height, settingView.frame.size.width, settingView.frame.size.height);
            settingView.layer.cornerRadius=5;
            //settingView.layer.borderWidth=1.0;
            // settingView.layer.borderColor = [UIColor whiteColor].CGColor;
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
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
