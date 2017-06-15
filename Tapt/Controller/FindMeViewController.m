 //
//  FindMeViewController.m
//  Tapt
//
//  Created by TriState  on 7/17/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "FindMeViewController.h"

@interface FindMeViewController ()

@end

@implementation FindMeViewController
@synthesize arrLocationData;
- (void)viewDidLoad {
    [super viewDidLoad];
    arrLocationData=[[NSMutableArray alloc]init];
    SessionId=0;
    
    
    self.lblHeaderText.text=@"Waiting...";
    [appDelegate setShouldRotate:YES];
    flagonecontact=0;
    flagsecondtocall=0;
    
    
    [self.tblCalloutViewFriends setBackgroundColor:[UIColor clearColor]];
     self.mapFindMe.delegate=self;
    

    
    //for map
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter=kCLDistanceFilterNone;    //1500
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    flagcallingservice=1;
    
    //for Progressview
    self.FindMeProgress.annular = NO;
    self.FindMeProgress.percentShow = NO;
    self.FindMeProgress.progressBackgroundColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
}

#pragma mark - progress method
- (void)progressChange
{
    NSArray *progressViews = @[self.FindMeProgress];
    
    for (LFRoundProgressView *progressView in progressViews) {
       
        //for checking user join session is yes then call every 30 second
        CGFloat progress;
        if(flagsecondtocall==1)
        {
            progress=progressView.progress +1.0/20.0;
        }
        else{
            progress=progressView.progress +1.0/5.0;
        }
       
        
        progressView.progress = progress;
        
        if (progressView.progress >= 1.0f && [timer isValid]) {
            progressView.progress = 0.f;
           
           if([[userDefault objectForKey:@"isowner"]isEqualToString:@"1"])
           {
               [self callWebserviceForOwner:SessionId];
           }
           else
           {
              [self callWebserviceForFriends:SessionId contactid:contactId];
           }
       }
        
    }
}

- (void)startAnimation
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (IBAction)btnBackAction:(id)sender {
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - calling webservice
-(void)callWebserviceForStartFindMeSession
{
    if ([self isNetworkReachable])
    {
        //[self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"findMe" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"start" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"ownerId"];   //[userDefault objectForKey:@"ID"]
        [dict setObject:[userDefault objectForKey:@"curLat"] forKey:@"lat"];
        [dict setObject:[userDefault objectForKey:@"cutLong"] forKey:@"long"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            //[self hidHud];
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
               
                [dict removeObjectForKey:@"Response"];
               
                for(NSString *str in [dict allKeys])
                {
                    
                    if([str isEqualToString:@"Session"])
                    {
                       
                        SessionId=[dict objectForKey:@"Session"];
                        [userDefault setObject:@"1" forKey:@"isowner"];
                        [self startAnimation];
                        [self callWebserviceForOwner:SessionId];
                     }
                     else if ([str isEqualToString:@"FriendsSession"])
                     {
                        [userDefault setObject:@"0" forKey:@"isowner"];
                        
                         NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
                         
                         for(NSString *strsession in [dict allKeys])
                         {
                             if (![strsession isEqualToString:@"FriendsSession"] && ![strsession isEqualToString:@""])
                             {
                                //SessionId=[strsession stringByReplacingOccurrencesOfString:@"session" withString:@""];
                                NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc]init];
                                 
                                 [dictTemp setObject:[strsession stringByReplacingOccurrencesOfString:@"session" withString:@""] forKey:@"sessionId"];
                                 
                                 [dictTemp setObject:[dict objectForKey:[NSString stringWithFormat:@"%@",strsession]] forKey:@"ContectId"];
                                 
                                 [arrTemp addObject:dictTemp];
                              }
                        
                         }
                        
                         if([[[dict objectForKey:str]stringValue]isEqualToString:@"1"])
                         {
                             
                             if([[[arrTemp valueForKey:@"ContectId"]objectAtIndex:0]isEqualToString:[userDefault objectForKey:@"ID"]])
                             {
                                 SessionId=[[arrTemp valueForKey:@"sessionId"]objectAtIndex:0];
                                 [userDefault setObject:@"1" forKey:@"isowner"];
                                 [self callWebserviceForOwner:SessionId];
                                 [self startAnimation];
                             }
                             else
                             {
                                 flagonecontact=1;
                                 SessionId=[[arrTemp valueForKey:@"sessionId"]objectAtIndex:0];
                                 contactId=[[arrTemp valueForKey:@"ContectId"]objectAtIndex:0];
                                 [self startAnimation];
                                 
                                 [self callWebserviceForFriends:[[arrTemp valueForKey:@"sessionId"]objectAtIndex:0] contactid:[[arrTemp valueForKey:@"ContectId"]objectAtIndex:0]];
                             }
                         }
                         else
                         {
                             [self FetchMultipleDataFromDb:arrTemp];

                         }
     
                     }
                     else if([str isEqualToString:@"owner"])
                     {
                        
                     }
                }
            }
            
            
        }
        onFailure:^(NSError *error)
        {
            NSLog(@"%@",error.localizedDescription);
            [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}

-(void)callWebserviceForFriends:(NSString *)SId contactid:(NSString*)contact_id
{
    NSLog(@"friends");
    if ([self isNetworkReachable])
    {
        //[self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"findMe" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"friend" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"ownerId"];
        [dict setObject:[userDefault objectForKey:@"curLat"] forKey:@"lat"];
        [dict setObject:[userDefault objectForKey:@"cutLong"] forKey:@"long"];
        [dict setObject:SId forKey:@"sessionId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            //[self hidHud];
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
                flagsecondtocall=1;
              
                [self setCordinate:[dict objectForKey:@"lat"] Long:[dict objectForKey:@"long"] contact_id:contact_id];
                
                
               /* CLLocationCoordinate2D  ctrpoint;
                self.mapFindMe.delegate=self;
                ctrpoint.latitude =[[dict objectForKey:@"lat"]doubleValue];
                ctrpoint.longitude=[[dict objectForKey:@"long"]doubleValue];
                
               // NSString *title=@"Friends";     //[self FetchDataFromDb:contact_id];
               
                 //today
                MapAnnotation *mapAnnot=[[MapAnnotation alloc]initWithTitle:[self FetchDataFromDb:contact_id] andCoordinate:(ctrpoint) withIndex:0];
                [self.mapFindMe addAnnotation:mapAnnot];*/
               
                
            }
            
            
        }
        onFailure:^(NSError *error)
        {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}
-(void)callWebserviceForOwner:(NSString *)sessionId
{
    NSLog(@"owner");
    if ([self isNetworkReachable])
    {
       // [self showHud];
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"findMe" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:@"owner" forKey:@"operation"];
        [dict setObject:[userDefault objectForKey:@"Salt"] forKey:@"password"];
        [dict setObject:[userDefault objectForKey:@"ID"] forKey:@"ownerId"]; //
        [dict setObject:[userDefault objectForKey:@"curLat"] forKey:@"lat"];
        [dict setObject:[userDefault objectForKey:@"cutLong"] forKey:@"long"];
        [dict setObject:sessionId forKey:@"sessionId"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict)
        {
            NSLog(@"dict %@",dict);
            //[self hidHud];
            if([[dict objectForKey:@"Response"]isEqualToString:@"Ok"])
            {
               if([[dict objectForKey:@"friend"]isEqualToString:@"0"])
               {
                  /* CLLocationCoordinate2D  ctrpoint;
                   self.mapFindMe.delegate=self;
                   ctrpoint.latitude =[[userDefault objectForKey:@"curLat"]doubleValue];
                   ctrpoint.longitude=[[userDefault objectForKey:@"cutLong"]doubleValue];
                   
                   NSString *title=@"owner";      //[self FetchDataFromDb:contact_id];
                   
                    //today
                   MapAnnotation *mapAnnot=[[MapAnnotation alloc]initWithTitle:title andCoordinate:(ctrpoint) withIndex:0];
                  [self.mapFindMe addAnnotation:mapAnnot];*/
                   
               }
               else
               {
//                   CLLocationCoordinate2D annotationCoord;
//                   MyAnnotation *annotation=[[MyAnnotation alloc]init];
//                   annotation.strName=@"";
//                   annotationCoord.latitude =[[dict objectForKey:@"lat"] doubleValue];
//                   annotationCoord.longitude=[[dict objectForKey:@"long"] doubleValue];
//                   annotation.coordinate1=annotationCoord;
//                   [self.mapFindMe addAnnotation:annotation];
                   flagsecondtocall=1;
                   [self setCordinate:[dict objectForKey:@"lat"] Long:[dict objectForKey:@"long"] contact_id:[dict objectForKey:@"friend"]];
                 }
                
                
            }
            
            
        }
        onFailure:^(NSError *error)
        {
             NSLog(@"%@",error.localizedDescription);
             [self hidHud];
        }];
    }
    else
    {
        [UIAlertView infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APP_NAME];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}
#pragma mark-getting data from database

-(void)FetchMultipleDataFromDb:(NSMutableArray *)arrayfordb
{
    arrFriends=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[arrayfordb count];i++)
    {
        
       
        NSString *query = [NSString stringWithFormat:@"select first_name,last_name from Contact_Detail where contact_id='%@'",[[arrayfordb valueForKey:@"ContectId"]objectAtIndex:i]];
        NSArray *array=[Database executeQuery:query];
        
        
        NSMutableDictionary *tempdict=[[NSMutableDictionary alloc]init];
        if([array count]>0)
        {
            NSString *strname=[NSString stringWithFormat:@"%@ %@",[[array valueForKey:@"first_name"]objectAtIndex:0],[[array valueForKey:@"last_name"]objectAtIndex:0]];
            [tempdict setObject:strname forKey:@"name"];
            
            [tempdict setObject:[[arrayfordb valueForKey:@"sessionId"]objectAtIndex:i] forKey:@"sessionId"];
            [tempdict setObject:[[arrayfordb valueForKey:@"ContectId"]objectAtIndex:i] forKey:@"ContectId"];
            
        }
        [arrFriends addObject:tempdict];
    }
    NSLog(@"%@",arrFriends);
    [self.tblFriendLIst reloadData];
    self.viewFriendList.hidden=NO;
    
    
    /*  NSString *lat=[NSString stringWithFormat:@"%f",currentLocation.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",currentLocation.longitude];
    [self setCordinate:lat Long:longitude];
    
    //    MapAnnotation *mapAnnot=[[MapAnnotation alloc]initWithTitle:@"mul" andCoordinate:(currentLocation) withIndex:0];
    //    self.mapFindMe.delegate=self;
    //    [self.mapFindMe addAnnotation:mapAnnot];*/
    
}

-(NSString *)FetchDataFromDb:(NSString *)contact_id
{
    NSString *query = [ NSString stringWithFormat:@"select first_name,last_name from Contact_Detail where contact_id=%@",contact_id];
    NSArray *array=[Database executeQuery:query];
    
    NSString *strname;
    if(array.count>0)
    {
       strname=[NSString stringWithFormat:@"%@",[[array valueForKey:@"first_name"]objectAtIndex:0]];
    }
    
    return strname;
}


-(void)setCordinate:(NSString *)lat  Long:(NSString *)longitute contact_id:(NSString *)contactID;
{
    
//    CLLocationCoordinate2D  ctrpoint;
//    self.mapFindMe.delegate=self;
//    ctrpoint.latitude =[lat doubleValue];
//    ctrpoint.longitude=[longitute  doubleValue];
//    
//    
//    MapAnnotation *mapAnnot=[[MapAnnotation alloc]initWithTitle:@"" andCoordinate:(ctrpoint) withIndex:0];
//    [self.mapFindMe addAnnotation:mapAnnot];
//    
//    [self zoomToFitMapAnnotations:self.mapFindMe];
    
   
    //today
  /*  CLLocationCoordinate2D annotationCoord;
    MyAnnotation *annotation=[[MyAnnotation alloc]init];
    annotation.strName=@"";
    annotationCoord.latitude =[lat doubleValue];
    annotationCoord.longitude=[longitute doubleValue];
    annotation.coordinate1=annotationCoord;
    [self.mapFindMe addAnnotation:annotation];
    [self zoomToFitMapAnnotations:self.mapFindMe];*/
    
    
    //setlocation for the friends
    NSString *strtitle=[self FetchDataFromDb:contactID];
    
    CLLocationCoordinate2D  ctrpoint;
    self.mapFindMe.delegate=self;
    ctrpoint.latitude =[lat doubleValue];
    ctrpoint.longitude=[longitute  doubleValue];
    
    [self.mapFindMe removeAnnotation:anotation];
    anotation=[[MKPointAnnotation alloc] init];
    anotation.coordinate=ctrpoint;
    anotation.title=strtitle;
    if(![strtitle isEqualToString:@""])
    {
       self.lblHeaderText.text=[NSString stringWithFormat:@"Find %@",strtitle];
    }
    [self.mapFindMe addAnnotation:anotation];
    [self.mapFindMe selectAnnotation:anotation animated:NO];
    
    
    //change currunt location pin as per user location after gettting friends
    [self.mapFindMe removeAnnotation:mapAnnot];
    CLLocationCoordinate2D  curruntpoint;
    curruntpoint.latitude=currentLocation.latitude;
    curruntpoint.longitude=currentLocation.longitude;
    
    mapAnnot=[[MapAnnotation alloc]initWithTitle:@"Me" andCoordinate:(curruntpoint) withIndex:0];
    [self.mapFindMe addAnnotation:mapAnnot];

}

#pragma  mark - MapView Delegate Method -
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation=[locations lastObject];
   // if(newLocation.horizontalAccuracy <= 100.0f)
    //{
        currentLocation=newLocation.coordinate;
        NSLog(@"%f",currentLocation.latitude);
        NSLog(@"%f",currentLocation.longitude);
        
        [userDefault setObject:[NSString stringWithFormat:@"%f", currentLocation.latitude] forKey:@"curLat"];
        [userDefault setObject:[NSString stringWithFormat:@"%f",currentLocation.longitude] forKey:@"cutLong"];
    
    
       //flag for call only one time
        if(flagcallingservice==1)
        {
            flagcallingservice=0;
           
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta =0.9;     //0.005;
            span.longitudeDelta =0.9;    // 0.005;
            region.span = span;
            region.center = newLocation.coordinate;
            MKCoordinateRegion adjustedRegion = [self.mapFindMe regionThatFits:region];
            [self.mapFindMe setRegion:adjustedRegion animated:YES];
            
            mapAnnot=[[MapAnnotation alloc]initWithTitle:@"Me" andCoordinate:(newLocation.coordinate) withIndex:0];
            [self.mapFindMe addAnnotation:mapAnnot];
            
            [self callWebserviceForStartFindMeSession];
        }
       
    //}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapV viewForAnnotation:(id)annotation
{
    
    if([annotation isKindOfClass:[MapAnnotation class]])
    {
         static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
         MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:AnnotationIdentifier];
         annotationView.canShowCallout = YES;
        annotationView.centerOffset = CGPointMake(0,-annotationView.image.size.height/2);
         annotationView.image = [UIImage imageNamed:@"pin_blue.png.png"];
           //annotationView.draggable = YES;
         return annotationView;
    }
    else
    {
         static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
         MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                             reuseIdentifier:AnnotationIdentifier];
         annotationView.canShowCallout = YES;
        annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height/2);
         annotationView.image = [UIImage imageNamed:@"pin_orange.png.png"];
        // annotationView.draggable = YES;
         return annotationView;
     }
    
    
    
    
  /*  if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapFindMe dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
        if (!calloutMapAnnotationView)
        {
            calloutMapAnnotationView =[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"];
            
            calloutView.delegate = self;
            [calloutView initializeDetail:((CalloutMapAnnotation*)annotation).dict];
            [calloutMapAnnotationView.contentView addSubview:calloutView];
        }
        else
        {
            for(CalloutView *callView in [calloutMapAnnotationView.contentView subviews])
            {
                if([callView isKindOfClass:[CalloutView class]])
                {
                    [callView initializeDetail:((CalloutMapAnnotation*)annotation).dict];
                }
            }
        }
        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
        calloutMapAnnotationView.mapView = self.mapFindMe;
        return calloutMapAnnotationView;
    }
    else if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        MKAnnotationView *annotationView =[self.mapFindMe dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin_blue.png"];
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"pin_blue.png.png"];
        annotationView.draggable = YES;
        return annotationView;
    } */
    //return nil;
}

- (void)mapView:(MKMapView *)mV didSelectAnnotationView:(MKAnnotationView *)view
{
  //  self.viewFriendList.hidden=NO;
  
    
    
    /*  if ([view.annotation isKindOfClass:[MyAnnotation class]])
    {
        if(self.calloutAnnotation)
            [self.mapFindMe removeAnnotation: self.calloutAnnotation];
        self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude  andLongitude:view.annotation.coordinate.longitude];
        clicklat=view.annotation.coordinate.latitude;
        clicklongt=view.annotation.coordinate.longitude;
        MyAnnotation *basic = (MyAnnotation*)view.annotation;
        self.calloutAnnotation.dict = basic.dictAnnotation;
        [mV addAnnotation:self.calloutAnnotation];
       // index_map=(int)basic.iTag;
        
        [mV setCenterCoordinate:self.calloutAnnotation.coordinate animated:YES];
        self.selectedAnnotationView = view;
        
    }*/
}
/*- (void)mapView:(MKMapView *)mapVi didDeselectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutAnnotation && view == self.selectedAnnotationView) {
        [self.mapFindMe removeAnnotation: self.calloutAnnotation];
    }
    
  
}

-(void)btnCalloutDelegateAction:(id)obj
{
    NSLog(@"click anotation");
}
-(void)btnGetDestinationDelegateAction:(id)obj{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%lf,%lf&daddr=%f,%f",locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude,clicklat,clicklongt];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
    
} */
-(void)zoomToFitMapAnnotations:(MKMapView*)mv
{
    if([mv.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id <MKAnnotation> annotation in mv.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude)* 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2; // Add a little extra space on the sides
    
    //    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2;
    //    region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * 1.2;
    //    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    //    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    region = [mv regionThatFits:region];
    NSLog(@"lat:= %f   longt:= %f   ",region.span.latitudeDelta,region.span.longitudeDelta);
    if( region.center.longitude==0.00000000 || isnan(region.center.latitude) || isnan(region.center.longitude) || isnan(region.span.latitudeDelta) || isnan(region.span.longitudeDelta)){
        NSLog(@"Invalid region!");
        region.center.longitude=topLeftCoord.longitude*0.3;   //0.3
        region.center.latitude=bottomRightCoord.latitude*0.3; //0.3
        region.span.longitudeDelta=fabs(region.center.longitude*1.2); //1.2
        region.span.latitudeDelta=fabs(region.center.latitude*1.2);   //1.2
        //        region.center.latitude = 37.79664245390046;
        //        region.center.longitude = -122.4050459;
        //        region.span.latitudeDelta = 0.007637751823182271 ; //*1.1;
        //        region.span.longitudeDelta = 0.006497952563222498;  // *1.1;
        [mv setRegion:region animated:YES];
    }else{
        [mv setRegion:region animated:YES];
    }
}
#pragma mark - Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [arrFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
   
//    NSString *strname=[NSString stringWithFormat:@"%@ %@",[[arrFriends  valueForKey:@"first_name"]objectAtIndex:indexPath.row],[[arrFriends valueForKey:@"last_name"]objectAtIndex:indexPath.row]];
    
    cell.textLabel.text=[[arrFriends valueForKey:@"name"]objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.viewFriendList.hidden=YES;
    NSLog(@"%@ %ld",[[arrFriends valueForKey:@"sessionId"]objectAtIndex:indexPath.row],(long)indexPath.row);
    [self startAnimation];

    SessionId=[[arrFriends valueForKey:@"sessionId"]objectAtIndex:indexPath.row];
    contactId=[[arrFriends valueForKey:@"ContectId"]objectAtIndex:indexPath.row];
    
    [self callWebserviceForFriends:[[arrFriends valueForKey:@"sessionId"]objectAtIndex:indexPath.row] contactid:[[arrFriends valueForKey:@"ContectId"]objectAtIndex:indexPath.row]];
}

#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

@end
