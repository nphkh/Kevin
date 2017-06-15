//
//  UserDetail.m
//  Tapt
//
//  Created by TriState  on 6/22/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "UserDetail.h"

static UserDetail *sharedObject;

@implementation UserDetail

+ (UserDetail *)sharedInstance
{
    static UserDetail *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedObject.firstName=@"";
        sharedObject.lastName=@"";
        sharedObject.MobileNumber=@"";
        sharedObject.ProfilePhoto=@"";
        sharedObject.homePhone=@"";
        sharedObject.homeEmail=@"";
        sharedObject.homeAddress=@"";
        sharedObject.homeStreet=@"";
        sharedObject.homeCity=@"";
        sharedObject.homeState=@"";
        sharedObject.homeCountry=@"";
        sharedObject.homePostCode=@"";
        sharedObject.companyName=@"";
        sharedObject.title=@"";
        sharedObject.officePhonenumber=@"";
        sharedObject.officeMobilenumber=@"";
        sharedObject.officeEmail=@"";
        sharedObject.Website=@"";
        sharedObject.Logoimg=@"";
        sharedObject.officeAddress=@"";
        sharedObject.officeStreet=@"";
        sharedObject.officeCity=@"";
        sharedObject.officeState=@"";
        sharedObject.officeCountry=@"";
        sharedObject.officePostCode=@"";
        sharedObject.cardlayout=@"";
        sharedObject.facebook=@"";
        sharedObject.twitter=@"";
        sharedObject.linkedin=@"";
        sharedObject.skype=@"";

    });
    return sharedInstance;
    
}


@end
