//
//  AppDelegate.m
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Database.h"
#import <objc/runtime.h>
@interface AppDelegate ()

@property (nonatomic) float *curLat;
@property (nonatomic) float *curLong;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
//  SEL useSafariSel = sel_getUid("useSafariViewControllerForDialogName:");
//  SEL useNativeSel = sel_getUid("useNativeDialogForDialogName:");
//  Class FBDialogConfigClass = NSClassFromString(@"FBDialogConfig");
//  
//  Method useSafariMethod = class_getClassMethod(FBDialogConfigClass, useSafariSel);
//  Method useNativeMethod = class_getClassMethod(FBDialogConfigClass, useNativeSel);
//  
//  IMP returnNO = imp_implementationWithBlock(^BOOL(id me, id dialogName) {
//    return NO;
//  });
//  method_setImplementation(useSafariMethod, returnNO);
//  
//  IMP returnYES = imp_implementationWithBlock(^BOOL(id me, id dialogName) {
//    return YES;
//  });
//  method_setImplementation(useNativeMethod, returnYES);
  
  
    [Database createEditableCopyOfDatabaseIfNeeded];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *rootVC;
//        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstTime"]){
//            rootVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        }
//        else{
//            rootVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
//        }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstTime"]){
        //rootVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        //30-Jun-15
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isContact"] isEqualToString:@"1"]) {
            rootVC = [storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
        }
        else{
            rootVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
        }
    }
    else{
        rootVC = [storyboard instantiateViewControllerWithIdentifier:@"SocialLoginViewController"];
    }
    
    UINavigationController *navVC=[storyboard instantiateViewControllerWithIdentifier:@"navController"];
    navVC.viewControllers = @[rootVC];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible]; 
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //for checking for calling userstatastic
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];
    
    
    //code for calling usage status for one time in week
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"DateForUsasestatus"])
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"DateForUsasestatus"]doubleValue]];
        NSLog(@"%@",date);
        
        NSString *start =[NSString stringWithFormat:@"%@",date];
        NSString *end =[NSString stringWithFormat:@"%@",[NSDate date]];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-ddHH:mm:ss ZZZ"];  //yyyy-MM-dd
        [f setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
        
        if([components day]>=7)
        {
            [self callwebserviceForUsagestatus];
        }
        
    }

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
   // return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication]|| [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return ([FBAppCall handleOpenURL:url sourceApplication:sourceApplication] || [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation]);

}


-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
}
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    if (self.shouldRotate)
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    else
//        return UIInterfaceOrientationMaskPortrait;
//}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
    if(self.window.rootViewController){
        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        orientations = [presentedViewController supportedInterfaceOrientations];
    }
    
    return orientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)isNetworkReachable{
    return [self isNetworkReachable:@"http://www.google.com"];
}
- (BOOL)isNetworkReachable:(NSString*)NetPath
{
    [[NetworkReachability sharedReachability] setHostName:[NSString stringWithFormat:@"%@",NetPath]];
    NetworkReachbilityStatus remoteHostStatus = [[NetworkReachability sharedReachability] internetConnectionStatus];
    
    if (remoteHostStatus == NetworkNotReachable)
        return NO;
    else if((remoteHostStatus == ReachableViaCarrierDataNetwork) || (remoteHostStatus == ReachableViaWiFiNetwork))
        return YES;
    return NO;
}



#pragma mark-calling webservice 
-(void)callwebserviceForUsagestatus{
   
    if ([self isNetworkReachable])
    {
        if(!self.service)
        {
            self.service=[[Webservice alloc] init];
        }
        
        NSString *str=[NSString stringWithFormat:@"Select * from SubmitUsageStatistics"];
        NSArray *arrtemp=[Database executeQuery:str];
        
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"usageStats" forKey:@"action"];
        [dict setObject:@"1.14" forKey:@"version"];
        [dict setObject:[[arrtemp valueForKey:@"send2friend"]objectAtIndex:0] forKey:@"key1"];
        [dict setObject:[[arrtemp valueForKey:@"tagSearch"]objectAtIndex:0] forKey:@"key2"];
        [dict setObject:[[arrtemp valueForKey:@"shareEmail"]objectAtIndex:0] forKey:@"key3"];
        [dict setObject:[[arrtemp valueForKey:@"shareText"]objectAtIndex:0] forKey:@"key4"];
        [dict setObject:@"" forKey:@"key5"];
        
        NSLog(@"dict := %@", dict);
        [self.service callPostWebServiceNew:dict onSuccessfulResponse:^(NSMutableDictionary *dict) {
            NSLog(@"dict %@",dict);
            if ([[dict objectForKey:@"Response"] isEqualToString:@"Ok" ])
            {
                
                NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                [[NSUserDefaults standardUserDefaults]setObject:timestamp forKey:@"DateForUsasestatus"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                NSString *Query1=[NSString stringWithFormat:@"update SubmitUsageStatistics set send2friend='%d',tagSearch='%d',shareEmail='%d',shareText='%d'",0,0,0,0];
                [Database executeQuery:Query1];
                
                
            }
            else
            {
                
            }
        }
        onFailure:^(NSError *error)
        {
             NSLog(@"%@",error.localizedDescription);
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tapt"
                                                        message:@"Please check your internet connection"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"%@",ALERT_NO_INTERNET);
    }
}

@end
