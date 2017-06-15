//
//  NSString+AESEncryption.h
//  DentoQ
//
//  Created by Bharat Aghera on 30/12/13.
//  Copyright (c) 2013 Tristate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AES256.h"
#import "NSString+HexaData.h"




@interface NSString (AESEncryption)

-(NSString *) convertToPlainTextDirect:(NSData *)encryptedData;
-(NSString *) convertToCipherTextDirectWithNumber:(BOOL) hasNumber;


//For Local Encryption

-(NSString *) applyLocalEncryption;
-(NSString *) applyLocalDecryption;

@end
