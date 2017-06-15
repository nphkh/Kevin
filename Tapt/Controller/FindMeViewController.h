//
//  FindMeViewController.h
//  Tapt
//
//  Created by TriState  on 7/17/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewContoller.h"
#import "MapAnnotation.h"
#import "Database.h"
#import "LFRoundProgressView.h"
#import "CalloutMapAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import "CalloutView.h"
#import "MyAnnotation.h"
#import "CalloutMapAnnotationView.h"
@interface FindMeViewController : BaseViewContoller<MKMapViewDelegate,CLLocationManagerDelegate,CalloutViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    CLLocationCoordinate2D currentLocation;
    CLLocationManager *locationManager;
    
    int flagonecontact;
    NSMutableArray *arrFriends;
    UIView *customview;
    NSTimer *timer;
    NSString *SessionId;
    NSString *contactId;
    
    int flagcallingservice;
    int flagsecondtocall;
    
    IBOutlet CalloutView *calloutView;
    float clicklat;
    float clicklongt;
    
    MapAnnotation *mapAnnot;
    MKPointAnnotation *anotation;

}
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapFindMe;
@property (strong, nonatomic) IBOutlet LFRoundProgressView *FindMeProgress;


@property (nonatomic, strong) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, strong) MKAnnotationView *selectedAnnotationView;
@property (strong,nonatomic)NSMutableArray *arrLocationData;

//callout view contstrints
@property (strong, nonatomic) IBOutlet UITableView *tblCalloutViewFriends;

@property (strong, nonatomic) IBOutlet UILabel *lblHeaderText;
@property (strong, nonatomic) IBOutlet UIView *viewFriendList;
@property (strong, nonatomic) IBOutlet UITableView *tblFriendLIst;


@end
