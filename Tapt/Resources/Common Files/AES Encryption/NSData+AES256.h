
#import <Foundation/Foundation.h>

@interface NSData (AES256)

+ (NSData *) base64DataFromString:(NSString *)string;

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
- (NSString *)hexadecimalString;
@end
