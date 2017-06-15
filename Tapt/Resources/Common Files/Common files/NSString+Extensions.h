//
//  NSString+Extensions.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



#define REGEX_PASSWORD_ONE_UPPERCASE @"^(?=.*[A-Z]).*$"  //Should contains one or more uppercase letters
#define REGEX_PASSWORD_ONE_LOWERCASE @"^(?=.*[a-z]).*$"  //Should contains one or more lowercase letters
#define REGEX_PASSWORD_ONE_NUMBER @"^(?=.*[0-9]).*$"  //Should contains one or more number
#define REGEX_PASSWORD_ONE_SYMBOL @"^(?=.*[!@#$%&_]).*$"  //Should contains one or more symbol

typedef enum {
    PasswordStrengthTypeWeak,
    PasswordStrengthTypeModerate,
    PasswordStrengthTypeStrong
}PasswordStrengthType;



@interface NSString (Extensions)


+ (PasswordStrengthType)checkPasswordStrength:(NSString *)password;
- (BOOL)addSkipBackupAttribute;
- (NSString *)documentsDirectoryPath;
- (NSString *)cacheDirectoryPath;
- (NSString *)privateDirectoryPath;
- (NSString *)pathInDocumentDirectory;
- (NSString *)pathInCacheDirectory;
- (NSString *)pathInPrivateDirectory;
- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo;
- (NSString *)pathInDirectory:(NSString *)dir;
- (NSString *)removeWhiteSpace;
- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
- (NSString *)substituteEmoticons;
- (NSString *)responseCachePath;
- (NSString *)extentionOfFile;
+ (NSString *)getCommonDate:(NSDate *) date;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange;
+ (NSString*)exceptNULLString:(NSString*)strNull;
+ (NSString*) getDurationFromDate:(NSDate *)lastdate;
+(NSString *) getCommonDateForChatList:(NSDate *) date;
+ (void)saveAsCacheFile:(NSString*)fileName Data:(NSDictionary *)dictSaveInstance;
+ (NSDictionary*)readCacheFile:(NSString*)fileName;
- (BOOL)isURL;
- (BOOL)isValidExtention;
- (NSString *)messageForMMS;
+(NSString*) getDateForConversation:(NSDate *) date;
-(NSString*) descriptivePathOfImage;
-(NSString *) mimeTypeOfFile;

+(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar;
-(BOOL) isValidImageURL;
-(NSString *) removeCharFromPhoneBookNumber;


//For WakeMeUp
+(NSString *) numOFDayInWeek;
+(id) getMutableObject:(id) objToMakeMutable;

+(NSString *)getAlphaNumericValue;

+(NSString *) getUniqueNameForFile;
-(NSString *) covertToyyyyMMddFromddMMyyyy;



+(void) saveFBTWDetailsDict:(NSDictionary *) dictParam;
+(NSDictionary*) getFbTwDetails;

-(BOOL) isValidURL;
-(BOOL) isValidPhoneNo;

-(void) callThisPhone;


NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter);

@end
