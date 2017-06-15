
#import <Foundation/Foundation.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>


#import <Foundation/NSString.h>
@interface NSString (HexaData)

- (NSData *) decodeFromHexidecimal;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end
