//
//  DetailViewController.m
//  Tapt
//
//  Created by Parth on 28/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTVCell.h"
#import "UIImageView+WebCache.h"
#import "WebViewViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize viewTableViewHeader;
@synthesize arrKeys,arrTemp,arrKeysForView;
@synthesize dictContact,dictData;

- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    // Do any additional setup after loading the view.
    
        if ([[dictContact objectForKey:@"layout"] isEqualToString:@"2"]){
        Card2View *card1=[Card2View loadView];
        card1.delegate=self;
        
        card1.lblMobile.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling)];
        [card1.lblMobile addGestureRecognizer:tapGesture];

        
        card1.lblName.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        self.lblHeader.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            card1.lblTitle.text=@"";
        }
        else
        {
            card1.lblTitle.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"mobile_phone"] isEqualToString:@""]) {
            card1.lblMobile.text=@"";
            card1.imgCallBG.hidden=YES;
            card1.imgCallIcon.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"mobile_phone"], filter);
            card1.lblMobile.text=strContact;
            card1.imgCallBG.hidden=NO;
            card1.imgCallIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"email"] isEqualToString:@""]) {
            card1.lblEmail.text=@"";
            card1.imgEmailBG.hidden=YES;
            card1.imgEmailIcon.hidden=YES;
        }
        else
        {
            card1.lblEmail.text=[dictContact objectForKey:@"email"];
            card1.imgEmailBG.hidden=NO;
            card1.imgEmailIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            card1.lblWebsite.text=@"";
            card1.imgWebsiteBG.hidden=YES;
            card1.imgWebsiteIcon.hidden=YES;
        }
        else
        {
            card1.lblWebsite.text=[dictContact objectForKey:@"website"];
            card1.imgWebsiteBG.hidden=NO;
            card1.imgWebsiteIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"address1"] isEqualToString:@""]) {
            card1.lblAddress1.text=@"";
        }
        else
        {
            card1.lblAddress1.text=[dictContact objectForKey:@"address1"];
        }
        
        if ([[dictContact objectForKey:@"address2"] isEqualToString:@""]) {
            card1.lblAddress2.text=@"";
        }
        else
        {
            card1.lblAddress2.text=[dictContact objectForKey:@"address2"];
        }
        
        if ([[dictContact objectForKey:@"address3"] isEqualToString:@""]) {
            card1.lblAddress3.text=@"";
        }
        else
        {
            card1.lblAddress3.text=[dictContact objectForKey:@"address3"];
        }
        
        NSString *strState;//postcode
        //        state
        if ([[dictContact objectForKey:@"state"] isEqualToString:@""]) {
            strState=@"";
        }
        else
        {
            strState=[dictContact objectForKey:@"state"];
        }
        
        if ([SAFESTRING([dictContact objectForKey:@"postcode"]) isEqualToString:@""]) {
            card1.lblStatePostcode.text=[NSString stringWithFormat:@"%@",strState];
        }
        else
        {
            card1.lblStatePostcode.text=[NSString stringWithFormat:@"%@/%@",strState,SAFESTRING([dictContact objectForKey:@"postcode"])];
        }
        
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
            card1.imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [card1.imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
//            [card1.imgProfilePicContent sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
//        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
//            //        card1.imgLogo.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
//        }
//        else
//        {
//            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
//            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//            NSURL *url=[NSURL URLWithString:strImgUrl];
//            [card1.imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//        }
        
        
        if ([[dictContact objectForKey:@"skype"] isEqualToString:@""]) {
            card1.btnSkyeName.hidden=YES;
        }
        else
        {
            card1.btnSkyeName.hidden=NO;
            [card1.btnSkyeName setTitle:[dictContact objectForKey:@"skype"] forState:UIControlStateNormal];
        }
        
        if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
            card1.btnFacebook.hidden=YES;
        }
        else
            card1.btnFacebook.hidden=NO;
        
        if ([[dictContact objectForKey:@"linkedIn"] isEqualToString:@""]) {
            card1.btnLinkedIn.hidden=YES;
        }
        else
            card1.btnLinkedIn.hidden=NO;
        
        if ([[dictContact objectForKey:@"twitter"] isEqualToString:@""]) {
            card1.btnTwitter.hidden=YES;
        }
        else
            card1.btnTwitter.hidden=NO;
        
        
        card1.imgProfilePic.layer.cornerRadius=card1.imgProfilePic.frame.size.height/2;
        card1.imgProfilePic.layer.masksToBounds=YES;
        card1.imgProfilePic.layer.borderWidth=0;
        
//        card1.imgProfilePicContent.layer.cornerRadius=card1.imgProfilePicContent.frame.size.height/2;
//        card1.imgProfilePicContent.layer.masksToBounds=YES;
//        card1.imgProfilePicContent.layer.borderWidth=0;
        
        self.tblView.tableHeaderView=nil;
        
        
        card1.frame=CGRectMake(card1.frame.origin.x, card1.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        self.viewTableViewHeader.frame=CGRectMake(self.viewTableViewHeader.frame.origin.x, self.viewTableViewHeader.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        
        [self.viewTableViewHeader addSubview:card1];
        [self.tblView addSubview:self.viewTableViewHeader];
        self.tblView.tableHeaderView=self.viewTableViewHeader;
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"3"]){
        
        Card3View *card1=[Card3View loadView];
        card1.delegate=self;
        
        card1.lblMobile.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling)];
        [card1.lblMobile addGestureRecognizer:tapGesture];

        
        card1.lblName.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        self.lblHeader.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            card1.lblTitle.text=@"";
        }
        else
        {
            card1.lblTitle.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"mobile_phone"] isEqualToString:@""]) {
            card1.lblMobile.text=@"";
            card1.imgCallBG.hidden=YES;
            card1.imgCallIcon.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"mobile_phone"], filter);
            card1.lblMobile.text=strContact;
            card1.imgCallBG.hidden=NO;
            card1.imgCallIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"email"] isEqualToString:@""]) {
            card1.lblEmail.text=@"";
            card1.imgEmailBG.hidden=YES;
            card1.imgEmailIcon.hidden=YES;
        }
        else
        {
            card1.lblEmail.text=[dictContact objectForKey:@"email"];
            card1.imgEmailBG.hidden=NO;
            card1.imgEmailIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            card1.lblWebsite.text=@"";
            card1.imgWebsiteBG.hidden=YES;
            card1.imgWebsiteIcon.hidden=YES;
        }
        else
        {
            card1.lblWebsite.text=[dictContact objectForKey:@"website"];
            card1.imgWebsiteBG.hidden=NO;
            card1.imgWebsiteIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
            card1.imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
//            [card1.imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
            [card1.imgProfilePicContent sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            //        card1.imgLogo.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [card1.imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
       
        if ([[dictContact objectForKey:@"skype"] isEqualToString:@""]) {
            card1.btnSkyeName.hidden=YES;
        }
        else
        {
            card1.btnSkyeName.hidden=NO;
            [card1.btnSkyeName setTitle:[dictContact objectForKey:@"skype"] forState:UIControlStateNormal];
        }
        
        if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
            card1.btnFacebook.hidden=YES;
        }
        else
            card1.btnFacebook.hidden=NO;
        
        if ([[dictContact objectForKey:@"linkedIn"] isEqualToString:@""]) {
            card1.btnLinkedIn.hidden=YES;
        }
        else
            card1.btnLinkedIn.hidden=NO;
        
        if ([[dictContact objectForKey:@"twitter"] isEqualToString:@""]) {
            card1.btnTwitter.hidden=YES;
        }
        else
            card1.btnTwitter.hidden=NO;
        
        
//        card1.imgProfilePic.layer.cornerRadius=card1.imgProfilePic.frame.size.height/2;
//        card1.imgProfilePic.layer.masksToBounds=YES;
//        card1.imgProfilePic.layer.borderWidth=0;
        
        card1.imgProfilePicContent.layer.cornerRadius=card1.imgProfilePicContent.frame.size.height/2;
        card1.imgProfilePicContent.layer.masksToBounds=YES;
        card1.imgProfilePicContent.layer.borderWidth=0;
        
        self.tblView.tableHeaderView=nil;
        
        
        card1.frame=CGRectMake(card1.frame.origin.x, card1.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        self.viewTableViewHeader.frame=CGRectMake(self.viewTableViewHeader.frame.origin.x, self.viewTableViewHeader.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        
        [self.viewTableViewHeader addSubview:card1];
        [self.tblView addSubview:self.viewTableViewHeader];
        self.tblView.tableHeaderView=self.viewTableViewHeader;
        
    }
    else if ([[dictContact objectForKey:@"layout"] isEqualToString:@"4"]){
        
        Card4View *card1=[Card4View loadView];
        card1.delegate=self;
        
        card1.lblMobile.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling)];
        [card1.lblMobile addGestureRecognizer:tapGesture];

        
        card1.lblName.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        self.lblHeader.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            card1.lblTitle.text=@"";
        }
        else
        {
            card1.lblTitle.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"mobile_phone"] isEqualToString:@""]) {
            card1.lblMobile.text=@"";
            card1.imgCallBG.hidden=YES;
            card1.imgCallIcon.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"mobile_phone"], filter);
            card1.lblMobile.text=strContact;
            card1.imgCallBG.hidden=NO;
            card1.imgCallIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"email"] isEqualToString:@""]) {
            card1.lblEmail.text=@"";
            card1.imgEmailBG.hidden=YES;
            card1.imgEmailIcon.hidden=YES;
        }
        else
        {
            card1.lblEmail.text=[dictContact objectForKey:@"email"];
            card1.imgEmailBG.hidden=NO;
            card1.imgEmailIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            card1.lblWebsite.text=@"";
            card1.imgWebsiteBG.hidden=YES;
            card1.imgWebsiteIcon.hidden=YES;
        }
        else
        {
            card1.lblWebsite.text=[dictContact objectForKey:@"website"];
            card1.imgWebsiteBG.hidden=NO;
            card1.imgWebsiteIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
            card1.imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
//            [card1.imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
            [card1.imgProfilePicContent sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            //        card1.imgLogo.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
            card1.imgLogo.hidden=YES;
            card1.lblLogoPlace.hidden=NO;
        }
        else
        {
            card1.imgLogo.hidden=NO;
            card1.lblLogoPlace.hidden=YES;
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [card1.imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        if ([[dictContact objectForKey:@"skype"] isEqualToString:@""]) {
            card1.btnSkyeName.hidden=YES;
        }
        else
        {
            card1.btnSkyeName.hidden=NO;
            [card1.btnSkyeName setTitle:[dictContact objectForKey:@"skype"] forState:UIControlStateNormal];
        }
        
        if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
            card1.btnFacebook.hidden=YES;
        }
        else
            card1.btnFacebook.hidden=NO;
        
        if ([[dictContact objectForKey:@"linkedIn"] isEqualToString:@""]) {
            card1.btnLinkedIn.hidden=YES;
        }
        else
            card1.btnLinkedIn.hidden=NO;
        
        if ([[dictContact objectForKey:@"twitter"] isEqualToString:@""]) {
            card1.btnTwitter.hidden=YES;
        }
        else
            card1.btnTwitter.hidden=NO;
        
        
        card1.imgProfilePic.layer.cornerRadius=card1.imgProfilePic.frame.size.height/2;
        card1.imgProfilePic.layer.masksToBounds=YES;
        card1.imgProfilePic.layer.borderWidth=0;
        
        card1.imgProfilePicContent.layer.cornerRadius=card1.imgProfilePicContent.frame.size.height/2;
        card1.imgProfilePicContent.layer.masksToBounds=YES;
        card1.imgProfilePicContent.layer.borderWidth=0;
        
        card1.viewHeader.layer.cornerRadius=30;
        
        self.tblView.tableHeaderView=nil;
        
        
        card1.frame=CGRectMake(card1.frame.origin.x, card1.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        self.viewTableViewHeader.frame=CGRectMake(self.viewTableViewHeader.frame.origin.x, self.viewTableViewHeader.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        
        [self.viewTableViewHeader addSubview:card1];
        [self.tblView addSubview:self.viewTableViewHeader];
        self.tblView.tableHeaderView=self.viewTableViewHeader;

    }
//    if ([[dictContact objectForKey:@"layout"] isEqualToString:@"1"]) {
    else{
        Card1View *card1=[Card1View loadView];
        card1.delegate=self;
        
        card1.lblMobile.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calling)];
        [card1.lblMobile addGestureRecognizer:tapGesture];
        
        card1.lblName.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        self.lblHeader.text=[NSString stringWithFormat:@"%@ %@", [dictContact objectForKey:@"first_name"],[dictContact objectForKey:@"last_name"]];
        if ([[dictContact objectForKey:@"title"] isEqualToString:@""]) {
            card1.lblTitle.text=@"";
            //            card1.lblTitle.hidden=YES;
        }
        else
        {
            card1.lblTitle.text=[dictContact objectForKey:@"title"];
        }
        
        if ([[dictContact objectForKey:@"mobile_phone"] isEqualToString:@""]) {
            card1.lblMobile.text=@"";
            card1.imgCallBG.hidden=YES;
            card1.imgCallIcon.hidden=YES;
        }
        else
        {
            NSString *filter = @"### ### ####";
            
            NSString *strContact=filteredPhoneStringFromStringWithFilter([dictContact objectForKey:@"mobile_phone"], filter);
            
            card1.lblMobile.text=strContact;
            card1.imgCallBG.hidden=NO;
            card1.imgCallIcon.hidden=NO;
            
        }
        
        if ([[dictContact objectForKey:@"email"] isEqualToString:@""]) {
            card1.lblEmail.text=@"";
            card1.imgEmailBG.hidden=YES;
            card1.imgEmailIcon.hidden=YES;
        }
        else
        {
            card1.lblEmail.text=[dictContact objectForKey:@"email"];
            card1.imgEmailBG.hidden=NO;
            card1.imgEmailIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"website"] isEqualToString:@""]) {
            card1.lblWebsite.text=@"";
            card1.imgWebsiteBG.hidden=YES;
            card1.imgWebsiteIcon.hidden=YES;
        }
        else
        {
            card1.lblWebsite.text=[dictContact objectForKey:@"website"];
            card1.imgWebsiteBG.hidden=NO;
            card1.imgWebsiteIcon.hidden=NO;
        }
        
        if ([[dictContact objectForKey:@"image_url"] isEqualToString:@""]) {
            card1.imgProfilePic.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
            card1.imgProfilePicContent.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_BASE_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"image_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [card1.imgProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
            [card1.imgProfilePicContent sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]];
        }
        
        if ([[dictContact objectForKey:@"logo_url"] isEqualToString:@""]) {
            //        card1.imgLogo.image=[UIImage imageNamed:IMAGE_PLACEHOLDER];
        }
        else
        {
            NSString *strImgUrl=[WEBSERVICE_IMG_LOGO_URL stringByAppendingFormat:@"%@",[dictContact objectForKey:@"logo_url"]];
            strImgUrl=[strImgUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSURL *url=[NSURL URLWithString:strImgUrl];
            [card1.imgLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
        if ([[dictContact objectForKey:@"skype"] isEqualToString:@""]) {
            card1.btnSkyeName.hidden=YES;
        }
        else
        {
            card1.btnSkyeName.hidden=NO;
            [card1.btnSkyeName setTitle:[dictContact objectForKey:@"skype"] forState:UIControlStateNormal];
        }
        
        if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
            card1.btnFacebook.hidden=YES;
        }
        else
            card1.btnFacebook.hidden=NO;
        
        if ([[dictContact objectForKey:@"linkedIn"] isEqualToString:@""]) {
            card1.btnLinkedIn.hidden=YES;
        }
        else
            card1.btnLinkedIn.hidden=NO;
        
        if ([[dictContact objectForKey:@"twitter"] isEqualToString:@""]) {
            card1.btnTwitter.hidden=YES;
        }
        else
            card1.btnTwitter.hidden=NO;
        
        card1.imgProfilePic.layer.cornerRadius=card1.imgProfilePic.frame.size.height/2;
        card1.imgProfilePic.layer.masksToBounds=YES;
        card1.imgProfilePic.layer.borderWidth=0;
        
        card1.imgProfilePicContent.layer.cornerRadius=card1.imgProfilePicContent.frame.size.height/2;
        card1.imgProfilePicContent.layer.masksToBounds=YES;
        card1.imgProfilePicContent.layer.borderWidth=0;
        
        self.tblView.tableHeaderView=nil;
        
        
        card1.frame=CGRectMake(card1.frame.origin.x, card1.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        self.viewTableViewHeader.frame=CGRectMake(self.viewTableViewHeader.frame.origin.x, self.viewTableViewHeader.frame.origin.y, self.view.frame.size.width, card1.frame.size.height);
        
        [self.viewTableViewHeader addSubview:card1];
        [self.tblView addSubview:self.viewTableViewHeader];
        self.tblView.tableHeaderView=self.viewTableViewHeader;
    }

    
    
    
    arrKeys=[[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Mobile",@"Work",@"Home",@"Email",@"Company",@"Title",@"Address1",@"Address2",@"Address3",@"Suburb",@"Postcode",@"City",@"State",@"Country",@"Logo",@"Picture",@"Facebook",@"Twitter",@"Linked In",@"Skype",@"Website", nil];
    
    arrTemp=[[NSMutableArray alloc]initWithObjects: @"first_name",@"last_name",@"mobile_phone",@"desk_phone",@"home_phone",@"email",@"company",@"title",@"address1",@"address2",@"address3",@"suburb",@"post_code",@"city",@"state",@"country",@"logo_url",@"image_url",@"facebook",@"twitter",@"linkedIn",@"skype",@"website", nil];
    
    dictData =[[ NSMutableDictionary alloc]init];
    arrKeysForView =[[NSMutableArray alloc]init];
    for (NSString *key in arrTemp) {
        if (![[dictContact objectForKey:key] isEqualToString:@""]) {
            
            if ([key isEqualToString:@"image_url"] || [key isEqualToString:@"logo_url"] || [key isEqualToString:@"mobile_phone"] || [key isEqualToString:@"email"] || [key isEqualToString:@"website"] || [key isEqualToString:@"first_name"] || [key isEqualToString:@"last_name"] || [key isEqualToString:@"title"] || [key isEqualToString:@"facebook"]||[key isEqualToString:@"twitter"]||[key isEqualToString:@"linkedIn"]||[key isEqualToString:@"skype"]) {
            }
            else
            {
            
                NSString *strKey=[arrKeys objectAtIndex:[arrTemp indexOfObject:key]];
                [arrKeysForView addObject:strKey];
              //  [dictData setObject:[dictContact objectForKey:key] forKey:strKey];
            }
        }
    }
    
    /*
     arrKeyForShare= [[NSMutableArray alloc]initWithObjects:@"sFirstName",@"sLastName",@"sMobile",@"sWork",@"sHome",@"sEmail",@"sCompany",@"sTitle",@"sAddress1",@"sAddress2",@"sAddress3",@"sSuburb",@"sPostcode",@"sCity",@"sState",@"sCountry",@"sLogo",@"sPicture",@"sFacebook",@"sTwitter",@"sLinkedIn",@"sSkype",@"sWebsite", nil];
     
     arrFieldForShare= [[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Mobile",@"Work",@"Home",@"Email",@"Company",@"Title",@"Address1",@"Address2",@"Address3",@"Suburb",@"Postcode",@"City",@"State",@"Country",@"Logo",@"Picture",@"Facebook",@"Twitter",@"Linked In",@"Skype",@"Website", nil];
     
     arrKeyField=[[NSMutableArray alloc]initWithObjects:@"given_name",@"family_name",@"mobile_phone",@"desk_phone",@"home_phone",@"email",@"company",@"title",@"address1",@"address2",@"address3",@"suburb",@"post_code",@"city",@"state",@"country",@"logo",@"image",@"social_facebook",@"social_twitter",@"social_linkedin",@"social_Skype",@"www", nil];
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW  DELEGATE

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrKeysForView count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellDetail"];
    
    cell.lblTitle.text=[arrKeysForView objectAtIndex:indexPath.row];
    
    if ([[arrKeysForView objectAtIndex:indexPath.row] isEqualToString:@"Home"] || [[arrKeysForView objectAtIndex:indexPath.row] isEqualToString:@"Work"] ) {
        
        NSString *filter = @"### ### ####";
        NSString *strContact=filteredPhoneStringFromStringWithFilter([dictData objectForKey:[arrKeysForView objectAtIndex:indexPath.row]], filter);
        
        cell.lblValue.text=strContact;
    }
    else
        cell.lblValue.text=[dictData objectForKey:[arrKeysForView objectAtIndex:indexPath.row]];
    
    if([[arrKeysForView objectAtIndex:indexPath.row] isEqualToString:@"Home"])
    {
        UITapGestureRecognizer *tapGestureHome =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callHomePhone)];
        [cell.lblValue setUserInteractionEnabled:YES];
        [cell.lblValue addGestureRecognizer:tapGestureHome];
    }
    
    if([[arrKeysForView objectAtIndex:indexPath.row] isEqualToString:@"Work"])
    {
        UITapGestureRecognizer *tapGestureWork =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callWorkPhone)];
        [cell.lblValue setUserInteractionEnabled:YES];
        [cell.lblValue addGestureRecognizer:tapGestureWork];
    }
    
    return cell;
}

#pragma mark - Action Method

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Delegate Method

-(void)btnFacebook{
    
    if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
        //        vc.strUrl=@"https://www.facebook.com/tristate777";
        [UIAlertView infoAlertWithMessage:@"You have not Facebook Data!" andTitle:APP_NAME];
    }
    else
    {
        WebViewViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
        vc.strTitle=@"Facebook Profile";
        vc.strUrl=[NSString stringWithFormat:@"https://www.facebook.com/%@",[dictContact objectForKey:@"facebook"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)btnTwitter{
    if ([[dictContact objectForKey:@"twitter"] isEqualToString:@""]) {
        [UIAlertView infoAlertWithMessage:@"You have not Twiiter Data!" andTitle:APP_NAME];
    }
    else
    {
        //        [self followOnTwitter:@"719601974" isID:YES];
        [self followOnTwitter:[dictContact objectForKey:@"twitter"] isID:YES];
    }
}

-(void)btnLinkedIn{
    if ([[dictContact objectForKey:@"facebook"] isEqualToString:@""]) {
        [UIAlertView infoAlertWithMessage:@"You have not LinkedIn Data!" andTitle:APP_NAME];
    }
    else
    {
        WebViewViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
        vc.strTitle=@"LinkedIn Profile";
        vc.strUrl=[dictContact objectForKey:@"linkedIn"];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
}


#pragma mark - Custom Method

-(void)calling{
    
    [self callThisPhone];
}

-(void) callThisPhone
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[dictContact objectForKey:@"mobile_phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Phone call facility is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}

-(void) callHomePhone
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[dictData objectForKey:@"Home"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Phone call facility is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}

-(void) callWorkPhone
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[dictData objectForKey:@"Work"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Phone call facility is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
