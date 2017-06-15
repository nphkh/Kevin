//
//  MyAnnotation.m
//  JOINTLY
//
//  Created by Upendra Patel on 20/01/14.
//  Copyright (c) 2014 Upendra Patel. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize strDistance;
@synthesize coordinate1;
@synthesize strName;
@synthesize strAddress;
@synthesize  iTag;
@synthesize dictAnnotation;
@synthesize leftCalloutAccessoryView;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        self.strName = [name copy];
        self.strAddress = [address copy];
        self.coordinate1 = coordinate;
    }
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    if((self = [super init]))
    {
        self.coordinate1=coordinate;
        self.strName=title;
    
    }
    return self;
}
- (NSString *)title {
    return self.strName;
}

- (NSString *)subtitle {
    return [NSString stringWithFormat: @"%@ ",self.strAddress];
//    return self.subtitle;
}
- (NSString *)distance {
    return self.strDistance;
}


- (CLLocationCoordinate2D)coordinate {
    return self.coordinate1;
}

@end
