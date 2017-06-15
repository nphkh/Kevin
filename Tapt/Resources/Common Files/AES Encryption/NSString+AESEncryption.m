//
//  NSString+AESEncryption.m
//  DentoQ
//
//  Created by Bharat Aghera on 30/12/13.
//  Copyright (c) 2013 Tristate. All rights reserved.
//

#import "NSString+AESEncryption.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "NSData+Base64.h"
#import "Constants.h"

#define WEBSERVICE_CIPHER_KEY @"12iC7UN8744k3S5xYtl1l68uZdME17BX"
#define LOCAL_KEY @"12iC7UN8744k3S5xYtl1l68uZdME17BX"


@implementation NSString (AESEncryption)



-(NSString *) convertToPlainTextDirect:(NSData *)encryptedData
{
     NSError *error=nil;
     NSString* returnString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    
    //NSData *datafrombase64=[NSData dataWithBase64EncodedString:returnString];
    //change
     NSData *datafrombase64=[[NSData alloc] initWithBase64EncodedString:returnString options:0];
    
    
    NSData *decryptedData = [RNDecryptor decryptData:datafrombase64
                                        withPassword:WEBSERVICE_CIPHER_KEY
                                               error:&error];
    
    NSString *strDecrypted = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return strDecrypted;
}


-(NSString *) convertToCipherTextDirectWithNumber:(BOOL) hasNumber
{
  
    NSError *error=nil;
    NSData *data=[self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:WEBSERVICE_CIPHER_KEY
                                               error:&error];
    
    //NSString *strEncr = [encryptedData base64EncodingWithLineLength:0];
    //change
    NSString *strEncr = [encryptedData base64EncodedStringWithOptions:0];
    
    
    
    
/*
 
 ios 7 base64 encoding & decoding
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
 */
    
    
    
    
    if(!hasNumber)
    strEncr=[strEncr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return strEncr;
}


-(NSString *) applyLocalEncryption
{
    NSError *error=nil;
    NSData *data=[self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:LOCAL_KEY
                                               error:&error];
    
    NSString *strEncr = [encryptedData base64EncodingWithLineLength:0];
    
 //   if(!hasNumber)
  //      strEncr=[strEncr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return strEncr;
}


-(NSString *) applyLocalDecryption
{
    NSError *error=nil;
    NSData *datafrombase64=[NSData dataWithBase64EncodedString:self];
    NSData *decryptedData = [RNDecryptor decryptData:datafrombase64
                                        withPassword:LOCAL_KEY
                                               error:&error];
    
    NSString *strDecrypted = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return strDecrypted;
}


@end
