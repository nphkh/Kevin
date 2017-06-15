//
//  DeleteContactViewController.m
//  Tapt
//
//  Created by TriState  on 7/13/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "DeleteContactViewController.h"

@interface DeleteContactViewController ()

@end

@implementation DeleteContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate setShouldRotate:NO];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480) {
            // 3.5 inch display - iPhone 4S and below
            [self.lblDeleteContect setFont: [self.lblDeleteContect.font fontWithSize:19]];
            [self.lblAllDelete setFont: [self.lblAllDelete.font fontWithSize:15]];
            [self.lblDeleteContact1 setFont: [self.lblDeleteContact1.font fontWithSize:15]];
            [self.lblNo setFont: [self.lblNo.font fontWithSize:14]];
            [self.lblYes setFont: [self.lblYes.font fontWithSize:14]];
            [self.lblcantundo setFont: [self.lblcantundo.font fontWithSize:14]];
        }
        
        else if (result.height == 568) {
            // 4 inch display - iPhone 5
            [self.lblDeleteContect setFont: [self.lblDeleteContect.font fontWithSize:19]];
            [self.lblAllDelete setFont: [self.lblAllDelete.font fontWithSize:16]];
            [self.lblDeleteContact1 setFont: [self.lblDeleteContact1.font fontWithSize:16]];
            [self.lblNo setFont: [self.lblNo.font fontWithSize:15]];
            [self.lblYes setFont: [self.lblYes.font fontWithSize:15]];
            [self.lblcantundo setFont: [self.lblcantundo.font fontWithSize:15]];
        }
        
        else if (result.height == 667) {
            // 4.7 inch display - iPhone 6
            [self.lblDeleteContect setFont: [self.lblDeleteContect.font fontWithSize:19]];
            [self.lblAllDelete setFont: [self.lblAllDelete.font fontWithSize:18]];
            [self.lblDeleteContact1 setFont: [self.lblDeleteContact1.font fontWithSize:18]];
            [self.lblNo setFont: [self.lblNo.font fontWithSize:16]];
            [self.lblYes setFont: [self.lblYes.font fontWithSize:16]];
            [self.lblcantundo setFont: [self.lblcantundo.font fontWithSize:16]];
        }
        
        else if (result.height == 736) {
            // 5.5 inch display - iPhone 6 Plus
            [self.lblDeleteContect setFont: [self.lblDeleteContect.font fontWithSize:19]];
            [self.lblAllDelete setFont: [self.lblAllDelete.font fontWithSize:18]];
            [self.lblDeleteContact1 setFont: [self.lblDeleteContact1.font fontWithSize:18]];
            [self.lblNo setFont: [self.lblNo.font fontWithSize:17]];
            [self.lblYes setFont: [self.lblYes.font fontWithSize:17]];
            [self.lblcantundo setFont: [self.lblcantundo.font fontWithSize:17]];
        }
    }

   self.scrlView.contentSize=self.contentView.frame.size;
    
    [self.sliderDeleteAccount addTarget:self
                        action:@selector(sliderDidEndSlidingForName:)
              forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [self.sliderDeleteAccount setMaximumTrackImage:[UIImage imageNamed:@"sliderbg.png"] forState:UIControlStateNormal];
    [self.sliderDeleteAccount setMinimumTrackImage:[UIImage imageNamed:@"sliderbg.png"] forState:UIControlStateNormal];
   
    [self.sliderDeleteAccount setThumbImage:[UIImage imageNamed:@"sliderThumb.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
-(void)callWebserviceForDeleteAccount
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"deleteAccount" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
         {
             [self hidHud];
             NSLog(@"dict %@",dict);
             if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
             {
//                 NSString *query= [NSString stringWithFormat:@"delete from tbl_profile"];
//                 NSMutableArray *arrResponse=[NSMutableArray arrayWithArray:[Database executeQuery:query]];
//                 NSLog(@"%@",arrResponse);
                 
                 NSString *query1= [NSString stringWithFormat:@"delete from Contact_Detail"];
                 NSMutableArray *arrResponse1=[NSMutableArray arrayWithArray:[Database executeQuery:query1]];
                 NSLog(@"%@",arrResponse1);
                 
                 NSString *query2= [NSString stringWithFormat:@"delete from Categories"];
                 NSMutableArray *arrResponse2=[NSMutableArray arrayWithArray:[Database executeQuery:query2]];
                 NSLog(@"%@",arrResponse2);
                 
                 
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




- (IBAction)switchContactDelete:(id)sender {
    if([sender isOn])
    {
        [self callWebserviceForDeleteAccount];
    }
    else
    {
        NSLog(@"Switch is OFF");
    }

}

- (IBAction)SliderValueChange:(id)sender {
    
//    if (self.sliderDeleteAccount.value==10) {
//        NSLog(@"yes");
//    }
//    else
//    {
//        NSLog(@"no");
//    }
}
- (void)sliderDidEndSlidingForName:(NSNotification *)notification
{
    NSLog(@"slider value %f",self.sliderDeleteAccount.value);
    if (self.sliderDeleteAccount.value>=0 && self.sliderDeleteAccount.value<5) {
        self.sliderDeleteAccount.value=0;
        
    }
    else
    {
         self.sliderDeleteAccount.value=10;
        [self callWebserviceForDeleteAccount];
    }
    
}
- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
/*
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
 }*/

@end
