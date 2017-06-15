//
//  IntroPageViewController.m
//  Tapt
//
//  Created by TriState  on 6/19/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "IntroPageViewController.h"

@interface IntroPageViewController ()

@end

@implementation IntroPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
    self.widthConstForImg.constant=width;
    self.widthConstForView.constant=width*4;
    [self.view setNeedsUpdateConstraints];
    
     [Database createEditableCopyOfDatabaseIfNeeded];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"isFromHelp"]isEqualToString:@"1"])
    {
        self.btnBack.hidden=NO;
    }
    else
    {
        self.btnBack.hidden=YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    flagMenuopen=1;
    [self btnSettingAction:nil];
    
}
#pragma mark - Scrollview Delegate Method -

- (void)scrollViewDidScroll:(UIScrollView *)scrollV
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = self.scrIntro.frame.size.width;
    float fractionalPage = self.scrIntro.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page)
    {
        self.pgctrlIntro.currentPage = page;
        previousPage = page;
    }
    
    CGFloat fHeight = CGRectGetHeight([self.scrIntro bounds]);
    
    if (self.scrIntro.contentOffset.x <=-20) {
        [self.scrIntro scrollRectToVisible:CGRectMake(pageWidth*4,0,pageWidth,fHeight) animated:NO];
    }
    
   }

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = self.scrIntro.frame.size.width;
    
    CGFloat fWidth = CGRectGetWidth([self.scrIntro bounds]);
    CGFloat fHeight = CGRectGetHeight([self.scrIntro bounds]);
    
    if (self.scrIntro.contentOffset.x <=0) {
        [self.scrIntro scrollRectToVisible:CGRectMake(fWidth*4,0,fWidth,fHeight) animated:NO];
    }
    
    if(self.scrIntro.contentOffset.x >= fWidth*4)
    {
        [self.scrIntro scrollRectToVisible:CGRectMake(0,0,fWidth,fHeight) animated:NO];
       
    }
    
}



-(IBAction)changePageAction:(id)sender
{
    NSInteger page = self.pgctrlIntro.currentPage;
    CGRect frame = self.scrIntro.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    
    [self.scrIntro scrollRectToVisible:frame animated:YES];
}
- (IBAction)btnPersonTabAction:(id)sender {
    
    [userDefault setObject:@"0" forKey:@"isFromContact"];
    
    
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
    [self.navigationController pushViewController:vcProfiletab animated:YES];
    
}

- (IBAction)btnSendTabAction:(id)sender {
    [userDefault setObject:@"0" forKey:@"isFromContact"];
    SendContactViewController *vcsend=[self.storyboard instantiateViewControllerWithIdentifier:@"SendContactViewController"];
    [self.navigationController pushViewController:vcsend animated:YES];
    
    
}

- (IBAction)btnReceiveTabAction:(id)sender {
    [userDefault setObject:@"0" forKey:@"isFromContact"];
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
   [userDefault setObject:@"0" forKey:@"isFromContact"];
    FavoriteContectViewController *vcFavoriteContact=[self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteContectViewController"];
    [self.navigationController pushViewController:vcFavoriteContact animated:NO];
}
- (IBAction)btnBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
