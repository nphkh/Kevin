//
//  UserDetail.h
//  Tapt
//
//  Created by TriState  on 6/22/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetail : NSObject

@property(strong,nonatomic) NSString *firstName;
@property(strong,nonatomic) NSString *lastName;
@property(strong,nonatomic) NSString *MobileNumber;
@property(strong,nonatomic) NSString *ProfilePhoto;
@property(strong,nonatomic) NSString *homePhone;
@property(strong,nonatomic) NSString *homeEmail;
@property(strong,nonatomic) NSString *homeAddress;
@property(strong,nonatomic) NSString *homeStreet;
@property(strong,nonatomic) NSString *homeCity;
@property(strong,nonatomic) NSString *homeState;
@property(strong,nonatomic) NSString *homeCountry;
@property(strong,nonatomic) NSString *homePostCode;
@property(strong,nonatomic) NSString *companyName;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *officePhonenumber;
@property(strong,nonatomic) NSString *officeMobilenumber;
@property(strong,nonatomic) NSString *officeEmail;
@property(strong,nonatomic) NSString *Website;
@property(strong,nonatomic) NSString *Logoimg;
@property(strong,nonatomic) NSString *officeAddress;
@property(strong,nonatomic) NSString *officeStreet;
@property(strong,nonatomic) NSString *officeCity;
@property(strong,nonatomic) NSString *officeState;
@property(strong,nonatomic) NSString *officeCountry;
@property(strong,nonatomic) NSString *officePostCode;
@property(strong,nonatomic) NSString *cardlayout;
@property(strong,nonatomic) NSString *facebook;
@property(strong,nonatomic) NSString *twitter;
@property(strong,nonatomic) NSString *linkedin;
@property(strong,nonatomic) NSString *skype;


+ (UserDetail *)sharedInstance;

@end
