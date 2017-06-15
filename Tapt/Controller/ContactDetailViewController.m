//
//  ContactDetailViewController.m
//  Tapt
//
//  Created by Pragnesh Dixit on 16/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewViewController.h"
#import <Twitter/Twitter.h>
#import "NotesViewController.h"
//#import "FHSTwitterEngine.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController
@synthesize viewLayout1,viewLayout2,viewLayout3,viewLayout4;
@synthesize imgLogo;

//layout1
@synthesize lblName,lblEmail,lblMobile,lblTitle,lblWebsite;
@synthesize imgProfilePic;
@synthesize imgCallBG,imgCallIcon,imgEmailBG,imgEmailIcon,imgWebsiteBG,imgWebsiteIcon;

//layout2
@synthesize lblName2,lblEmail2,lblMobile2,lblTitle2,lblWebsite2,lblAddress1,lblAddress2,lblAddress3,lblStatePostcode;
@synthesize imgCallBG2,imgCallIcon2,imgEmailBG2,imgEmailIcon2,imgWebsiteBG2,imgWebsiteIcon2;

//layout3
@synthesize lblName3,lblEmail3,lblMobile3,lblTitle3,lblWebsite3;
@synthesize imgLogo3;
@synthesize imgCallBG3,imgCallIcon3,imgEmailBG3,imgEmailIcon3,imgWebsiteBG3,imgWebsiteIcon3;


//layout4
@synthesize lblName4,lblEmail4,lblMobile4,lblTitle4,lblWebsite4;
@synthesize imgLogo4;
@synthesize viewHeaderBG;
@synthesize imgCallBG4,imgCallIcon4,imgEmailBG4,imgEmailIcon4,imgWebsiteBG4,imgWebsiteIcon4;

@synthesize dictContact;
//other detail
@synthesize lblViewHomeEmail,lblViewHomePhone,lblHOmeAddress;

//@synthesize shareKit;
- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    self.viewMoreItem.hidden=YES;
    
    self.viewHomephone.layer.cornerRadius=5.0;
    self.viewHomeMail.layer.cornerRadius=5.0;
    self.viewHomeAddress.layer.cornerRadius=5.0;
    
    //adding gesture to other view
    [self.lblViewOffiecePhoneno setUserInteractionEnabled:YES];
    [self.lblViewOfficeMobileno setUserInteractionEnabled:YES];
    [self.lblViewHomePhone setUserInteractionEnabled:YES];
    [self.lblViewHomeEmail setUserInteractionEnabled:YES];
    [self.lblViewOfficeEmail setUserInteractionEnabled:YES];
    [self.lblViewWebsite setUserInteractionEnabled:YES];
    
  
    
}
//kishan
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate setShouldRotate:NO];
   
    lblMobile.userInteractionEnabled = YES;
    lblMobile2.userInteractionEnabled = YES;
    lblMobile3.userInteractionEnabled = YES;
    lblMobile4.userInteractionEnabled = YES;
    
    lblEmail.userInteractionEnabled=YES;
    lblEmail2.userInteractionEnabled=YES;
    lblEmail3.userInteractionEnabled=YES;
    lblEmail4.userInteractionEnabled=YES;
    
    lblWebsite.userInteractionEnabled=YES;
    lblWebsite2.userInteractionEnabled=YES;
    lblWebsite3.userInteractionEnabled=YES;
    lblWebsite4.userInteractionEnabled=YES;
      
    viewHeaderBG.layer.cornerRadius=30;
    
    
    NSLog(@"%@",dictContact);
    self.lblHeadertext.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
    
    //card data
    if ([[dictContact objectForKey:@"layout"] isEqualToString:@"1"] ||[[dictContact objectForKey:@"layout"] isEqualToString:@"0"] ) {
        
        //add gesture for phone calling
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [lblMobile addGestureRecognizer:tapGesture];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailAction:)];
        [tapGesture1 setDelegate:self];
        [lblEmail addGestureRecognizer:tapGesture1];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteAction:)];
        [tapGesture2 setDelegate:self];
        [lblWebsite addGestureRecognizer:tapGesture2];
        
        lblName.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        
        
        //for phone number
        if ([[dictContact objectForKey:@"work_phone"] isEqualToString:@""] && [[dictContact objectForKey:@"work_mobile_phone"] isEqualToString:@""]) {
            
           
            if([[dictContact objectForKey:@"home_phone"] isEqualToString:@""] && [[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""])
            {
                lblMobile.text=@"";
                [lblMobile setUserInteractionEnabled:NO];
                imgCallBG.hidden=YES;
                imgCallIcon.hidden=YES;
            }
            else
            {
                NSString *filter = @"### ### ####";
                NSString *strContact;
                if(![[dictContact objectForKey:@"home_phone"]isEqualToString:@""])
                {
                   strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_phone"], filter);
                }
                else
                {
                    strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
                }
              
                lblMobile.text=strContact;
                imgCallBG.hidden=NO;
                imgCallIcon.hidden=NO;
            }
         
            
        }
        else
        {
            NSString *filter = @"### ### ####";
            NSString *strContact;
            if(![[dictContact objectForKey:@"work_phone"] isEqualToString:@""])
            {
               strContact =filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_phone"], filter);
            }
            else
            {
                strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_mobile_phone"], filter);
            }
            lblMobile.text=strContact;
            imgCallBG.hidden=NO;
            imgCallIcon.hidden=NO;
        }
        
        
        //email
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) { //email
           
            if([[dictContact objectForKey:@"home_email"] isEqualToString:@""])
            {
                lblEmail.text=@"";
                [lblEmail setUserInteractionEnabled:NO];
                imgEmailBG.hidden=YES;
                imgEmailIcon.hidden=YES;
            }
            else
            {
                lblEmail.text=[dictContact objectForKey:@"home_email"];
                imgEmailBG.hidden=NO;
                imgEmailIcon.hidden=NO;
            }
            
        }
        else
        {
            lblEmail.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG.hidden=NO;
            imgEmailIcon.hidden=NO;
        }
        
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite.text=@"";
            [lblWebsite setUserInteractionEnabled:NO];
            imgWebsiteBG.hidden=YES;
            imgWebsiteIcon.hidden=YES;
        }
        else
        {
            lblWebsite.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG.hidden=NO;
            imgWebsiteIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle.text=@"";
        }
        else
        {
            lblTitle.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
                imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
        if ([[userDefault objectForKey:@"logoname"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
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
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"2"]){
        
        //add gesture for phone calling
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [lblMobile2 addGestureRecognizer:tapGesture];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailAction:)];
        [tapGesture1 setDelegate:self];
        [lblEmail2 addGestureRecognizer:tapGesture1];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteAction:)];
        [tapGesture2 setDelegate:self];
        [lblWebsite2 addGestureRecognizer:tapGesture2];
       

        
        lblName2.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
      
        //phone no
        if ([[dictContact objectForKey:@"work_phone"] isEqualToString:@""] && [[dictContact objectForKey:@"work_mobile_phone"] isEqualToString:@""]) {
            
            if([[dictContact objectForKey:@"home_phone"] isEqualToString:@""]&&[[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""])
            {
                lblMobile2.text=@"";
                [lblMobile2 setUserInteractionEnabled:NO];
                imgCallBG2.hidden=YES;
                imgCallIcon2.hidden=YES;
            }
            else
            {
                NSString *filter = @"### ### ####";
                NSString *strContact;
                if(![[dictContact objectForKey:@"home_phone"] isEqualToString:@""])
                {
                     strContact =filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_phone"], filter);
                }
                else
                {
                    strContact =filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
                }
              
                lblMobile2.text=strContact;
                imgCallBG2.hidden=NO;
                imgCallIcon2.hidden=NO;
            }
            
        }
        else
        {
            NSString *filter = @"### ### ####";
            NSString *strContact;
            if(![[dictContact objectForKey:@"work_phone"] isEqualToString:@""])
            {
                strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_phone"], filter);
            }
            else
            {
                 strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_mobile_phone"], filter);
            }
           
            lblMobile2.text=strContact;
            imgCallBG2.hidden=NO;
            imgCallIcon2.hidden=NO;
        }
        
        
        //email
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) {
            
            if([[dictContact objectForKey:@"home_email"] isEqualToString:@""])
            {
                lblEmail2.text=@"";
                [lblEmail2 setUserInteractionEnabled:NO];
                imgEmailBG2.hidden=YES;
                imgEmailIcon2.hidden=YES;
            }
            else
            {
                lblEmail2.text=[dictContact objectForKey:@"home_email"];
                imgEmailBG2.hidden=NO;
                imgEmailIcon2.hidden=NO;
            }
        }
        else
        {
            lblEmail2.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG2.hidden=NO;
            imgEmailIcon2.hidden=NO;
        }
        
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite2.text=@"";
            [lblWebsite2 setUserInteractionEnabled:NO];
            imgWebsiteBG2.hidden=YES;
            imgWebsiteIcon2.hidden=YES;
        }
        else
        {
            lblWebsite2.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG2.hidden=NO;
            imgWebsiteIcon2.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle2.text=@"";
        }
        else
        {
            lblTitle2.text=[dictContact objectForKey:@"title"];
        }
        
        
        if ([[dictContact objectForKey:@"work_address1"] isEqualToString:@""]) {
            
            if ([[dictContact objectForKey:@"home_address1"] isEqualToString:@""]) {
               
                lblAddress1.text=@"";
                lblAddress2.text=@"";
                lblAddress3.text=@"";
            }
            else
            {
                lblAddress1.text=[dictContact objectForKey:@"home_address1"];
                lblAddress2.text=[dictContact objectForKey:@"home_suburb"];
                lblAddress3.text=[dictContact objectForKey:@"home_city"];            }
        }
        else
        {
            lblAddress1.text=[dictContact objectForKey:@"work_address1"];
            lblAddress2.text=[dictContact objectForKey:@"work_suburb"];
            lblAddress3.text=[dictContact objectForKey:@"work_city"];
        }

        
        NSString *strState;//postcode
        //        state
        if ([[dictContact objectForKey:@"work_state"] isEqualToString:@""]) {
            
            if([[dictContact objectForKey:@"home_state"] isEqualToString:@""])
            {
                strState=@"";
                
            }
            else
            {
                strState=[dictContact objectForKey:@"home_state"];
            }
        }
        else
        {
            strState=[dictContact objectForKey:@"work_state"];
        }
        
        if ([[dictContact objectForKey:@"work_post_code"] isEqualToString:@""]) {
            
            if([[dictContact objectForKey:@"home_post_code"] isEqualToString:@""])
            {
                lblStatePostcode.text=[NSString stringWithFormat:@"%@",strState];
            }
            else
            {
                lblStatePostcode.text=[NSString stringWithFormat:@"%@/%@",strState,[dictContact objectForKey:@"home_post_code"]];
            }
            
        }
        else
        {
            lblStatePostcode.text=[NSString stringWithFormat:@"%@/%@",strState,[dictContact objectForKey:@"work_post_code"]];
        }
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=NO;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=YES;
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"3"]){
        
        //add gesture for phone calling
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [lblMobile3 addGestureRecognizer:tapGesture];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailAction:)];
        [tapGesture1 setDelegate:self];
        [lblEmail3 addGestureRecognizer:tapGesture1];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteAction:)];
        [tapGesture2 setDelegate:self];
        [lblWebsite3 addGestureRecognizer:tapGesture2];
        
        lblName3.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
     
        
        if ([[dictContact objectForKey:@"work_phone"] isEqualToString:@""]&&[[dictContact objectForKey:@"work_mobile_phone"] isEqualToString:@""]) {
            
            if([[dictContact objectForKey:@"home_phone"] isEqualToString:@""]&&[[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""])
            {
                lblMobile3.text=@"";
                [lblWebsite3 setUserInteractionEnabled:NO];
                imgCallBG3.hidden=YES;
                imgCallIcon3.hidden=YES;
            }
            else
            {
                NSString *filter = @"### ### ####";
                NSString *strContact;
                if(![[dictContact objectForKey:@"home_phone"] isEqualToString:@""])
                {
                    strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_phone"], filter);
                }
                else
                {
                    strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
                }
               
                lblMobile3.text=strContact;
                imgCallBG3.hidden=NO;
                imgCallIcon3.hidden=NO;
            }
        }
        else
        {
            NSString *filter = @"### ### ####";
            NSString *strContact;
            if(![[dictContact objectForKey:@"work_phone"] isEqualToString:@""])
            {
                 strContact =filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_phone"], filter);
            }
            else
            {
                strContact =filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_mobile_phone"], filter);
            }
           
            lblMobile3.text=strContact;
            imgCallBG3.hidden=NO;
            imgCallIcon3.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
               self.imgProfilePic3.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [self.imgProfilePic3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }

        
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) {
           
            if([[dictContact objectForKey:@"home_email"] isEqualToString:@""])
            {
                lblEmail3.text=@"";
                [lblEmail3 setUserInteractionEnabled:NO];
                imgEmailBG3.hidden=YES;
                imgEmailIcon3.hidden=YES;
            }
            else
            {
                lblEmail3.text=[dictContact objectForKey:@"home_email"];
                imgEmailBG3.hidden=NO;
                imgEmailIcon3.hidden=NO;
            }
        }
        else
        {
            lblEmail3.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG3.hidden=NO;
            imgEmailIcon3.hidden=NO;
        }
        
       
        if ([[userDefault objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite3.text=@"";
            [lblWebsite3 setUserInteractionEnabled:NO];
            imgWebsiteBG3.hidden=YES;
            imgWebsiteIcon3.hidden=YES;
        }
        else
        {
            lblWebsite3.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG3.hidden=NO;
            imgWebsiteIcon3.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle3.text=@"";
        }
        else
        {
            lblTitle3.text=[dictContact objectForKey:@"title"];
        }
        
        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
        imgProfilePic.layer.masksToBounds=YES;
        imgProfilePic.layer.borderWidth=0;
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=NO;
        viewLayout4.hidden=YES;
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"4"]){
        
        //add gesture for phone calling
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [lblMobile4 addGestureRecognizer:tapGesture];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailAction:)];
        [tapGesture1 setDelegate:self];
        [lblEmail4 addGestureRecognizer:tapGesture1];
        
        //add gesture for email
        UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteAction:)];
        [tapGesture2 setDelegate:self];
        [lblWebsite4 addGestureRecognizer:tapGesture2];
      
        lblName4.text=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
     
        
        if ([[dictContact objectForKey:@"work_phone"] isEqualToString:@""]&&[[dictContact objectForKey:@"work_mobile_phone"] isEqualToString:@""]) {
           
           if([[dictContact objectForKey:@"home_phone"] isEqualToString:@""]&&[[dictContact objectForKey:@"home_mobile_phone"] isEqualToString:@""])
           {
               lblMobile4.text=@"";
               [lblMobile4 setUserInteractionEnabled:NO];
               imgCallBG4.hidden=YES;
               imgCallIcon4.hidden=YES;
           }
           else
           {
               NSString *filter = @"### ### ####";
               NSString *strContact;
               if(![[dictContact objectForKey:@"home_phone"] isEqualToString:@""])
               {
                   strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_phone"], filter);
               }
               else{
                   
                   strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"home_mobile_phone"], filter);
               }
              
               lblMobile4.text=strContact;
               imgCallBG4.hidden=NO;
               imgCallIcon4.hidden=NO;
           }
            
        }
        else
        {
            NSString *filter = @"### ### ####";
            NSString *strContact;
            if(![[dictContact objectForKey:@"work_phone"] isEqualToString:@""])
            {
                 strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_phone"], filter);
            }
            else
            {
                 strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"work_mobile_phone"], filter);
            }
       
            lblMobile4.text=strContact;
            imgCallBG4.hidden=NO;
            imgCallIcon4.hidden=NO;
        }
        
       
        if ([[dictContact objectForKey:@"work_email"] isEqualToString:@""]) {
            
            if([[dictContact objectForKey:@"home_email"] isEqualToString:@""])
            {
                lblEmail4.text=@"";
                [lblEmail4 setUserInteractionEnabled:NO];
                imgEmailBG4.hidden=YES;
                imgEmailIcon4.hidden=YES;
            }
            else
            {
                lblEmail4.text=[dictContact objectForKey:@"home_email"];
                imgEmailBG4.hidden=NO;
                imgEmailIcon4.hidden=NO;
            }
            
        }
        else
        {
            lblEmail4.text=[dictContact objectForKey:@"work_email"];
            imgEmailBG4.hidden=NO;
            imgEmailIcon4.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"website"] isEqualToString:@""]) {
            lblWebsite4.text=@"";
            [lblWebsite4 setUserInteractionEnabled:NO];
            imgWebsiteBG4.hidden=YES;
            imgWebsiteIcon4.hidden=YES;
        }
        else
        {
            lblWebsite4.text=[dictContact objectForKey:@"website"];
            imgWebsiteBG4.hidden=NO;
            imgWebsiteIcon4.hidden=NO;
        }
        
        if ([[userDefault objectForKey:@"title"] isEqualToString:@""]) {
            lblTitle4.text=@"";
        }
        else
        {
            lblTitle4.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [imgLogo4 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        imgProfilePic.layer.cornerRadius=imgProfilePic.frame.size.height/2;
        imgProfilePic.layer.masksToBounds=YES;
        imgProfilePic.layer.borderWidth=0;
        
        viewLayout1.hidden=YES;
        viewLayout2.hidden=YES;
        viewLayout3.hidden=YES;
        viewLayout4.hidden=NO;
    }
    
    
    //other detail
    NSLog(@"%@",dictContact);
   // self.contentViewHeight.constant=(viewLayout1.frame.origin.x+viewLayout1.frame.size.height);
    
    //home Phone
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_phone"]]length]>0)
    {
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [lblViewHomePhone addGestureRecognizer:tapGesture];
        
        lblViewHomePhone.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"home_phone"]];
        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewHomephone.frame.size.height;
    }
    else
    {
        self.homePhoneTop.constant=0;
        //self.homeEmailTop.constant=0;
        self.homePhoneHeight.constant=0;
        self.viewHomephone.hidden=YES;
        [self.view updateConstraints];
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewHomephone.frame.size.height;
        
    }
    
    //home email
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"home_email"]]length]>0)
    {
       
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailAction:)];
        [tapGesture1 setDelegate:self];
        [lblViewHomeEmail addGestureRecognizer:tapGesture1];
        
        
        
        lblViewHomeEmail.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"home_email"]];
        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewHomeMail.frame.size.height;
    }
    else
    {
        
        self.homeEmailTop.constant=0;
        // self.homeAddressTop.constant=0;
        self.homeEmailAddHeight.constant=0;
        self.viewHomeMail.hidden=YES;
        [self.view updateConstraints];
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewHomeMail.frame.size.height;
       
    }
    
   
    //Home Address
    NSArray *array=[[NSArray alloc]initWithObjects:@"home_address1",@"home_suburb",@"home_city",@"home_state",@"home_country",@"home_post_code",nil];
    NSString *strHomeAddress=@"";
    for(NSString *str in array)
    {
        if(![[dictContact objectForKey:str]isEqualToString:@""])
        {
            if([strHomeAddress isEqualToString:@""])
            {
                strHomeAddress=[NSString stringWithFormat:@"%@\n",[dictContact objectForKey:str]];
            }
            else
            {
                strHomeAddress=[strHomeAddress stringByAppendingString:[NSString stringWithFormat:@"%@\n",[dictContact objectForKey:str]]];
            }
        }
    }
    NSLog(@"%@",strHomeAddress);
    
  //  NSString *strHomeAddress=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dictContact objectForKey:@"home_address1"],[dictContact objectForKey:@"home_suburb"],[dictContact objectForKey:@"home_city"],[dictContact objectForKey:@"home_state"],[dictContact objectForKey:@"home_country"],[dictContact objectForKey:@"home_post_code"]];
    
    
    if([[strHomeAddress trimSpaces]isEqualToString:@""]||[strHomeAddress isKindOfClass:[NSNull class]])
    {
        
        self.homeAddressTop.constant=0;
        // self.companyNameTop.constant=0;
        self.HomeAddressHeight.constant=0;
          self.viewHomeAddress.hidden=YES;
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewHomeAddress.frame.size.height;

    }
    else
    {
        
        //txtViewHomeAddress.text=strHomeAddress;
        
        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewHomeAddress.frame.size.height;
        self.lblHOmeAddress.text=SAFESTRING(strHomeAddress);
        self.lblHOmeAddress.numberOfLines=0;
        lblHOmeAddress.lineBreakMode = NSLineBreakByWordWrapping;
        [self.lblHOmeAddress sizeToFit];
        
        self.HomeAddressHeight.constant=self.lblHOmeAddress.frame.size.height+40;
        
//        CGSize maximumLabelSize = CGSizeMake(self.lblHOmeAddress.frame.size.width, FLT_MAX);
//        
//        CGSize expectedLabelSize = [strHomeAddress sizeWithFont:lblHOmeAddress.font constrainedToSize:maximumLabelSize lineBreakMode:lblHOmeAddress.lineBreakMode];
//        
//        //adjust the label the the new height.
//        CGRect newFrame = lblHOmeAddress.frame;
//        newFrame.size.height = expectedLabelSize.height;
//        lblHOmeAddress.frame = newFrame;
        
    }
    
    //Company Name
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"company"]]length]>0)
    {
        self.lblViewCompanyname.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"company"]];
        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewCompanyName.frame.size.height;
    }
    else
    {
        self.companyNameTop.constant=0;
       // self.companyNumberTop.constant=0;
        self.companyNameHeight.constant=0;
        self.viewCompanyName.hidden=YES;
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewCompanyName.frame.size.height;
     
    }
    
    
    //office phone
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_phone"]]length]>0)
    {
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [self.lblViewOffiecePhoneno addGestureRecognizer:tapGesture];

        
        
        self.lblViewOffiecePhoneno.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_phone"]];
        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewCompanyPhone.frame.size.height;
    }
    else
    {
        self.companyNumberTop.constant=0;
       // self.companyMobilePhonetop.constant=0;
        self.companyPhoneHeight.constant=0;
         self.viewCompanyPhone.hidden=YES;
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewCompanyPhone.frame.size.height;
       
       
    }
    
    //office mobile number
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_mobile_phone"]]length]>0)
    {
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling:)];
        [tapGesture setDelegate:self];
        [self.lblViewOfficeMobileno addGestureRecognizer:tapGesture];
        
        
        self.lblViewOfficeMobileno.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_mobile_phone"]];

        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewCompanyMobileNo.frame.size.height;
    }
    else
    {
        self.companyMobilePhonetop.constant=0;
        //self.officeEmailTop.constant=0;
        self.companyMobileHeight.constant=0;
        self.viewCompanyMobileNo.hidden=YES;
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewCompanyMobileNo.frame.size.height;
        
       
    }
   
    //officeEmail
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_email"]]length]>0)
    {
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailAction:)];
        [tapGesture1 setDelegate:self];
        [self.lblViewOfficeEmail addGestureRecognizer:tapGesture1];
        
        
        self.lblViewOfficeEmail.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"work_email"]];
       self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewOffieceEmail.frame.size.height;
    }
    else
    {
        self.officeEmailTop.constant=0;
       // self.websiteTop.constant=0;
        self.officeEmailHeight.constant=0;
        self.viewOffieceEmail.hidden=YES;
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewOffieceEmail.frame.size.height;
        
    }
    
    //website
    if([[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"website"]]length]>0)
    {
        UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteAction:)];
        [tapGesture2 setDelegate:self];
        [self.lblViewWebsite addGestureRecognizer:tapGesture2];
        
        self.lblViewWebsite.text=[NSString stringWithFormat:@"%@",[dictContact objectForKey:@"website"]];
       self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewWebsite.frame.size.height;
    }
    else
    {
        self.websiteTop.constant=0;
      //  self.officeAddressTop.constant=0;
        self.websiteHeight.constant=0;
         self.viewWebsite.hidden=YES;
        [self.view updateConstraints];
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewWebsite.frame.size.height;
       
    }
    
    
    //office address
    NSArray *array1=[[NSArray alloc]initWithObjects:@"work_address1",@"work_suburb",@"work_city",@"work_state",@"work_country",@"work_post_code",nil];
    NSString *strOfficeAddress=@"";
    for(NSString *str in array1)
    {
        if(![[dictContact objectForKey:str]isEqualToString:@""])
        {
            if([strOfficeAddress isEqualToString:@""])
            {
                strOfficeAddress=[NSString stringWithFormat:@"%@\n",[dictContact objectForKey:str]];
            }
            else
            {
                strOfficeAddress=[strOfficeAddress stringByAppendingString:[NSString stringWithFormat:@"%@\n",[dictContact objectForKey:str]]];
            }
        }
    }
    NSLog(@"%@",strOfficeAddress);
    
  //  NSString *strOfficeAddress=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dictContact objectForKey:@"work_address1"],[dictContact objectForKey:@"work_suburb"],[dictContact objectForKey:@"work_city"],[dictContact objectForKey:@"work_state"],[dictContact objectForKey:@"work_country"],[dictContact objectForKey:@"work_post_code"]];
    
   if([[strOfficeAddress trimSpaces] isEqualToString:@""]||[strOfficeAddress isKindOfClass:[NSNull class]])
    {
        self.officeAddressTop.constant=0;
        self.companyAddHeight.constant=0;
        self.viewCompanyAddress.hidden=YES;
        self.contentViewHeight.constant=self.contentViewHeight.constant-self.viewCompanyAddress.frame.size.height;
    }
    else
    {
       
       // self.txtViewOfficeAddress.text=strOfficeAddress;
      
        self.contentViewHeight.constant=self.contentViewHeight.constant+self.viewCompanyAddress.frame.size.height;
       
        self.lblOfficeAddress.text=SAFESTRING(strOfficeAddress);
        self.lblOfficeAddress.numberOfLines=0;
        self.lblOfficeAddress.lineBreakMode = NSLineBreakByWordWrapping;
        [self.lblOfficeAddress sizeToFit];
        
        self.companyAddHeight.constant=self.lblOfficeAddress.frame.size.height+40;

    }
    //self.contentViewHeight.constant=self.contentViewHeight.constant+40;
    
    self.scrlView.contentSize=self.ContentView.frame.size;
    [self.view updateConstraints];
    
    
    //getting from favorite
    arrfavorite=[[NSMutableArray alloc]init];
    NSString *query2 = [ NSString stringWithFormat:@"select Favorite from Contact_Detail where contact_id=%@",[dictContact objectForKey:@"contact_id"]];
    arrfavorite=[Database executeQuery:query2];
    if([[[arrfavorite valueForKey:@"Favorite"]objectAtIndex:0]isEqualToString:@"1"])
    {
        [self.imgAddtoFavorite setImage:[UIImage imageNamed:@"starFavoriteselimg.png"]];
        [self.btnFavorite setSelected:NO];
    }
    else
    {
        [self.imgAddtoFavorite setImage:[UIImage imageNamed:@"starFavoriteunselimg.png"]];
         [self.btnFavorite setSelected:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark-calling Webservices
-(void)callWebserviceForAddToFavourites
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateFavourites" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"add" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:[dictContact objectForKey:@"contact_id"] forKey:@"senderId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                
                NSString *query= [NSString stringWithFormat:@"update Contact_Detail set Favorite='%@' where contact_id='%@'",
                                      [NSString stringWithFormat:@"1"],[dictContact objectForKey:@"contact_id"]];
                    
                    [Database executeQuery:query];
                    NSLog(@"Data Updated!");
               
                
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
-(void)callWebserviceForremoveFromFavourites
{
    if ([self isNetworkReachable])
    {
        [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"operateFavourites" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"remove" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"receiverId"];
        [dict setObject:[dictContact objectForKey:@"contact_id"] forKey:@"senderId"];
        
        
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            [self hidHud];
            
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                
                NSString *query= [NSString stringWithFormat:@"update Contact_Detail set Favorite='%@' where contact_id='%@'",
                                  [NSString stringWithFormat:@"0"],[dictContact objectForKey:@"contact_id"]];
                
                [Database executeQuery:query];
                NSLog(@"Data Updated!");
                
                
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




#pragma mark - Custom Method

//for the calling Action
-(void)calling:(UITapGestureRecognizer *)gestureRecognizer;{
    [self callThisPhone];
}

-(void) callThisPhone
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] )
    {
        if ([[dictContact objectForKey:@"work_phone"] isEqualToString:@""])
        {
            NSString *phoneNumber = [@"tel://" stringByAppendingString:[dictContact objectForKey:@"work_phone"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        else{
            NSString *phoneNumber = [@"tel://" stringByAppendingString:[dictContact objectForKey:@"home_phone"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
    else
    {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Phone call facility is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

//for the email action
-(void)EmailAction:(UITapGestureRecognizer *)gestureRecognizer;
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [mailer setMailComposeDelegate:self];
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        [mailer setTitle:APP_NAME];
        [mailer setSubject:@""];
        
        NSString *strEmail;
        if([[dictContact objectForKey:@"work_email"] isEqualToString:@""])
        {
            if([[dictContact objectForKey:@"home_email"] isEqualToString:@""])
            {
                
            }
            else{
                strEmail=[dictContact objectForKey:@"home_email"];
            }
        }
        else
        {
             strEmail=[dictContact objectForKey:@"home_email"];
        }
        
       
        [mailer setToRecipients:[NSArray arrayWithObjects:strEmail,nil]];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:@"Your device doesn't support the composer sheet" andTitle:APP_NAME];
        
    }
}
#pragma mark - MFMAIL DELEGATE

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            [UIAlertView infoAlertWithMessage:@"Mail has been canceled." andTitle:APP_NAME];
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //            [UIAlertView infoAlertWithMessage:@"Mail has been saved in the drafts folder." andTitle:APP_NAME];
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [UIAlertView infoAlertWithMessage:@"Email sent successfully." andTitle:APP_NAME];
            
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            //            [UIAlertView infoAlertWithMessage:@"Mail failed: the email message was not saved or queued, possibly due to an error." andTitle:APP_NAME];
            break;
        default:
            //            NSLog(@"Mail not sent.");
            [UIAlertView infoAlertWithMessage:@"Mail not sent." andTitle:APP_NAME];
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)websiteAction:(UITapGestureRecognizer *)gestureRecognizer;
{
    
    NSURL *url = [NSURL URLWithString:[[dictContact objectForKey:@"website"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSString *str=[url description];
        [UIAlertView infoAlertWithMessage:[NSString stringWithFormat:@"Failed to open url %@",str] andTitle:APP_NAME];
    }
    
}
- (IBAction)btnaddress:(UIButton*)sender {
    
    //urlString= [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",(SAFESTRING(str))];
   
    CLLocationCoordinate2D mylocation;
    if(sender.tag==1)
    {
        mylocation=[self getLocationFromAddressString:[NSString stringWithFormat:@"%@",SAFESTRING(self.lblHOmeAddress.text)]];
    }
    else if(sender.tag==2)
    {
        mylocation=[self getLocationFromAddressString:[NSString stringWithFormat:@"%@",SAFESTRING(self.lblOfficeAddress.text)]];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%1.6f,%1.6f",mylocation.latitude,mylocation.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}


- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - more button view Action
- (IBAction)btnMoreAction:(id)sender
{
    if(self.viewMoreItem.hidden)
    {
        self.viewMoreItem.hidden=NO;
    }
    else
    {
        self.viewMoreItem.hidden=YES;
    }
    
    
}
- (IBAction)btnNoteAction:(id)sender {
    
    [UIView animateWithDuration:0.5f animations:^{
        
    } completion:^(BOOL finished) {
        self.viewMoreItem.hidden=YES;
    }];
    NSLog(@"%@",dictContact);
    NSString *Str=[NSString stringWithFormat:@"%@ %@",[dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
    NotesViewController *vcNotes=[self.storyboard instantiateViewControllerWithIdentifier:@"NotesViewController"];
    vcNotes.senderIDFornote=[dictContact objectForKey:@"contact_id"];
    vcNotes.username=Str;
    [self.navigationController pushViewController:vcNotes animated:YES];
    
}
- (IBAction)btnInformationAction:(id)sender {
    
    [UIView animateWithDuration:0.5f animations:^{
        
    } completion:^(BOOL finished) {
        self.viewMoreItem.hidden=YES;
    }];
    InformationViewController *vcINfo=[self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vcINfo.strinfoId=[dictContact objectForKey:@"contact_id"];
    [self.navigationController pushViewController:vcINfo animated:YES];
    
}

- (IBAction)btnTagAction:(id)sender {
  
    [userDefault setObject:@"1" forKey:@"isFromcontactdetail"];
    ReceiveTagViewController *vcReceivetag=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiveTagViewController"];
    vcReceivetag.senderIDForTag=[dictContact objectForKey:@"contact_id"];
    [self.navigationController pushViewController:vcReceivetag animated:YES];
    
}
- (IBAction)btnAddtoFavoriteAction:(id)sender {
    
    if([sender isSelected])
    {
        [sender setSelected:NO];
        [self.imgAddtoFavorite setImage:[UIImage imageNamed:@"starFavoriteselimg.png"]];
        [self callWebserviceForAddToFavourites];
    }
    else
    {
        [sender setSelected:YES];
        [self.imgAddtoFavorite setImage:[UIImage imageNamed:@"starFavoriteunselimg.png"]];
        [self callWebserviceForremoveFromFavourites];
    }
    
    
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}




#pragma mark - tabbar method action
- (IBAction)btnPersontabAction:(id)sender {
    
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

- (IBAction)btnReceiveAction:(id)sender {
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
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//old code
/*
- (IBAction)btnFacebookAction:(id)sender {
    
    if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
        //        vc.strUrl=@"https://www.facebook.com/tristate777";
        [UIAlertView infoAlertWithMessage:@"You have not Facebook Data!" andTitle:APP_NAME];
    }
    else
    {
        WebViewViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
        vc.strTitle=@"Facebook Profile";
        vc.strUrl=[dictContact objectForKey:@"facebook"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnTwitterAction:(id)sender {
    
    if ([[dictContact objectForKey:@"twitter"] isEqualToString:@""]) {
        [UIAlertView infoAlertWithMessage:@"You have not Twiiter Data!" andTitle:APP_NAME];
    }
    else
    {
        //        [self followOnTwitter:@"719601974" isID:YES];
        [self followOnTwitter:[dictContact objectForKey:@"twitter"] isID:YES];
    }
}

- (IBAction)btnLinkedIn:(id)sender {
    
    OAuthLoginView *objLikedIn=[OAuthLoginView sharedObject];
    objLikedIn.delegate=self;
    if([OAuthLoginView isAutherized])
    {
        //        NSArray *array = [[userDefault objectForKey:@"LKName"] componentsSeparatedByString:@" "];
        //        if([array count]>1)
        //        {
        //            [self showHud];
        
        //        [objLikedIn sendInvitationByEmailID:@"adpatel1990ad@gmail.com" firstName:@"Arvind"lastName:@"Patel" withDelegate:self];
        
        
        //        }
        
    }
    //    else
    //    {
    //        [objLikedIn showLoginLinkedInPage:self];
    //    }
}

- (IBAction)btnSkypeAction:(id)sender {
    
    //    WebViewViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    //    vc.strTitle=@"Skype Profile";
    //    vc.strUrl=@"https://secure.skype.com/portal/overview";
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPersontabAction:(id)sender {
}

- (IBAction)btnSendTabAction:(id)sender {
}

- (IBAction)btnReceiveAction:(id)sender {
}

- (IBAction)btnFavoriteTabAction:(id)sender {
}

- (IBAction)btnSettingTabAction:(id)sender {
}

#pragma mark - OAuthDelegate


-(void) loginDidFinish{
    
}
-(void) loginDidFinishWithError:(NSString *)error{
    
}

-(void) requestedDataLoad:(NSDictionary *)dict{
    
}
-(void) requestedDataError{
    
}


#pragma mark - Follow on TWITTER -

-(void)followOnTwitter:(NSString *)user isID:(BOOL)isID
{
    [self showHud];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"] parameters:[NSDictionary dictionaryWithObject:user forKey:@"user_id"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            
                            // Filter the preferred data
                            int tweetID = [NSString stringWithFormat:@"%d",[[(NSDictionary *)TWData objectForKey:@"id"] intValue]];
                            NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                            NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                            
                            int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                            int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                            
                            
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            [dict setValue:[NSString stringWithFormat:@"%d", tweetID] forKey:@"id"];
                            [dict setValue:screen_name forKey:@"screen_name"];
                            [dict setValue:name forKey:@"name"];
                            [dict setValue:[NSString stringWithFormat:@"%d",followers] forKey:@"folloers"];
                            [dict setValue:[NSString stringWithFormat:@"%d",following] forKey:@"following"];
                            
                            [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":dict,@"message":@""} waitUntilDone:YES];
                            
                        }
                    });
                }];
            }
            else
            {
                
                [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account access denied, please set up your Twitter account in your device's Settings (Settings--> Twitter)."} waitUntilDone:YES];
                
            }
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account access denied, please set up your Twitter account in your device's Settings (Settings--> Twitter)."} waitUntilDone:YES];
            
        }
    }];
    
}

-(void)performTwitterDelegateMethodwithDict:(NSMutableDictionary *)dict{
    NSMutableDictionary *dictinfo = [dict valueForKey:@"info"];
    NSString *message = [dict valueForKey:@"message"];
    //    if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)])
    //        [_delegate twUserDetailWithData:dictinfo withMessage:message];
    
    [self twUserDetailWithData:dictinfo withMessage:message];
}
#pragma mark- TWITTER METHODS

- (void)twUserDetailWithData:(NSMutableDictionary *)dictInfo withMessage:(NSString *)message
{
    if (message.length) {
        [self hidHud];
        
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
    }
    else
    {
        [self hidHud];
        [UIAlertView infoAlertWithMessage:@"Successfully Followed!" andTitle:APP_NAME];
    }
} */

@end
