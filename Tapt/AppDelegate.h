//
//  AppDelegate.h
//  Tapt
//
//  Created by Parth on 08/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "Webservice.h"
#import "NetworkReachability.h"
#import "Constants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic)int contactindex;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSMutableArray *arrCategoryglobal;
@property (nonatomic,assign)BOOL isimage;
@property (nonatomic,assign)BOOL isLogo;
@property (nonatomic,assign)BOOL shouldRotate;
@property (nonatomic,assign)BOOL isfromSearch;
@property(nonatomic,strong) Webservice *service;
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;
@end

