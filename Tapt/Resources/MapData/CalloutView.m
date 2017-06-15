//
//  CalloutView.m
//  JOINTLY
//
//  Created by Upendra Patel on 06/02/14.
//  Copyright (c) 2014 Upendra Patel. All rights reserved.
//

#import "CalloutView.h"

#import "NSString+Extensions.h"
#import "Constants.h"


@implementation CalloutView

@synthesize queue;
//@synthesize lblName;
//@synthesize lblProblem;
@synthesize delegate;
//@synthesize btnDetail;
//@synthesize dictDetail;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)initializeDetail:(NSMutableDictionary *)dictData
{
    self.lblAddress.text=[dictData objectForKey:@"address"];
    
//    
//    lblProblem.text=[[dictData valueForKey:@"name" ] capitalizedString];
////    [[imgPhoto layer] setCornerRadius:35.0f];
////    [imgPhoto setClipsToBounds:YES];
//
//    NSDictionary *dictPhoto = [[dictData objectForKey:@"photos"] objectAtIndex:0];
//    NSString *strPhoto_reference = [dictPhoto objectForKey:@"photo_reference"];
//    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?photo_reference=%@&key=%@&maxwidth=100",strPhoto_reference,kGOOGLE_API_KEY];
//    
//    [imgPhoto setImageWithURL:[NSURL URLWithString:[strURL stringByReplacingOccurrencesOfString:@"@" withString:@"/"]] placeholderImage:[UIImage imageNamed:@"no_image.png"]];
//    lblDistance.text = [dictData objectForKey:@"Distance"];
//// 
////    NSDictionary *geo = [[dictData objectForKey:@"geometry"] objectForKey:@"location"];
////    
////    annotationCoord.latitude =[[geo objectForKey:@"lat"] doubleValue];
////    annotationCoord.longitude=[[geo objectForKey:@"lng"] doubleValue];
////    
////    
////    CLLocation *locationA = [[CLLocation alloc]initWithLatitude:currentCentre.latitude longitude:currentCentre.longitude];
////    CLLocation *locationB = [[CLLocation alloc]initWithLatitude:annotationCoord.latitude longitude:annotationCoord.longitude];
////    CLLocationDistance distanceInMeters = [locationA distanceFromLocation:locationB];
////    
////    NSString *distance_Mi = [NSString stringWithFormat:@"%.2f mi",distanceInMeters];
////    
////    annotation.strDistance = distance_Mi;
//
////    lblProblem.text=[dictData valueForKey:@"vicinity"];
////    CALayer *borderLayer = [CALayer layer];
//    
////    CGRect borderFrame = CGRectMake(0, 0, (imgPhoto.frame.size.width), (imgPhoto.frame.size.height));
////    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
////    [borderLayer setFrame:borderFrame];
////    [borderLayer setBorderWidth:1.0];
////    [borderLayer setBorderColor:[[UIColor colorWithRed:0/255.0 green:71.0/255.0 blue:116.0/255.0 alpha:1.0] CGColor]];
////    [imgPhoto.layer addSublayer:borderLayer];
////    
////    [imgPhoto.layer setBorderColor:[[UIColor blackColor] CGColor]];
////
////    [imgPhoto.layer setMasksToBounds:YES];
////    self.queue = [[NSOperationQueue alloc] init];
////
////
////    if (![[dictData objectForKey:@"icon"]isEqualToString:@""])
////    {
////        NSString *strUrl1;//=[NSString stringWithFormat:@"%@%@",IMG_URL,[dictData objectForKey:@"profile_picture"]];
////            UIImage *image = [self imageIfExist:strUrl1];
////            //        imgPhoto.image = [UIImage imageNamed:@"i8Q8.png"];
////            if(image){
////                imgPhoto.image = image;
////            }
////            else{
////                [activityIndicator startAnimating];
////                
////                strUrl1 = [strUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl1]] queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
////                    if(!error){
////                        imgPhoto.image = [UIImage imageWithData:data];
//                        [activityIndicator stopAnimating];
////                    }
////                }];
////            }
////        }
////        else
////            imgPhoto.image = [UIImage imageNamed:@"no_image.png"];
////    [activityIndicator stopAnimating];
////        NSString *strUrl=[NSString stringWithFormat:@"%@%@",IMG_URL,[dictData objectForKey:@"profile_picture"]];
////        NSURL *url = [NSURL URLWithString:strUrl];
////                NSData *myData = [NSData dataWithContentsOfURL:url];
////        imgPhoto.image=[[UIImage alloc] initWithData:myData];
////    }
////    else
////        imgPhoto.image=[UIImage imageNamed:@"noimage.png"];
}

#pragma mark -Check Image exist or not -

- (UIImage*)imageIfExist:(NSString*)strPhotoURL{
    if((NSNull*)strPhotoURL != [NSNull null]){
        NSString *strPhotoName = [strPhotoURL lastPathComponent];
        NSString *strThumbnailIcon = [strPhotoName pathInDirectory:@"/Images/" cachedData:YES];
        if (![[NSFileManager defaultManager] fileExistsAtPath:strThumbnailIcon]){
            return [UIImage imageWithContentsOfFile:strThumbnailIcon];
        }
        else{
            return [UIImage imageWithContentsOfFile:strThumbnailIcon];
        }
    }
    else{
        return [UIImage imageNamed:@"no_image.png"];
    }
}


-(IBAction)btnCalloutAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(btnCalloutDelegateAction:)] )
        [self.delegate btnCalloutDelegateAction:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	if (CGRectContainsPoint(btnDetail.frame, location))
    {
        if([delegate respondsToSelector:@selector(btnCalloutDelegateAction:)])
            [self.delegate btnCalloutDelegateAction:self];

    }
}

- (IBAction)btnGetDestination:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(btnGetDestinationDelegateAction:)] )
        [self.delegate btnGetDestinationDelegateAction:self];
}
@end
