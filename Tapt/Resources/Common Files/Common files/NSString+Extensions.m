//
//  NSString+Extensions.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extensions.h"
#include <sys/xattr.h>
#import "AppDelegate.h"
#import "UIDevice+IdentifierAddition.h"
#import "Constants.h"



@implementation NSString (Extensions)


- (BOOL)addSkipBackupAttribute
{
    const char* filePath = [self fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (NSString *)documentsDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	return documentsDirectory;
}

- (NSString *)cacheDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return documentsDirectory;
}

- (NSString *)privateDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

- (NSString *)pathInDocumentDirectory
{
	NSString *documentsDirectory = [self documentsDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInCacheDirectory
{
	NSString *documentsDirectory = [self cacheDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInPrivateDirectory
{
	NSString *documentsDirectory = [self privateDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo
{
	NSString *documentsDirectory = nil;
    if (yesOrNo) {
        documentsDirectory = [self cacheDirectoryPath];
    }
    else {
        documentsDirectory = [self documentsDirectoryPath];
    }
	NSString *dirPath = [documentsDirectory stringByAppendingString:dir];
	NSString *path = [dirPath stringByAppendingString:self];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return path;
}

- (NSString *)pathInDirectory:(NSString *)dir
{
    return [self pathInDirectory:dir cachedData:YES];
}

- (NSString *)removeWhiteSpace
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement
{
	NSMutableString* result = [NSMutableString string];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	while (![scanner isAtEnd]) {
		if ([scanner scanCharactersFromSet:characterSet intoString:NULL]) {
			[result appendString:replacement];
		}
		NSString* stringPart = nil;
		if ([scanner scanUpToCharactersFromSet:characterSet intoString:&stringPart]) {
			[result appendString:stringPart];
		}
	}
			
	return result;
}

- (NSString *)bindSQLCharacters
{
	NSString *bindString = self;

	bindString = [bindString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	
	return bindString;
}

- (NSString *)trimSpaces
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
}

+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

// Range must be in {a,b}. Where a is mimimum length and b is max length
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange
{
	BOOL valid = NO;
	NSCharacterSet *alphaNums = [NSCharacterSet alphanumericCharacterSet];
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
	BOOL isAlphaNumeric = [alphaNums isSupersetOfSet:inStringSet];
	if(isAlphaNumeric){
		NSString *emailRegex = [NSString stringWithFormat:@"[%@]%@",candidate, strRange]; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		valid =[emailTest evaluateWithObject:candidate];
	}
	return valid;
}
+(NSString*)exceptNULLString:(NSString*)strNull{
    if((NSNull*) strNull == [NSNull null])
        return @"";
    if(!strNull)
        return @"";
    return strNull;
}

- (NSString *) substituteEmoticons {
    //See http://www.easyapns.com/iphone-emoji-alerts for a list of emoticons available
    NSString *res = [self stringByReplacingOccurrencesOfString:@":)" withString:@"\ue415"];
    res = [res stringByReplacingOccurrencesOfString:@":(" withString:@"\ue403"];
    res = [res stringByReplacingOccurrencesOfString:@";-)" withString:@"\ue405"];
    res = [res stringByReplacingOccurrencesOfString:@":-x" withString:@"\ue418"];
    return res;
}

+(NSString *) getCommonDate:(NSDate *) date
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *) getCommonDateForChatList:(NSDate *) date
{
    NSString *dateToReturn=nil;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
       dateToReturn=@"Today";
    }
    else
    {
        dateToReturn=[dateFormatter stringFromDate:date];
    }
    return dateToReturn;
}

+(NSString*) getDateForConversation:(NSDate *) date
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    return [dateFormatter stringFromDate:date];
}




+(NSString*) getDurationFromDate:(NSDate *)lastdate
{
    NSTimeInterval theTimeInterval =[[NSDate date] timeIntervalSinceDate:lastdate];
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit|NSSecondCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSMutableString *strTime=[[NSMutableString alloc] init];
    
    
    
    if([breakdownInfo month]!=0)
        [strTime appendFormat:@"%dmo ",(int)[breakdownInfo month]];
    
    else if([breakdownInfo day]!=0)
        [strTime appendFormat:@"%dd ",(int)[breakdownInfo day]];
    
    else if([breakdownInfo hour]!=0)
        [strTime appendFormat:@"%dh ",(int)[breakdownInfo hour]];
    
    else if([breakdownInfo minute]!=0)
        [strTime appendFormat:@"%dm ",(int)[breakdownInfo minute]];
    
    else if([breakdownInfo second]!=0)
        [strTime appendFormat:@"%ds ",(int)[breakdownInfo second]];
    
    
    
    
    return [strTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


+ (void)saveAsCacheFile:(NSString*)fileName Data:(NSDictionary *)dictSaveInstance {
    //[self writeToFile:[fileName pathInDirectory:@"/Response/" cachedData:YES] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictSaveInstance];
    [data writeToFile:[fileName pathInDirectory:@"/Response/" cachedData:YES] atomically:NO];
}
+ (NSDictionary*)readCacheFile:(NSString*)fileName{
    
    NSData *dataget=[NSData dataWithContentsOfFile:fileName];
    NSDictionary *dictSaveInstance = [NSKeyedUnarchiver unarchiveObjectWithData:dataget];
    return dictSaveInstance;
    // return [NSString stringWithContentsOfFile:[fileName pathInDirectory:@"/Response/" cachedData:YES] encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *) responseCachePath
{
    NSString *filePath=@"";
    filePath=[filePath cacheDirectoryPath];
    filePath=[[NSString stringWithFormat:@"%@/Response",filePath] stringByAppendingPathComponent:self];
    return filePath;
}

-(BOOL)isURL
{
   
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detect matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return (matches!=nil && [matches count]>0)?YES:NO;
}

- (NSString *)extentionOfFile
{
    NSArray *arrTemp=[self componentsSeparatedByString:@"."];
    if(arrTemp.count>0)
    {
        return [[arrTemp objectAtIndex:arrTemp.count-1] lowercaseString];
    }

return nil;
}

-(NSString *) mimeTypeOfFile
{
    if([[self lowercaseString]isEqualToString:@"png"])
        return @"image/png";
    else if([[self lowercaseString]isEqualToString:@"jpeg"]||[[self lowercaseString]isEqualToString:@"jpg"])
        return @"image/jpeg";
    else if([[self lowercaseString]isEqualToString:@"wav"])
        return @"audio/wav";
    else if([[self lowercaseString]isEqualToString:@"caf"])
        return @"audio/x-mpegurl";
    else if([[self lowercaseString]isEqualToString:@"aac"])
        return @"audio/aac";
    else if([[self lowercaseString]isEqualToString:@"mp3"])
        return @"audio/x-mpegurl";
    else if([[self lowercaseString]isEqualToString:@"mov"])
        return @"video/quicktime";
    else if([[self lowercaseString]isEqualToString:@"txt"])
        return @"text/plain";
    
    return @"";
    
}


- (BOOL)isValidExtention
{
    if([[self lowercaseString]isEqualToString:@"png"]||[[self lowercaseString]isEqualToString:@"jpg"]||[[self lowercaseString]isEqualToString:@"jpeg"]||[[self lowercaseString]isEqualToString:@"mov"]||[[self lowercaseString]isEqualToString:@"wav"]||[[self lowercaseString]isEqualToString:@"caf"]||[[self lowercaseString] isEqualToString:@"mp3"]||[[self lowercaseString] isEqualToString:@"aac"])
    return YES;
    
    return NO;
        
}


-(BOOL) isValidImageURL
{
    if([[self lowercaseString]isEqualToString:@"png"]||[[self lowercaseString]isEqualToString:@"jpg"]||[[self lowercaseString]isEqualToString:@"jpeg"])
        return YES;
    
    return NO;
}

-(NSString*) descriptivePathOfImage
{
   // [self stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    NSArray *arrTemp=[self componentsSeparatedByString:@"/"];
    int deletethispath=0;
    deletethispath=(int)arrTemp.count-2;
    NSMutableString *realPath=[[NSMutableString alloc] init];
    for (int i=0;i<arrTemp.count;i++) {
        if(i==deletethispath)
            continue;
        [realPath appendFormat:@"%@",[arrTemp objectAtIndex:i]];
        
        if( i!=arrTemp.count-1 )
            [realPath appendFormat:@"/"];
    }
    return realPath;
    
}

- (NSString *)messageForMMS
{
    NSString *message=self;
if([[self extentionOfFile] isEqualToString:@"jpg"]||[[self extentionOfFile] isEqualToString:@"jpeg"]||[[self extentionOfFile] isEqualToString:@"png"])
{
message=@"Photo";
}
    else if([[self extentionOfFile] isEqualToString:@"aac"]||[[self extentionOfFile] isEqualToString:@"wav"]||[[self extentionOfFile] isEqualToString:@"mp3"])
    {
    message=@"Voice message";
    }
    else if([[self extentionOfFile] isEqualToString:@"mov"])
    {
        message=@"Video message";
    }
    return message;
}


//Check whether it is valid Sound Message Or Video Link.
-(BOOL) isRealAudioOrVideoLink
{
    BOOL isAudioOrVideo=NO;
    return isAudioOrVideo;
}

+(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}


-(NSString *) removeCharFromPhoneBookNumber
{
   
        NSMutableString *str=[NSMutableString string];
        for (int i=0;i<self.length;i++) {
            
            NSString *temp=[self substringWithRange:NSMakeRange(i, 1)];
            if(!([temp isEqualToString:@" "]|| [temp isEqualToString:@"("]||[temp isEqualToString:@")"]||[temp isEqualToString:@"-"] || [temp isEqualToString:@"\\U00a0"]))
            {
                [str appendString:temp];
            }
            
        }
        return (NSString*)str;
}


+(NSString *) numOFDayInWeek
{
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    //[myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
    [myFormatter setDateFormat:@"c"]; // day number, like 7 for saturday
    
    NSString *dayOfWeek = [myFormatter stringFromDate:today];
    
    if([dayOfWeek intValue]==1)
        dayOfWeek=@"7";
    else
        dayOfWeek=[NSString stringWithFormat:@"%d",[dayOfWeek intValue]-1];
    
    return dayOfWeek;
}









+(id) getMutableObject:(id) objToMakeMutable
{

    id objToReturn=nil;
    
    if([objToMakeMutable isKindOfClass:[NSDictionary class]])
    {
    
       
        objToReturn=[[NSMutableDictionary alloc] initWithDictionary:objToMakeMutable];
        
        for (id obj in [(NSDictionary *)objToReturn allKeys])
        {
            [self getMutableObject:[objToReturn objectForKey:obj]];
        }
        
    }
    
    else if ([objToMakeMutable isKindOfClass:[NSArray class]])
    {
        
       objToReturn=[[NSMutableArray alloc] initWithArray:objToMakeMutable];
       
        for (id obj in objToMakeMutable)
        {
            [self getMutableObject:obj];
        }
        
    }
    
    if(objToMakeMutable==nil)
    {
        objToReturn=objToMakeMutable;
    }
    
    return objToMakeMutable;
}


+(NSString *)getAlphaNumericValue
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:10];
    for (NSUInteger i = 0U; i < 5; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

+(NSString *) getUniqueNameForFile
{

    NSString *strID=[[UIDevice currentDevice] getUniqueIdOfDevice];
    strID=[NSString stringWithFormat:@"%d_%@",((int)[[NSDate date] timeIntervalSince1970]),strID];
    return strID;
    
}


-(BOOL) isValidURL
{

    NSString *urlString = self;
    NSString *urlRegEx =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlPredic = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL isValidURL = [urlPredic evaluateWithObject:urlString];
    return isValidURL;
}

-(BOOL) isValidPhoneNo
{
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [self length]);
    NSArray *matches = [detector matchesInString:self options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}

//dd-MM-yyyy
-(NSString *) covertToyyyyMMddFromddMMyyyy
{
    
    NSArray *arrObj=[self componentsSeparatedByString:@"-"];
    NSString *strDateConv=self;
    
    if([arrObj count]==3)
    strDateConv=[NSString stringWithFormat:@"%@-%@-%@",[arrObj objectAtIndex:2],[arrObj objectAtIndex:1],[arrObj objectAtIndex:0]];
    
    return strDateConv;
    
}


+(void) saveFBTWDetailsDict:(NSDictionary *) dictParam
{
 
    NSString *filePath = [@"fbtw" pathInDocumentDirectory];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    if(dictParam!=nil)
    [dictParam writeToFile:filePath atomically:YES];
}

+(NSDictionary*) getFbTwDetails
{
    NSString *filePath = [@"fbtw" pathInDocumentDirectory];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

-(void) callThisPhone
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
     
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self]];
    } else {
        
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Phone call facility is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
    }

}



//--------------------------password Checker -------------
+(PasswordStrengthType)checkPasswordStrength:(NSString *)password {
    int len = (int)password.length;
    //will contains password strength
    int strength = 0;
    
    if (len == 0) {
        return PasswordStrengthTypeWeak;
    } else if (len <= 5) {
        strength++;
    } else if (len <= 10) {
        strength += 2;
    } else{
        strength += 3;
    }
    
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_UPPERCASE caseSensitive:YES];
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_LOWERCASE caseSensitive:YES];
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_NUMBER caseSensitive:YES];
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_SYMBOL caseSensitive:YES];
    
    if(strength <= 3){
        return PasswordStrengthTypeWeak;
    }else if(3 < strength && strength < 6){
        return PasswordStrengthTypeModerate;
    }else{
        return PasswordStrengthTypeStrong;
    }
}

// Validate the input string with the given pattern and
// return the result as a boolean
+ (int)validateString:(NSString *)string withPattern:(NSString *)pattern caseSensitive:(BOOL)caseSensitive
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:((caseSensitive) ? 0 : NSRegularExpressionCaseInsensitive) error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = 0;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = 1;
    
    return didValidate;
}


//new Phone Number Format


NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter)
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}


@end