//
//  CardPreviewView.h
//  Tapt
//
//  Created by Parth on 01/06/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetail.h"

@protocol customDelegatePreview <NSObject>

-(void)backAction;

@end


@interface CardPreviewView : UIView

@property (strong,nonatomic) id<customDelegatePreview>delegate;

-(void) showInView:(UIView *) superView;
@property (strong, nonatomic) IBOutlet UIView *viewSubDialoge;

@property (strong, nonatomic) IBOutlet UIView *viewLayout1;
@property (strong, nonatomic) IBOutlet UIView *viewLayout2;
@property (strong, nonatomic) IBOutlet UIView *viewLayout3;
@property (strong, nonatomic) IBOutlet UIView *viewLayout4;

//view1
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;

//view2
@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress3;
@property (strong, nonatomic) IBOutlet UILabel *lblStatePostcode;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite2;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle2;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail2;
@property (strong, nonatomic) IBOutlet UILabel *lblName2;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile2;

//view3
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite3;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle3;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail3;
@property (strong, nonatomic) IBOutlet UILabel *lblName3;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile3;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo3;

//view4
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo4;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail4;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite4;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile4;
@property (strong, nonatomic) IBOutlet UILabel *lblName4;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle4;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderBG;

- (IBAction)btnCloseAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
- (IBAction)btnOkAction:(id)sender;

@end
