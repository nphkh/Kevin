//
//  HomeViewController.h
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BaseViewContoller.h"

@interface HomeViewController : BaseViewContoller<MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    CLLocationCoordinate2D currentLocation;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UITextField *txtFieldCheck;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
- (IBAction)btnProfileAction:(id)sender;
- (IBAction)btnSendAction:(id)sender;
- (IBAction)btnMyContactAction:(id)sender;
- (IBAction)btnReceiveAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtEvent;
@property (strong, nonatomic) IBOutlet UIView *containerView;


@end
