//
//  Card1View.h
//  Tapt
//
//  Created by Parth on 28/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Card1CustomDlegate <NSObject>

-(void)btnFacebook;
-(void)btnTwitter;
-(void)btnLinkedIn;

@end


@interface Card1View : UIView

@property (strong,nonatomic) id<Card1CustomDlegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG;


@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG;



@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG;



@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePicContent;


@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIImageView *imgFacebookIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIImageView *imgTwitterIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIImageView *imgLinkeInIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnSkyeName;
@property (strong, nonatomic) IBOutlet UIImageView *imgSkypeIcon;

- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)btnLinkedInAction:(id)sender;
- (IBAction)btnSkypeAction:(id)sender;


@end
