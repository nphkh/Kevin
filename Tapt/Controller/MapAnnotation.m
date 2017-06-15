//
//  MapAnnotation.m
//  MapViewDemo
//
//  Created by Parth on 07/01/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize index;

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate2d withIndex:(int) paramIndex
{
    self=[super init];
    
    if (self) {
        _title =title;
        _coordinate= coordinate2d;
        self.index=paramIndex;
    }
    
    //self.title=title;
    //self.coordinate=coordinate2d;
    return self;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView=[[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnotation"];
    annotationView.enabled=YES;
    annotationView.canShowCallout=NO;
//    annotationView.image=[UIImage imageNamed:@"map-pin.png"];
    //annotationView.tag=index;
//    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
    
}
@end
