//
//  InformationViewController.h
//  Tapt
//
//  Created by TriState  on 7/10/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapAnnotation.h"
#import "BaseViewContoller.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "EventContactListViewController.h"
#import "ContactViewController.h"

@interface InformationViewController : BaseViewContoller<MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *arrContactDetail;
    NSMutableArray *arrUserDetail;
    
     CLLocationCoordinate2D currentLocation;
     CLLocationManager *locationManager;
    NSMutableDictionary *infoDict;
    
    UIView  *settingView;
    int flagMenuopen;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)btnBackAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblHeaderText;

@property (strong, nonatomic)NSString *strinfoId;

@property (strong, nonatomic) IBOutlet UILabel *lblContactsince;
@property (strong, nonatomic) IBOutlet UILabel *lblEvent;
@property (strong, nonatomic) IBOutlet MKMapView *mapEventlocation;
- (IBAction)btnAddAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *btnSwitch;

- (IBAction)switchValueChangeAction:(id)sender;

//tabbar action
- (IBAction)btnSendTabAction:(id)sender;
- (IBAction)btnFavoriteTabAction:(id)sender;
- (IBAction)btnReceiveTabAction:(id)sender;
- (IBAction)btnPersoneTabAction:(id)sender;
- (IBAction)btnSettingTabAction:(id)sender;


@end
