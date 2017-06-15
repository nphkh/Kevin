//
//  MyAnnotation.h
//  JOINTLY
//
//  Created by Upendra Patel on 20/01/14.
//  Copyright (c) 2014 Upendra Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>

@property (strong,nonatomic)NSString *strName;
@property (strong,nonatomic)NSString *strAddress;
@property (strong,nonatomic)NSString *strDistance;
@property (nonatomic)CLLocationCoordinate2D coordinate1;
@property (nonatomic)NSInteger iTag;
@property(nonatomic,strong)UIImageView *leftCalloutAccessoryView;

@property (nonatomic,strong)NSMutableDictionary *dictAnnotation;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
