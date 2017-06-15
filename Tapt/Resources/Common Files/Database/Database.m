

#import "Database.h"
#import <sqlite3.h>
#import "NSString+Extensions.h"

#define DATABASE_NAME @"DB_TAPT.rdb"

static NSInteger DBBUSY;
@implementation Database

+ (void)createEditableCopyOfDatabaseIfNeeded {
	BOOL success;
    NSError *error =nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *writableDBPath= [DATABASE_NAME pathInDocumentDirectory];
    NSLog(@"%@",writableDBPath);
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) {
		return;
	}
	NSString *defaultDBPath = nil;
	defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
	 [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];

}

+(NSString* )getDatabasePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = nil;
	writableDBPath= [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
	return writableDBPath;
	
}

+(BOOL)executeScalerQuery:(NSString*)str{
	str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
	sqlite3_stmt *statement= nil;
	BOOL bRet = NO;
	sqlite3 *database;
	NSString *strPath = [self getDatabasePath];
	while(DBBUSY);
	DBBUSY = 1;
	if (sqlite3_open([strPath UTF8String],&database) == SQLITE_OK) {
		if (sqlite3_prepare_v2(database, [str UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_DONE) {
				bRet = YES;
			}
			sqlite3_finalize(statement);
		} 
		
	}
	DBBUSY = 0;
	sqlite3_close(database);
	return bRet;
}
+(NSMutableArray *)executeQuery:(NSString*)str{
	sqlite3_stmt *statement= nil;
    
	sqlite3 *database;
	NSString *strPath = [self getDatabasePath];
	while(DBBUSY);
	DBBUSY = 1;
	NSMutableArray *allDataArray = [[NSMutableArray alloc] init];
	if (sqlite3_open([strPath UTF8String],&database) == SQLITE_OK) {
		if (sqlite3_prepare_v2(database, [str UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				NSInteger i = 0;
				NSInteger iColumnCount = sqlite3_column_count(statement);
				NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
				while (i< iColumnCount) {
					NSString *str = [self encodedString:(const unsigned char*)sqlite3_column_text(statement, i)];
					NSString *strFieldName = [self encodedString:(const unsigned char*)sqlite3_column_name(statement, i)];
					if(!str)
						str = @"";
					[dict setObject:str forKey:strFieldName];
					i++;
				}
				
				[allDataArray addObject:dict];
			}
		}
		DBBUSY = 0;

		sqlite3_finalize(statement);
	} 
	sqlite3_close(database);
	return allDataArray;
}
+(NSString*)encodedString:(const unsigned char *)ch
{
	NSString *retStr;
	if(ch == nil)
		retStr = @"";
	else
		retStr = [NSString stringWithCString:(char*)ch encoding:NSUTF8StringEncoding];
	return retStr;
}
+(void)update:(NSString*)table data:(NSMutableDictionary*)dict{
	NSString *query = [NSString stringWithFormat:@"update %@ SET ",table];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for(NSString *key in [dict allKeys]){
		NSString *strValue = [NSString stringWithFormat:@"%@ ='%@'",key,[dict objectForKey:key]];
		[array addObject:strValue];
	}
	query = [query stringByAppendingFormat:@"%@",[array componentsJoinedByString:@","]];
	[Database executeQuery:query];
	array = nil;
}
+(void)insert:(NSString*)table data:(NSMutableDictionary*)dict{
	NSString *query = [NSString stringWithFormat:@"Insert Into %@ (",table];
	NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableArray *keyArray = [[NSMutableArray alloc] init];
	for(NSString *key in [dict allKeys]){
		[keyArray addObject:key];
		[dataArray addObject:[NSString stringWithFormat:@"'%@'",[dict objectForKey:key]]];
	}
	query = [query stringByAppendingFormat:@"%@) values (%@)",[keyArray componentsJoinedByString:@","],[dataArray componentsJoinedByString:@","]];
	[Database executeQuery:query];
}
@end
