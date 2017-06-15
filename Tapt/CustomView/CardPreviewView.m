//
//  CardPreviewView.m
//  Tapt
//
//  Created by Parth on 01/06/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "CardPreviewView.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extensions.h"
#import "ProfileViewController.h"

@implementation CardPreviewView

@synthesize viewLayout1,viewLayout2,viewLayout3,viewLayout4;
@synthesize imgLogo;
//layout1
@synthesize lblName,lblEmail,lblMobile,lblTitle,lblWebsite;
@synthesize imgProfilePic;
//layout2
@synthesize lblName2,lblEmail2,lblMobile2,lblTitle2,lblWebsite2,lblAddress1,lblAddress2,lblAddress3,lblStatePostcode;
//layout3
@synthesize lblName3,lblEmail3,lblMobile3,lblTitle3,lblWebsite3;
@synthesize imgLogo3;

//layout4
@synthesize lblName4,lblEmail4,lblMobile4,lblTitle4,lblWebsite4;
@synthesize imgLogo4;
@synthesize viewHeaderBG;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    self.btnOk.layer.cornerRadius=self.btnOk.frame.size.height/2;
    self.btnOk.layer.masksToBounds=YES;
    self.btnOk.layer.borderWidth = 1;
    self.btnOk.layer.borderColor = [UIColor whiteColor].CGColor;
 
     UserDetail *userDtl=[UserDetail sharedInstance];
     NSLog(@"%@",userDtl);
    
    if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"1"]) {
        
        lblName.text=[NSString stringWithFormat:@"%@ %@",userDtl.firstName,userDtl.lastName];
        
        if ([userDtl.MobileNumber isEqualToString:@""]) {  //mobile
            lblMobile.text=@"--";
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter(userDtl.MobileNumber, filter);
            lblMobile.text=strContact;
            //            lblMobile.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([userDtl.officeEmail isEqualToString:@""]) {
            lblEmail.text=@"--";
        }
        else
        {
            lblEmail.text=userDtl.officeEmail;
        }
        
        if ([userDtl.Website isEqualToString:@""]) {  //website
            lblWebsite.text=@"--";
        }
        else
        {
            lblWebsite.text=userDtl.Website;
        }
        
        if ([userDtl.title isEqualToString:@""]) {
            lblTitle.text=@"--";
        }
        else
        {
            lblTitle.text=userDtl.title;
        }
        
        if ([[userDefault objectForKey:@"picname"] isEqualToString:@""]) {
            imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[userDefault objectForKey:@"picname"];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
        if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
        imgProfilePic.layer.masksToBounds=YES;
        imgProfilePic.layer.borderWidth=0;
        
        viewLayout1.hidden=NO;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=YES;
    }
    else if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"2"]){
        
        lblName2.text=[NSString stringWithFormat:@"%@ %@",userDtl.firstName,userDtl.lastName];
       
        
        if ([userDtl.MobileNumber isEqualToString:@""]) {
            lblMobile2.text=@"--";
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter(userDtl.MobileNumber, filter);
            lblMobile2.text=strContact;
            
            //            lblMobile2.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([userDtl.officeEmail isEqualToString:@""]) {
            lblEmail2.text=@"--";
        }
        else
        {
            lblEmail2.text=userDtl.officeEmail;
        }
        
        if ([userDtl.Website isEqualToString:@""]) { //website
            lblWebsite2.text=@"--";
        }
        else
        {
            lblWebsite2.text=userDtl.Website;
        }
        
        if ([userDtl.title isEqualToString:@""]) {
            lblTitle2.text=@"--";
        }
        else
        {
            lblTitle2.text=userDtl.title;
        }
        
        if ([userDtl.homeAddress isEqualToString:@""]) { //address1
            lblAddress1.text=@"--";
        }
        else
        {
            lblAddress1.text=userDtl.homeAddress;
        }
        
        if ([userDtl.officeAddress isEqualToString:@""]) { //address2
            lblAddress2.text=@"--";
        }
        else
        {
            lblAddress2.text=userDtl.officeAddress;
        }
        
        if ([[userDefault objectForKey:@"address3"] isEqualToString:@""]) {
            lblAddress3.text=@"--";
        }
        else
        {
            //lblAddress3.text=[userDefault objectForKey:@"address3"];
            lblAddress3.text=@"--";
        }
        
        NSString *strState;//postcode
        //        state
        if ([userDtl.officeState isEqualToString:@""]) {  //state
            strState=@"--";
        }
        else
        {
            strState=userDtl.officeState;
        }
        
        if ([userDtl.officePostCode isEqualToString:@""]) { //postcode
            lblStatePostcode.text=[NSString stringWithFormat:@"%@/--",userDtl.officePostCode];
        }
        else
        {
            lblStatePostcode.text=[NSString stringWithFormat:@"%@/%@",strState,userDtl.officePostCode];
        }
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=NO;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=YES;
    }
    else if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"3"]){
        
        lblName3.text=[NSString stringWithFormat:@"%@ %@",userDtl.firstName,userDtl.lastName];
        
        if ([userDtl.MobileNumber isEqualToString:@""]) {  //mobile
            lblMobile3.text=@"--";
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter(userDtl.MobileNumber, filter);
            lblMobile3.text=strContact;
            
            //            lblMobile3.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([userDtl.officeEmail isEqualToString:@""]) {
            lblEmail3.text=@"--";
        }
        else
        {
            lblEmail3.text=userDtl.officeEmail;
        }
        
        if ([userDtl.Website isEqualToString:@""]) { //website
            lblWebsite3.text=@"--";
        }
        else
        {
            lblWebsite3.text=userDtl.Website;
        }
        
        if ([userDtl.title isEqualToString:@""]) {
            lblTitle3.text=@"--";
        }
        else
        {
            lblTitle3.text=userDtl.title;
        }
        
        
        if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=NO;
        viewLayout4.hidden=YES;
    }
    else if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"4"]){
        
        lblName4.text=[NSString stringWithFormat:@"%@ %@",userDtl.firstName,userDtl.lastName];
    
        
        if ([userDtl.MobileNumber isEqualToString:@""]) { //mobile
            lblMobile4.text=@"--";
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter(userDtl.MobileNumber, filter);
            lblMobile4.text=strContact;
            //            lblMobile4.text=[userDefault objectForKey:@"mobile"];
        }
        
        if ([userDtl.officeEmail isEqualToString:@""]) {
            lblEmail4.text=@"--";
        }
        else
        {
            lblEmail4.text=userDtl.officeEmail;
        }
        
        if ([userDtl.Website isEqualToString:@""]) {
            lblWebsite4.text=@"--";
        }
        else
        {
            lblWebsite4.text=userDtl.Website;
        }
        
        if ([userDtl.title isEqualToString:@""]) {
            lblTitle4.text=@"--";
        }
        else
        {
            lblTitle4.text=userDtl.title;
        }
        
        if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo4 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        viewHeaderBG.layer.cornerRadius=30;
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=NO;
    }
    
}

-(void) hideView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha=0.0f;
    }];
  
    if ([self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}

-(void) showInView:(UIView *) superView
{
    //    lblEventName.text=[dictFlyerDetail objectForKey:@"Flyer_name"];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    //
    //    double timeStamp=[[dictFlyerDetail objectForKey:@"Flyer_start_date"] doubleValue];
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    //    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    //    lblEventDate.text=formattedDateString;
    
    
    
    self.alpha=1.0f;
//    self.center=superView.center;
    self.userInteractionEnabled = YES;
    
    
    [superView addSubview:self];
    
    
//    self.viewSubDialoge.transform=CGAffineTransformMakeScale(0.0f, 0.0f);
//    [UIView animateWithDuration:0.3f animations:^{
//        self.viewSubDialoge.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15f animations:^{
//            self.viewSubDialoge.transform=CGAffineTransformMakeScale(0.9f, 0.9f);
//        }completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.15 animations:^{
//                self.viewSubDialoge.transform=CGAffineTransformMakeScale(0.8f, 0.8f);
//            }];
//        }];
//    }];
}


-(IBAction)btnCloseAction:(id)sender{
    [self hideView];
}

- (IBAction)btnOkAction:(id)sender {
    [self hideView];

}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
//old code
/*
if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"1"]) {
    
    lblName.text=[NSString stringWithFormat:@"%@ %@",[userDefault objectForKey:@"first_name"],[userDefault objectForKey:@"last_name"]];
    
    if ([[userDefault objectForKey:@"mobile_phone"] isEqualToString:@""]) {  //mobile
        lblMobile.text=@"--";
    }
    else
    {
        NSString *filter = @"### ### ####";
        
        NSString *strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"mobile_phone"], filter);
        lblMobile.text=strContact;
        //            lblMobile.text=[userDefault objectForKey:@"mobile"];
    }
    
    if ([[userDefault objectForKey:@"email"] isEqualToString:@""]) {
        lblEmail.text=@"--";
    }
    else
    {
        lblEmail.text=[userDefault objectForKey:@"email"];
    }
    
    if ([[userDefault objectForKey:@"officeWebsite"] isEqualToString:@""]) {  //website
        lblWebsite.text=@"--";
    }
    else
    {
        lblWebsite.text=[userDefault objectForKey:@"officeWebsite"];
    }
    
    if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
        lblTitle.text=@"--";
    }
    else
    {
        lblTitle.text=[userDefault objectForKey:@"title"];
    }
    
    if ([[userDefault objectForKey:@"picname"] isEqualToString:@""]) {
        imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
    }
    else
    {
        NSString *strImgUrl=[userDefault objectForKey:@"picname"];
        strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *url=[NSURL URLWithString:strImgUrl];
        [imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
    }
    
    if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
        
    }
    else
    {
        NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
        strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *url=[NSURL URLWithString:strImgUrl];
        [imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    }
    
    imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
    imgProfilePic.layer.masksToBounds=YES;
    imgProfilePic.layer.borderWidth=0;
    
    viewLayout1.hidden=NO;
    viewLayout2.hidden=YES;
    viewLayout3.hidden=YES;
    viewLayout4.hidden=YES;
}
else if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"2"]){
    
    lblName2.text=[NSString stringWithFormat:@"%@ %@",[userDefault objectForKey:@"first_name"],[userDefault objectForKey:@"last_name"]];
    //        lblMobile2.text=[userDefault objectForKey:@"mobile"];
    //        lblEmail2.text=[userDefault objectForKey:@"email"];
    //        lblWebsite2.text=[userDefault objectForKey:@"website"];
    //        lblTitle2.text=[userDefault objectForKey:@"title"];
    
    if ([[userDefault objectForKey:@"mobile_phone"] isEqualToString:@""]) {
        lblMobile2.text=@"--";
    }
    else
    {
        NSString *filter = @"### ### ####";
        
        NSString *strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"mobile_phone"], filter);
        lblMobile2.text=strContact;
        
        //            lblMobile2.text=[userDefault objectForKey:@"mobile"];
    }
    
    if ([[userDefault objectForKey:@"email"] isEqualToString:@""]) {
        lblEmail2.text=@"--";
    }
    else
    {
        lblEmail2.text=[userDefault objectForKey:@"email"];
    }
    
    if ([[userDefault objectForKey:@"officeWebsite"] isEqualToString:@""]) { //website
        lblWebsite2.text=@"--";
    }
    else
    {
        lblWebsite2.text=[userDefault objectForKey:@"officeWebsite"];
    }
    
    if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
        lblTitle2.text=@"--";
    }
    else
    {
        lblTitle2.text=[userDefault objectForKey:@"title"];
    }
    
    if ([[userDefault objectForKey:@"homeAddress"] isEqualToString:@""]) { //address1
        lblAddress1.text=@"--";
    }
    else
    {
        lblAddress1.text=[userDefault objectForKey:@"homeAddress"];
    }
    
    if ([[userDefault objectForKey:@"officeAddress"] isEqualToString:@""]) { //address2
        lblAddress2.text=@"--";
    }
    else
    {
        lblAddress2.text=[userDefault objectForKey:@"officeAddress"];
    }
    
    if ([[userDefault objectForKey:@"address3"] isEqualToString:@""]) {
        lblAddress3.text=@"--";
    }
    else
    {
        //lblAddress3.text=[userDefault objectForKey:@"address3"];
        lblAddress3.text=@"--";
    }
    
    NSString *strState;//postcode
    //        state
    if ([[userDefault objectForKey:@"homeState"] isEqualToString:@""]) {  //state
        strState=@"--";
    }
    else
    {
        strState=[userDefault objectForKey:@"homeState"];
    }
    
    if ([[userDefault objectForKey:@"homePostcode"] isEqualToString:@""]) { //postcode
        lblStatePostcode.text=[NSString stringWithFormat:@"%@/--",strState];
    }
    else
    {
        lblStatePostcode.text=[NSString stringWithFormat:@"%@/%@",strState,[userDefault objectForKey:@"homePostcode"]];
    }
    
    viewLayout1.hidden=YES;
    viewLayout2.hidden=NO;
    viewLayout3.hidden=YES;
    viewLayout4.hidden=YES;
}
else if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"3"]){
    
    lblName3.text=[NSString stringWithFormat:@"%@ %@",[userDefault objectForKey:@"first_name"],[userDefault objectForKey:@"last_name"]];
    //        lblMobile3.text=[userDefault objectForKey:@"mobile"];
    //        lblEmail3.text=[userDefault objectForKey:@"email"];
    //        lblWebsite3.text=[userDefault objectForKey:@"website"];
    //        lblTitle3.text=[userDefault objectForKey:@"title"];
    
    if ([[userDefault objectForKey:@"mobile_phone"] isEqualToString:@""]) {  //mobile
        lblMobile3.text=@"--";
    }
    else
    {
        NSString *filter = @"### ### ####";
        
        NSString *strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"mobile_phone"], filter);
        lblMobile3.text=strContact;
        
        //            lblMobile3.text=[userDefault objectForKey:@"mobile"];
    }
    
    if ([[userDefault objectForKey:@"email"] isEqualToString:@""]) {
        lblEmail3.text=@"--";
    }
    else
    {
        lblEmail3.text=[userDefault objectForKey:@"email"];
    }
    
    if ([[userDefault objectForKey:@"officeWebsite"] isEqualToString:@""]) { //website
        lblWebsite3.text=@"--";
    }
    else
    {
        lblWebsite3.text=[userDefault objectForKey:@"officeWebsite"];
    }
    
    if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
        lblTitle3.text=@"--";
    }
    else
    {
        lblTitle3.text=[userDefault objectForKey:@"title"];
    }
    
    
    if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
        
    }
    else
    {
        NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
        strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *url=[NSURL URLWithString:strImgUrl];
        [imgLogo3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    }
    
    
    viewLayout1.hidden=YES;
    viewLayout2.hidden=YES;
    viewLayout3.hidden=NO;
    viewLayout4.hidden=YES;
}
else if ([[userDefault objectForKey:@"cardLayout"] isEqualToString:@"4"]){
    
    lblName4.text=[NSString stringWithFormat:@"%@ %@",[userDefault objectForKey:@"first_name"],[userDefault objectForKey:@"last_name"]];
    //        lblMobile4.text=[userDefault objectForKey:@"mobile"];
    //        lblEmail4.text=[userDefault objectForKey:@"email"];
    //        lblWebsite4.text=[userDefault objectForKey:@"website"];
    //        lblTitle4.text=[userDefault objectForKey:@"title"];
    
    if ([[userDefault objectForKey:@"mobile_phone"] isEqualToString:@""]) { //mobile
        lblMobile4.text=@"--";
    }
    else
    {
        NSString *filter = @"### ### ####";
        
        NSString *strContact=filteredPhoneStringFromStringWithFilter([userDefault objectForKey:@"mobile_phone"], filter);
        lblMobile4.text=strContact;
        //            lblMobile4.text=[userDefault objectForKey:@"mobile"];
    }
    
    if ([[userDefault objectForKey:@"email"] isEqualToString:@""]) {
        lblEmail4.text=@"--";
    }
    else
    {
        lblEmail4.text=[userDefault objectForKey:@"email"];
    }
    
    if ([[userDefault objectForKey:@"officeWebsite"] isEqualToString:@""]) {
        lblWebsite4.text=@"--";
    }
    else
    {
        lblWebsite4.text=[userDefault objectForKey:@"officeWebsite"];
    }
    
    if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
        lblTitle4.text=@"--";
    }
    else
    {
        lblTitle4.text=[userDefault objectForKey:@"title"];
    }
    
    if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
        
    }
    else
    {
        NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[userDefault objectForKey:@"logoname"]];
        strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *url=[NSURL URLWithString:strImgUrl];
        [imgLogo4 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    }
    
    viewHeaderBG.layer.cornerRadius=30;
    
    viewLayout1.hidden=YES;
    viewLayout2.hidden=YES;
    viewLayout3.hidden=YES;
    viewLayout4.hidden=NO;
} */

@end
