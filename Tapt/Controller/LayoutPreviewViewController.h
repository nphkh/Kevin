//
//  LayoutPreviewViewController.h
//  Tapt
//
//  Created by Parth on 29/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
#import "BaseViewContoller.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ReceiveTagViewController.h"
#import "ContactViewController.h"

@protocol customLayoutDelegate <NSObject>

-(void)backAction;

@end

@interface LayoutPreviewViewController : BaseViewContoller<MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    CLLocationCoordinate2D currentLocation;
}

@property (strong,nonatomic) id<customLayoutDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;

@property (strong, nonatomic) NSDictionary *dictContact;

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
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG;

@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG;

@property (strong, nonatomic) IBOutlet UILabel *lblMobile;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG;

//view2
@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress3;
@property (strong, nonatomic) IBOutlet UILabel *lblStatePostcode;

@property (strong, nonatomic) IBOutlet UILabel *lblWebsite2;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG2;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle2;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail2;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG2;

@property (strong, nonatomic) IBOutlet UILabel *lblName2;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile2;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG2;



//view3
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite3;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG3;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic3;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle3;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail3;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG3;

@property (strong, nonatomic) IBOutlet UILabel *lblName3;
@property (strong, nonatomic) IBOutlet UILabel *lblMobile3;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG3;

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo3;

//view4
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo4;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail4;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmailBG4;

@property (strong, nonatomic) IBOutlet UILabel *lblWebsite4;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *imgWebsiteBG4;

@property (strong, nonatomic) IBOutlet UILabel *lblMobile4;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *imgCallBG4;

@property (strong, nonatomic) IBOutlet UILabel *lblName4;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle4;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderBG;

- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnOKAction:(id)sender;
//new
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *eventView;

@property (strong, nonatomic) IBOutlet TextFieldValidator *txtEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnTag;
- (IBAction)btnTagAction:(id)sender;

	
@end
