//
//  MapAnnotation.h
//  MapViewDemo
//
//  Created by Parth on 07/01/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>

@property (assign,nonatomic) NSInteger index;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;


-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate2d withIndex:(int) paramIndex;
-(MKAnnotationView *)annotationView;

@end
