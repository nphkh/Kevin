//
//  CardLayoutViewController.m
//  Tapt
//
//  Created by Parth on 18/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "CardLayoutViewController.h"
#import "CardLayoutCVCell.h"
#import "Constants.h"
#import "Webservice.h"
#import "NSString+Extensions.h"
#import "Database.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "UserDetail.h"


@interface CardLayoutViewController ()
{
    NSUserDefaults *userDefault;
    NSInteger intCard;
}
@end

@implementation CardLayoutViewController
@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
    userDefault = [NSUserDefaults standardUserDefaults];
    intCard=1;
     [Database createEditableCopyOfDatabaseIfNeeded];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [appDelegate setShouldRotate:NO];
    
//    NSString *query = @"select * from tbl_profile";
//   arrUserDetail=[[NSMutableArray alloc]init];
//    arrUserDetail=[Database executeQuery:query];
//    NSLog(@"%@",arrUserDetail);
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardLayoutCVCell *cvCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellLayout" forIndexPath:indexPath];
//    cvCell.imgLayout.image=[UIImage imageNamed:[NSString stringWithFormat:@"BusinessCard%ld.png", (long)indexPath.row+1 ]];
    cvCell.imgLayout.image=[UIImage imageNamed:[NSString stringWithFormat:@"TAPTColourBCard-%ld.png", (long)indexPath.row+1 ]];
    if([[userDefault objectForKey:@"cardLayout"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]])
    {
//        cvCell.highlighted=YES;
        cvCell.imgGlowEffect.image=[UIImage imageNamed:@"frame-shadow.png"];
//        cvCell.imgLayout.layer.borderWidth=2;
    }
    else{
        cvCell.imgGlowEffect.image=[UIImage imageNamed:@""];
//        cvCell.imgLayout.layer.borderWidth=0;
    }
    return cvCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    intCard=indexPath.row+1;
    
    [userDefault setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:@"cardLayout"];
   
    //[collectionView reloadData];
    
     UserDetail *userDtl=[UserDetail sharedInstance];
    userDtl.cardlayout=[NSString stringWithFormat:@"%ld",indexPath.row+1];

    CardPreviewView *cardPreview=[CardPreviewView loadView];
    cardPreview.delegate=self;
    cardPreview.frame=CGRectMake(cardPreview.frame.origin.x, cardPreview.frame.origin.y-60, self.view.frame.size.width, cardPreview.frame.size.height);
    [self.view addSubview:cardPreview];
   

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

//- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    CardLayoutCVCell *cell = (CardLayoutCVCell *)[colView cellForItemAtIndexPath:indexPath];
//    cell.imgLayout.layer.borderWidth=2;
//    cell.imgLayout.image=[UIImage imageNamed:@""];
//    
//    [collectionView reloadData];
////    cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
//    
//}
//
//- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
////    CardLayoutCVCell *cell = (CardLayoutCVCell *)[colView cellForItemAtIndexPath:indexPath];
////    cell.imgLayout.layer.borderWidth=0;
////    cell.contentView.backgroundColor = nil;
//}
//

#pragma mark - Action Method

- (IBAction)btnDoneAction:(id)sender {    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackAction:(id)sender {
    [self callWebservice];
}

#pragma mark - CustomDelegatePreview MEthod

-(void)backAction{
    //[self callWebservice];
    
    [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)intCard] forKey:@"cardLayout"];
 
  
}

#pragma mark - UIAlertViewDelegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [userDefault setObject:[NSString stringWithFormat:@"%ld", (long)intCard] forKey:@"  "];
            [collectionView reloadData];
            UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"LayoutPreviewViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;
        default:
            break;
    }
}

#pragma mark - Custom Method

-(void)callWebservice
{
    UserDetail *userDtl=[UserDetail sharedInstance];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
        [dict setObject:@"update" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
    
    /*[dict setObject:[arrUserDetail valueForKey:@"first_name"] forKey:@"given_name"];
        [dict setObject:[arrUserDetail valueForKey:@"last_name"] forKey:@"family_name"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_mobile_phone"] forKey:@"home_mobile_phone"];
        
        
        [dict setObject:[arrUserDetail valueForKey:@"home_phone"] forKey:@"home_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"home_phone2"] forKey:@"home_phone2"];
        
        
        [dict setObject:[arrUserDetail valueForKey:@"home_email"] forKey:@"home_email"];
        [dict setObject:[arrUserDetail valueForKey:@"home_www"] forKey:@"home_www"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_address1"] forKey:@"home_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"home_address2"] forKey:@"home_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"home_address3"] forKey:@"home_address3"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_suburb"] forKey:@"home_suburb"];
        [dict setObject:[arrUserDetail valueForKey:@"home_city"] forKey:@"home_city"];
        [dict setObject:[arrUserDetail valueForKey:@"home_state"] forKey:@"home_state"];
        [dict setObject:[arrUserDetail valueForKey:@"home_country"] forKey:@"home_country"];
        [dict setObject:[arrUserDetail valueForKey:@"home_post_code"] forKey:@"home_post_code"];
        
        [dict setObject:[arrUserDetail valueForKey:@"company"] forKey:@"company"];
        [dict setObject:[arrUserDetail valueForKey:@"title"] forKey:@"title"];
        
        [dict setObject:[arrUserDetail valueForKey:@"work_mobile_phone"] forKey:@"work_mobile_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"work_phone"] forKey:@"work_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"work_phone2"] forKey:@"work_phone2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_email"] forKey:@"work_email"];
        [dict setObject:[arrUserDetail valueForKey:@"website"] forKey:@"website"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address1"] forKey:@"work_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
        [dict setObject:[arrUserDetail valueForKey:@"work_suburb"] forKey:@"work_suburb"];
        [dict setObject:[arrUserDetail valueForKey:@"work_city"] forKey:@"work_city"];
        [dict setObject:[arrUserDetail valueForKey:@"work_state"] forKey:@"work_state"];
        [dict setObject:[arrUserDetail valueForKey:@"work_country"] forKey:@"work_country"];
        [dict setObject:[arrUserDetail valueForKey:@"work_post_code"] forKey:@"work_post_code"];*/
   
    [dict setObject:userDtl.firstName forKey:@"given_name"];
    [dict setObject:userDtl.lastName forKey:@"family_name"];
     [dict setObject:userDtl.MobileNumber forKey:@"home_mobile_phone"];

    [dict setObject:userDtl.homePhone forKey:@"home_phone"];
    [dict setObject:@"" forKey:@"home_phone2"];
    
    
    [dict setObject:userDtl.homeEmail forKey:@"home_email"];
    [dict setObject:@"" forKey:@"home_www"];
    
    [dict setObject:userDtl.homeAddress forKey:@"home_address1"];
    [dict setObject:@"" forKey:@"home_address2"];
    [dict setObject:@"" forKey:@"home_address3"];
    
    [dict setObject:userDtl.homeStreet forKey:@"home_suburb"];
    [dict setObject:userDtl.homeCity forKey:@"home_city"];
    [dict setObject:userDtl.homeState forKey:@"home_state"];
    [dict setObject:userDtl.homeCountry  forKey:@"home_country"];
    [dict setObject:userDtl.homePostCode forKey:@"home_post_code"];
    
    [dict setObject:userDtl.companyName forKey:@"company"];
    [dict setObject:userDtl.title forKey:@"title"];
    
    [dict setObject:userDtl.officeMobilenumber forKey:@"work_mobile_phone"];
    [dict setObject:userDtl.officePhonenumber forKey:@"work_phone"];
    [dict setObject:@"" forKey:@"work_phone2"];
    
    [dict setObject:userDtl.officeEmail forKey:@"work_email"];
    [dict setObject:userDtl.Website forKey:@"work_www"];
    [dict setObject:userDtl.officeAddress forKey:@"work_address1"];
    [dict setObject:@"" forKey:@"work_address2"];
    [dict setObject:@"" forKey:@"work_address3"];
    [dict setObject:userDtl.officeStreet forKey:@"work_suburb"];
    [dict setObject:userDtl.officeCity forKey:@"work_city"];
    [dict setObject:userDtl.officeState forKey:@"work_state"];
    [dict setObject:userDtl.officeCountry forKey:@"work_country"];
    [dict setObject:userDtl.officePostCode forKey:@"work_post_code"];
    
    
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
            
            NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
            [dict setObject:[dictFB objectForKey:@"fbid"] forKey:@"social_facebook"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_facebook"];
        }
        
        if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
            if([userDefault objectForKey:@"twId"])
            {
                [dict setObject:[userDefault objectForKey:@"twId"] forKey:@"social_twitter"];
            }
            else{
                [dict setObject:@"" forKey:@"social_twitter"];
            }
        }
        else
        {
            [dict setObject:@"" forKey:@"social_twitter"];
        }
        
        if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
            
            //            [dict setObject:[userDefault objectForKey:@"LinkedInValue"] forKey:@"social_linkedin"];
            [dict setObject:[userDefault objectForKey:@"linkedIn_url"] forKey:@"social_linkedin"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_linkedin"];
        }
        
        [dict setObject:SAFESTRING([userDefault objectForKey:@"skypeId"]) forKey:@"social_skype"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"cardLayout"]) forKey:@"bizcard"];
        
 
    NSLog(@"%@",dict);
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
                
                
                //update in to database
               // NSString *query= [NSString stringWithFormat:@"update tbl_profile set layout='%@' where cid='%@'",[NSString stringWithFormat:@"%ld",(long)intCard], [userDefault objectForKey:@"ID"]];
                
                NSString *query= [NSString stringWithFormat:@"update tbl_profile set given_name='%@',family_name='%@',home_mobile_phone='%@',home_phone='%@',home_email='%@',home_address1='%@',home_suburb='%@',home_city='%@',home_state='%@',home_country='%@',home_post_code='%@',company='%@',title='%@',work_phone='%@',work_mobile_phone='%@',work_email='%@',work_www='%@',work_address1='%@',work_suburb='%@',work_city='%@',work_state='%@',work_country='%@',work_post_code='%@',layout='%@',social_facebook='%@',social_twitter='%@',social_linkedin='%@',social_Skype='%@' where cid='%@'",[NSString stringWithFormat:@"%@",userDtl.firstName],[NSString stringWithFormat:@"%@",userDtl.lastName],[NSString stringWithFormat:@"%@",userDtl.MobileNumber],[NSString stringWithFormat:@"%@",userDtl.homePhone],[NSString stringWithFormat:@"%@",userDtl.homeEmail],[NSString stringWithFormat:@"%@",userDtl.homeAddress],[NSString stringWithFormat:@"%@",userDtl.homeStreet],[NSString stringWithFormat:@"%@",userDtl.homeCity],[NSString stringWithFormat:@"%@",userDtl.homeState],[NSString stringWithFormat:@"%@",userDtl.homeCountry],[NSString stringWithFormat:@"%@",userDtl.homePostCode],[NSString stringWithFormat:@"%@",userDtl.companyName],[NSString stringWithFormat:@"%@",userDtl.title],[NSString stringWithFormat:@"%@",userDtl.officePhonenumber],[NSString stringWithFormat:@"%@",userDtl.officeMobilenumber],[NSString stringWithFormat:@"%@",userDtl.officeEmail],[NSString stringWithFormat:@"%@",userDtl.Website],[NSString stringWithFormat:@"%@",userDtl.officeAddress],[NSString stringWithFormat:@"%@",userDtl.officeStreet],[NSString stringWithFormat:@"%@",userDtl.officeCity],[NSString stringWithFormat:@"%@",userDtl.officeState],[NSString stringWithFormat:@"%@",userDtl.officeCountry],[NSString stringWithFormat:@"%@",userDtl.officePostCode],[userDefault objectForKey:@"cardLayout"],SAFESTRING([userDefault objectForKey:@"fbid"]),SAFESTRING([userDefault objectForKey:@"twId"]),SAFESTRING([userDefault objectForKey:@"linkedIn_url"]),[userDefault objectForKey:@"social_skype"],[userDefault objectForKey:@"ID"]];
                
                    [Database executeQuery:query];
                    NSLog(@"Data Updated!");
                    
                //[userDefault setObject:@"1" forKey:@"isFirstTime"];
                [userDefault setObject:@"1" forKey:@"isRegistered"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                userDtl.cardlayout=[userDefault objectForKey:@"cardLayout"];
                
                [userDefault setObject:userDtl.firstName forKey:@"first_name"];
                [userDefault setObject:userDtl.lastName forKey:@"last_name"];
                [userDefault setObject:userDtl.MobileNumber forKey:@"mobile_phone"];
                [userDefault setObject:userDtl.homePhone forKey:@"homePhone"];
                [userDefault setObject:userDtl.homeEmail forKey:@"homeEmail"];
                [userDefault setObject:userDtl.homeAddress forKey:@"homeAddress"];
                [userDefault setObject:userDtl.homeStreet forKey:@"homeStreet"];
                [userDefault setObject:userDtl.homeCity forKey:@"homeCity"];
                [userDefault setObject:userDtl.homeState forKey:@"homeState"];
                [userDefault setObject:userDtl.homeCountry forKey:@"homeCountry"];
                [userDefault setObject:userDtl.homePostCode forKey:@"homePostcode"];
                [userDefault setObject:userDtl.companyName forKey:@"companyName"];
                [userDefault setObject:userDtl.title forKey:@"title"];
                [userDefault setObject:userDtl.officePhonenumber forKey:@"officePhone"];
                [userDefault setObject:userDtl.officeMobilenumber forKey:@"officeMobile"];
                [userDefault setObject:userDtl.officeEmail forKey:@"officeEmail"];
                [userDefault setObject:userDtl.Website forKey:@"officeWebsite"];
                [userDefault setObject:userDtl.officeAddress forKey:@"officeAddress"];
                [userDefault setObject:userDtl.officeStreet forKey:@"officeStreet"];
                [userDefault setObject:userDtl.officeCity forKey:@"officeCity"];
                [userDefault setObject:userDtl.officeState forKey:@"officeState"];
                [userDefault setObject:userDtl.officeCountry forKey:@"officeCountry"];
                [userDefault setObject:userDtl.officePostCode forKey:@"officePostcode"];

                
                
                //for images
                if (appDelegate.isimage) {
                    appDelegate.isimage=NO;
                    [self uploadImage];
                }
                else
                {
                    if (appDelegate.isLogo) {
                        appDelegate.isLogo=NO;
                        [self uploadLogo];
                    }
                    else{
                        
//                        if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//                        {
//                            ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                            vcContact.hidesBottomBarWhenPushed=YES;
//                            [self.navigationController pushViewController:vcContact animated:YES];
//                            
//                        }
//                        else
//                        {
//                            UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                            vcIntro.hidesBottomBarWhenPushed=YES;
//                            [self.navigationController pushViewController:vcIntro animated:YES];
//                        }
                        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
                        
                        UINavigationController *navVc = (UINavigationController *)keyWindow.rootViewController;
                        [navVc popViewControllerAnimated:YES];

                    }
                }

                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } onFailure:^(NSError *error) {
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
-(void)uploadImage{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSData *dataOfImg=[userDefault objectForKey:@"UserImagedata"];
        
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"action=image&version=1.14&id=%@&password=%@&afile=afile",[userDefault objectForKey:@"ID"],[userDefault objectForKey:@"Salt"]];
        Webservice *service=[[Webservice alloc]init];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"image" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        [service callPOSTWebServiceWithImage:dataOfImg andParams:dict isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            
            NSString *strPicURl=[WEBSERVICE_IMG_BASE_URL stringByAppendingString:[dict objectForKey:@"Filename"]];
            
            [userDefault setObject:strPicURl forKey:@"picname"];
            
            UserDetail *userDtl=[UserDetail sharedInstance];
            userDtl.ProfilePhoto=strPicURl;
            
            NSString *query= [NSString stringWithFormat:@"update tbl_profile set image='%@' where cid='%@'", strPicURl , [userDefault objectForKey:@"ID"] ];
            
            [Database executeQuery:query];
            NSLog(@"Data Updated!");
            
            if (appDelegate.isLogo) {
                 appDelegate.isLogo=NO;
                 [self uploadLogo];
            }
            else
            {
                
//                if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//                {
//                    ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                    vcContact.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:vcContact animated:YES];
//                    
//                }
//                else
//                {
//                    UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                    vcIntro.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:vcIntro animated:YES];
//                }
                UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
                
                UINavigationController *navVc = (UINavigationController *)keyWindow.rootViewController;
                [navVc popViewControllerAnimated:YES];

                
                
            }
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
            
        } onProgress:^(float progressInPercent) {
            
        }];
        
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
    
}
-(void)uploadLogo{
    
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSData *dataOfImg=[userDefault objectForKey:@"logoImagedata"];
        
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"action=logo&version=1.14&id=%@&password=%@&afile=afile",[userDefault objectForKey:@"ID"],[userDefault objectForKey:@"Salt"]];
        Webservice *service=[[Webservice alloc]init];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"logo" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        [service callPOSTWebServiceWithImage:dataOfImg andParams:dict isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hidHud];
            [userDefault setObject:[dict objectForKey:@"Filename"] forKey:@"logoname"];
            
            NSString *query= [NSString stringWithFormat:@"update tbl_profile set logo='%@' where cid='%@'", [dict objectForKey:@"Filename"] , [userDefault objectForKey:@"ID"] ];
            
            [Database executeQuery:query];
            NSLog(@"Data Updated!");
            
//            if([[userDefault valueForKey:@"isFromContact"]isEqualToString:@"1"])
//            {
//                ContactViewController *vcContact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
//                vcContact.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:vcContact animated:YES];
//                
//            }
//            else
//            {
//                UIViewController *vcIntro=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
//                vcIntro.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:vcIntro animated:YES];
//            }

            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            
            UINavigationController *navVc = (UINavigationController *)keyWindow.rootViewController;
            [navVc popViewControllerAnimated:YES];

            
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
            
        } onProgress:^(float progressInPercent) {
            
        }];
        
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
    
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/*-(void)webservice
{
    //    NSString *parameter;
    
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    if (![userDefault objectForKey:@"isFirstTime"]) {
        
        [dict setObject:@"new" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        
        [dict setObject:[arrUserDetail valueForKey:@"first_name"] forKey:@"given_name"];
        [dict setObject:[arrUserDetail valueForKey:@"last_name"] forKey:@"family_name"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_mobile_phone"] forKey:@"home_mobile_phone"];
        
        
        [dict setObject:[arrUserDetail valueForKey:@"home_phone"] forKey:@"home_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"home_phone2"] forKey:@"home_phone2"];
        
        
        [dict setObject:[arrUserDetail valueForKey:@"home_email"] forKey:@"home_email"];
        [dict setObject:[arrUserDetail valueForKey:@"home_www"] forKey:@"home_www"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_address1"] forKey:@"home_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"home_address2"] forKey:@"home_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"home_address3"] forKey:@"home_address3"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_suburb"] forKey:@"home_suburb"];
        [dict setObject:[arrUserDetail valueForKey:@"home_city"] forKey:@"home_city"];
        [dict setObject:[arrUserDetail valueForKey:@"home_state"] forKey:@"home_state"];
        [dict setObject:[arrUserDetail valueForKey:@"home_country"] forKey:@"home_country"];
        [dict setObject:[arrUserDetail valueForKey:@"home_post_code"] forKey:@"home_post_code"];
        
        [dict setObject:[arrUserDetail valueForKey:@"company"] forKey:@"company"];
        [dict setObject:[arrUserDetail valueForKey:@"title"] forKey:@"title"];
        
        [dict setObject:[arrUserDetail valueForKey:@"work_mobile_phone"] forKey:@"work_mobile_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"work_phone"] forKey:@"work_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"work_phone2"] forKey:@"work_phone2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_email"] forKey:@"work_email"];
        [dict setObject:[arrUserDetail valueForKey:@"website"] forKey:@"website"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address1"] forKey:@"work_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
        [dict setObject:[arrUserDetail valueForKey:@"work_suburb"] forKey:@"work_suburb"];
        [dict setObject:[arrUserDetail valueForKey:@"work_city"] forKey:@"work_city"];
        [dict setObject:[arrUserDetail valueForKey:@"work_state"] forKey:@"work_state"];
        [dict setObject:[arrUserDetail valueForKey:@"work_country"] forKey:@"work_country"];
        [dict setObject:[arrUserDetail valueForKey:@"work_post_code"] forKey:@"work_post_code"];
        
        
        
        /*[dict setObject:userDtl.homePhone forKey:@"home_phone"];
         [dict setObject:@"" forKey:@"home_phone2"];
         
         
         [dict setObject:userDtl.homeEmail forKey:@"home_email"];
         [dict setObject:@"" forKey:@"home_www"];
         
         [dict setObject:userDtl.homeAddress forKey:@"home_address1"];
         [dict setObject:@"" forKey:@"home_address2"];
         [dict setObject:@"" forKey:@"home_address3"];
         
         [dict setObject:userDtl.homeStreet forKey:@"home_suburb"];
         [dict setObject:userDtl.homeCity forKey:@"home_city"];
         [dict setObject:userDtl.homeState forKey:@"home_state"];
         [dict setObject:userDtl.homeCountry forKey:@"home_country"];
         [dict setObject:userDtl.homePostCode forKey:@"home_post_code"];
         
         [dict setObject:userDtl.companyName forKey:@"company"];
         [dict setObject:userDtl.title forKey:@"title"];
         
         [dict setObject:userDtl.officeMobilenumber forKey:@"work_mobile_phone"];
         [dict setObject:userDtl.officePhonenumber forKey:@"work_phone"];
         [dict setObject:@"" forKey:@"work_phone2"];
         
         [dict setObject:userDtl.officeEmail forKey:@"work_email"];
         [dict setObject:userDtl.Website forKey:@"work_www"];
         [dict setObject:userDtl.officeAddress forKey:@"work_address1"];
         [dict setObject:@"" forKey:@"work_address2"];
         [dict setObject:@"" forKey:@"work_address3"];
         [dict setObject:userDtl.officeStreet forKey:@"work_suburb"];
         [dict setObject:userDtl.officeCity forKey:@"work_city"];
         [dict setObject:userDtl.officeState forKey:@"work_state"];
         [dict setObject:userDtl.officeCountry forKey:@"work_country"];
         [dict setObject:userDtl.officePostCode forKey:@"work_post_code"]; //
        
        NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
        
        //fbid
        if([[userDefault objectForKey:@"LoginType"] isEqualToString:@"fbLogin"])
        {
            
            tmpDict=[userDefault objectForKey:@"FBData"];
            [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"fbid"];
        }
        else if([[userDefault objectForKey:@"LoginType"] isEqualToString:@"googleLogin"])
        {
            NSDictionary *tmpDict=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"GoogleData"]];
            [dict setObject:[tmpDict valueForKey:@"Google_Id"] forKey:@"fbid"];
        }
        else
        {
            [dict setObject:@"" forKey:@"fbid"];
        }
        
        //social
        if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
            
            [dict setObject:[tmpDict objectForKey:@"fbid"] forKey:@"social_facebook"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_facebook"];
        }
        
        if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
            [dict setObject:[userDefault objectForKey:@"twId"] forKey:@"social_twitter"];
        }
        else
        {
            [dict setObject:@"" forKey:@"social_twitter"];
        }
        
        if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
            
            //            [dict setObject:[userDefault objectForKey:@"LinkedInValue"] forKey:@"social_linkedin"];
            [dict setObject:[userDefault objectForKey:@"linkedIn_url"] forKey:@"social_linkedin"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_linkedin"];
        }
        
        [dict setObject:SAFESTRING([userDefault objectForKey:@"skypeId"]) forKey:@"social_skype"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"cardLayout"]) forKey:@"bizcard"];
        
    }
    else
    {
        //        parameter = [NSString stringWithFormat:@"action=update&version=1.14&id=%@&given_name=%@&family_name=%@&mobile_phone=%@&desk_phone=%@&home_phone=%@&email=%@&company=%@&title=%@&address1=%@&address2=%@&address3=%@&suburb=%@&post_code=%@&city=%@&state=%@&country=%@&password=%@",[userDefault objectForKey:@"ID"],txtFirstName.text , txtLastName.text , txtMobile.text , txtWorkContact.text , txtHomeContact.text , txtEmailAddress.text , txtCompany.text , txtTitle.text , txtAddress1.text , txtAddress2.text , txtAddress3.text , txtSuburb.text , txtPostCode.text , txtCity.text , txtState.text , txtCountry.text , [userDefault objectForKey:@"Salt"] ]; //Parameter values from user.
        
        
        
        [dict setObject:@"update" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[arrUserDetail valueForKey:@"first_name"] forKey:@"given_name"];
        [dict setObject:[arrUserDetail valueForKey:@"last_name"] forKey:@"family_name"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_mobile_phone"] forKey:@"home_mobile_phone"];
        
        
        [dict setObject:[arrUserDetail valueForKey:@"home_phone"] forKey:@"home_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"home_phone2"] forKey:@"home_phone2"];
        
        
        [dict setObject:[arrUserDetail valueForKey:@"home_email"] forKey:@"home_email"];
        [dict setObject:[arrUserDetail valueForKey:@"home_www"] forKey:@"home_www"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_address1"] forKey:@"home_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"home_address2"] forKey:@"home_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"home_address3"] forKey:@"home_address3"];
        
        [dict setObject:[arrUserDetail valueForKey:@"home_suburb"] forKey:@"home_suburb"];
        [dict setObject:[arrUserDetail valueForKey:@"home_city"] forKey:@"home_city"];
        [dict setObject:[arrUserDetail valueForKey:@"home_state"] forKey:@"home_state"];
        [dict setObject:[arrUserDetail valueForKey:@"home_country"] forKey:@"home_country"];
        [dict setObject:[arrUserDetail valueForKey:@"home_post_code"] forKey:@"home_post_code"];
        
        [dict setObject:[arrUserDetail valueForKey:@"company"] forKey:@"company"];
        [dict setObject:[arrUserDetail valueForKey:@"title"] forKey:@"title"];
        
        [dict setObject:[arrUserDetail valueForKey:@"work_mobile_phone"] forKey:@"work_mobile_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"work_phone"] forKey:@"work_phone"];
        [dict setObject:[arrUserDetail valueForKey:@"work_phone2"] forKey:@"work_phone2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_email"] forKey:@"work_email"];
        [dict setObject:[arrUserDetail valueForKey:@"website"] forKey:@"website"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address1"] forKey:@"work_address1"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address2"] forKey:@"work_address2"];
        [dict setObject:[arrUserDetail valueForKey:@"work_address3"] forKey:@"work_address3"];
        [dict setObject:[arrUserDetail valueForKey:@"work_suburb"] forKey:@"work_suburb"];
        [dict setObject:[arrUserDetail valueForKey:@"work_city"] forKey:@"work_city"];
        [dict setObject:[arrUserDetail valueForKey:@"work_state"] forKey:@"work_state"];
        [dict setObject:[arrUserDetail valueForKey:@"work_country"] forKey:@"work_country"];
        [dict setObject:[arrUserDetail valueForKey:@"work_post_code"] forKey:@"work_post_code"];
        
        
        /* [dict setObject:userDtl.homePhone forKey:@"home_phone"];
         [dict setObject:@"" forKey:@"home_phone2"];
         
         
         [dict setObject:userDtl.homeEmail forKey:@"home_email"];
         [dict setObject:@"" forKey:@"home_www"];
         
         [dict setObject:userDtl.homeAddress forKey:@"home_address1"];
         [dict setObject:@"" forKey:@"home_address2"];
         [dict setObject:@"" forKey:@"home_address3"];
         
         [dict setObject:userDtl.homeStreet forKey:@"home_suburb"];
         [dict setObject:userDtl.homeCity forKey:@"home_city"];
         [dict setObject:userDtl.homeState forKey:@"home_state"];
         [dict setObject:userDtl.homeCountry forKey:@"home_country"];
         [dict setObject:userDtl.homePostCode forKey:@"home_post_code"];
         
         [dict setObject:userDtl.companyName forKey:@"company"];
         [dict setObject:userDtl.title forKey:@"title"];
         
         [dict setObject:userDtl.officeMobilenumber forKey:@"work_mobile_phone"];
         [dict setObject:userDtl.officePhonenumber forKey:@"work_phone"];
         [dict setObject:@"" forKey:@"work_phone2"];
         
         [dict setObject:userDtl.officeEmail forKey:@"work_email"];
         [dict setObject:userDtl.Website forKey:@"work_www"];
         [dict setObject:userDtl.officeAddress forKey:@"work_address1"];
         [dict setObject:@"" forKey:@"work_address2"];
         [dict setObject:@"" forKey:@"work_address3"];
         [dict setObject:userDtl.officeStreet forKey:@"work_suburb"];
         [dict setObject:userDtl.officeCity forKey:@"work_city"];
         [dict setObject:userDtl.officeState forKey:@"work_state"];
         [dict setObject:userDtl.officeCountry forKey:@"work_country"];
         [dict setObject:userDtl.officePostCode forKey:@"work_post_code"]; //
        
        
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"id"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        
        if ([[userDefault objectForKey:@"isFacebook"] isEqualToString:@"1"]) {
            
            NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
            [dict setObject:[dictFB objectForKey:@"fbid"] forKey:@"social_facebook"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_facebook"];
        }
        
        if ([[userDefault objectForKey:@"isTwitter"] isEqualToString:@"1"]) {
            [dict setObject:[userDefault objectForKey:@"twId"] forKey:@"social_twitter"];
        }
        else
        {
            [dict setObject:@"" forKey:@"social_twitter"];
        }
        
        if ([[userDefault objectForKey:@"isLinkedIn"] isEqualToString:@"1"]) {
            
            //            [dict setObject:[userDefault objectForKey:@"LinkedInValue"] forKey:@"social_linkedin"];
            [dict setObject:[userDefault objectForKey:@"linkedIn_url"] forKey:@"social_linkedin"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"social_linkedin"];
        }
        
        [dict setObject:SAFESTRING([userDefault objectForKey:@"skypeId"]) forKey:@"social_skype"];
        [dict setObject:SAFESTRING([userDefault objectForKey:@"cardLayout"]) forKey:@"bizcard"];
        
    }
    NSLog(@"%@",dict);
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        Webservice *service = [[Webservice alloc]init];
        [service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ]) {
                
                if (![userDefault objectForKey:@"isFirstTime"]) {
                    
                    [userDefault setObject:[dict objectForKey:@"ID"] forKey:@"ID"];
                    [userDefault setObject:[dict objectForKey:@"Salt"] forKey:@"Salt"];
                    // NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc]init];
                    
                    /* [tmpDict setObject:[userDefault objectForKey:@"ID"] forKey:@"cid"];
                     [tmpDict setObject:self.txtFirstname.text forKey:@"first_name"];
                     [tmpDict setObject:self.txtLastname.text forKey:@"last_name"];
                     
                     NSString *strConatct=[self.txtMobileNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                     [tmpDict setObject:strConatct forKey:@"home_mobile_phone"];
                     
                     [tmpDict setObject:userDtl.homePhone forKey:@"home_phone"];
                     [tmpDict setObject:@"" forKey:@"home_phone2"];
                     
                     
                     [tmpDict setObject:userDtl.homeEmail forKey:@"home_email"];
                     [tmpDict setObject:@"" forKey:@"home_www"];
                     
                     [tmpDict setObject:userDtl.homeAddress forKey:@"home_address1"];
                     [tmpDict setObject:@"" forKey:@"home_address2"];
                     [tmpDict setObject:@"" forKey:@"home_address3"];
                     
                     [tmpDict setObject:userDtl.homeStreet forKey:@"home_suburb"];
                     [tmpDict setObject:userDtl.homeCity forKey:@"home_city"];
                     [tmpDict setObject:userDtl.homeState forKey:@"home_state"];
                     [tmpDict setObject:userDtl.homeCountry forKey:@"home_country"];
                     [tmpDict setObject:userDtl.homePostCode forKey:@"home_post_code"];
                     
                     [tmpDict setObject:userDtl.companyName forKey:@"company"];
                     [tmpDict setObject:userDtl.title forKey:@"title"];
                     
                     [tmpDict setObject:userDtl.officeMobilenumber forKey:@"work_mobile_phone"];
                     [tmpDict setObject:userDtl.officePhonenumber forKey:@"work_phone"];
                     [tmpDict setObject:@"" forKey:@"work_phone2"];
                     
                     [tmpDict setObject:userDtl.officeEmail forKey:@"work_email"];
                     [tmpDict setObject:userDtl.Website forKey:@"work_www"];
                     [tmpDict setObject:userDtl.officeAddress forKey:@"work_address1"];
                     [tmpDict setObject:@"" forKey:@"work_address2"];
                     [tmpDict setObject:@"" forKey:@"work_address3"];
                     [tmpDict setObject:userDtl.officeStreet forKey:@"work_suburb"];
                     [tmpDict setObject:userDtl.officeCity forKey:@"work_city"];
                     [tmpDict setObject:userDtl.officeState forKey:@"work_state"];
                     [tmpDict setObject:userDtl.officeCountry forKey:@"work_country"];
                     [tmpDict setObject:userDtl.officePostCode forKey:@"work_post_code"];
                     
                     
                     NSDictionary *dictFB=[NSDictionary dictionaryWithDictionary:[userDefault objectForKey:@"FBData"]];
                     
                     [tmpDict setObject:SAFESTRING([dictFB objectForKey:@"fbid"]) forKey:@"facebook"];
                     [tmpDict setObject:SAFESTRING([userDefault objectForKey:@"twId"]) forKey:@"twitter"];
                     [tmpDict setObject:SAFESTRING([userDefault objectForKey:@"linkedIn_url"]) forKey:@"linkedIn"];
                     [tmpDict setObject:@"" forKey:@"skype"];
                     
                     //  NSLog(@"%@",tmpDict);
                     //  [Database insert:@"tbl_profile" data:tmpDict]; //
                    
                    NSString *insertQuery=[NSString stringWithFormat:@"insert into tbl_profile (layout('%@','%@')",[NSString stringWithFormat:@"%ld",(long)intCard], [userDefault objectForKey:@"ID"]];
                    
                    if([Database executeScalerQuery:insertQuery])
                    {
                        NSLog(@"Data Inserted!");
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    NSString *query= [NSString stringWithFormat:@"update tbl_profile set layout='%@' where cid='%@'",[NSString stringWithFormat:@"%ld",(long)intCard], [userDefault objectForKey:@"ID"]];
                    
                    [Database executeQuery:query];
                    NSLog(@"Data Updated!");
                    
                }
                
                //[userDefault setObject:@"1" forKey:@"isFirstTime"];
                [userDefault setObject:@"1" forKey:@"isRegistered"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                UIViewController *vcHome=[self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
                [self.navigationController pushViewController:vcHome animated:YES];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:@"Nothing to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
} */


@end
