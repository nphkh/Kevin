
#import "Webservice.h"
#import "Constants.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "UIAlertView+utils.h"

@implementation Webservice

@synthesize busy;
@synthesize responseSuccessful;
@synthesize responseFail;


-(void)callPostWebService:(NSString *) params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam{
    NSData *parameterData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURL *url = [NSURL URLWithString:WEBSERVICE_URL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)callPostWebServiceWithJSONBody:(NSMutableDictionary *) params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{
  
}

-(void)callPostWebServiceNew:(NSMutableDictionary *) params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam{
    
    busy = YES;
    NSURL *url=nil;
    [self cancelWebservice];
    
    url = [NSURL URLWithString:WEBSERVICE_URL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    NSString *strRequest=@"";
    
    //@"action=update&version=1.14&id=%@&given_name=%@&family_name=%@&mobile_phone=%@&desk_phone=%@&home_phone=%@&email=%@&company=%@&title=%@&address1=%@&address2=%@&address3=%@&suburb=%@&post_code=%@&city=%@&state=%@&country=%@&password=%@"
    
    for(NSString *key in [params allKeys]){
        if ([strRequest isEqualToString:@""]) {
            strRequest = [NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]];
        }
        else
        {
            strRequest = [strRequest stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,[params objectForKey:key]]];
        }        
    }
    
    NSData *parameterData = [strRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  
    //KHANG: temp fix. The code is horible
  if ([params[@"action"]  isEqual:@"checkAuth"] || [params[@"action"] isEqualToString:@"new"]) {
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:bodyData];
  } else {    
    [theRequest setHTTPBody:parameterData];
  }
  
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];  

}


//Change
-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict))responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{
    
    busy = YES;
    NSURL *url=nil;
    [self cancelWebservice];
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    encryptionOn=isencrypted;
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url=[NSURL URLWithString:WEBSERVICE_URL];
    
    
    
    //Add AuthToken if available
    if(!params)
    params=[NSMutableDictionary dictionary];
    
    
    //
    
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
    
    NSString *strRequest =nil;
    NSString *jsonString=[requestDict JSONRepresentation];
    
    if(isencrypted)
        strRequest = [NSString stringWithFormat:@"json=%@",[jsonString convertToCipherTextDirectWithNumber:NO]];
	else
    
        strRequest = [NSString stringWithFormat:@"json=%@",jsonString];
    
    
    NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
    
	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)callPOSTWebServiceWithImage:(NSData*)imageData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock
{
    
    busy = YES;
    NSURL *url=	nil;
    [self cancelWebservice];
    encryptionOn=isencrypted;
    
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    self.progressblock=proBlock;
    
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url=[NSURL URLWithString:WEBSERVICE_URL];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];

    for(NSString *key in [params allKeys]){
        NSString *strRequest = [NSString stringWithFormat:@"%@",[params objectForKey:key]];
        
        NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *paramsFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendData:[paramsFormat dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"afile\"; filename=\"temp.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)callJSONMethod:(NSString *)methodName withImage:(NSData*)imageData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock
{
    
    busy = YES;
    NSURL *url=	nil;
    [self cancelWebservice];
    encryptionOn=isencrypted;
    
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    self.progressblock=proBlock;
    
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url=[NSURL URLWithString:WEBSERVICE_URL];
    
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
	
    NSString *strRequest=nil;
     NSString *jsonString=[requestDict JSONRepresentation];
    
    if(encryptionOn)
        strRequest = [NSString stringWithFormat:@"%@",[jsonString convertToCipherTextDirectWithNumber:YES]];
    else
        strRequest = [NSString stringWithFormat:@"%@",jsonString];
    
    
	NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *paramsFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"json"];
    [body appendData:[paramsFormat dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"pi_uploaded_image\"; filename=\"temp.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void) callGetWebServiceUsingURL:(NSURL *) url onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{

    [self cancelWebservice];
     busy = YES;
     encryptionOn=NO;
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    
    mutableData = [[NSMutableData alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

-(void)cancelWebservice{
    busy = NO;
    if(mutableData){
        [mutableData setLength:0];
        mutableData = nil;
    }
    if(conn){
        [conn cancel];
        conn = nil;
    }
    self.responseFail=nil;
    self.responseSuccessful=nil;
    self.progressblock=nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)conection didReceiveResponse:(NSURLResponse *)response{
    expectedContentLength = response.expectedContentLength;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
		
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    busy = NO;
    if(mutableData){
		[mutableData setLength:0];
		mutableData = nil;
	}
	if(conn){
		
		conn = nil;
	}
	
	self.responseFail(error);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    busy = NO;
	NSString* returnString = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    
    if(encryptionOn)
    returnString=[returnString convertToPlainTextDirect:mutableData];
    
    returnString = [returnString stringByReplacingOccurrencesOfString:@"__u0022__" withString:@"''"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"__u0026__" withString:@"&"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"__u000a__" withString:@"\\n"];
    id dict = [returnString JSONValue];
	
    if(mutableData){
		[mutableData setLength:0];
		mutableData = nil;
	}
	if(conn){
		
		conn = nil;
	}    
    
    BOOL isTokenValid=YES;
    
    if([dict isKindOfClass:[NSDictionary class]])
    {
        if(![[(NSDictionary *)dict objectForKey:@"status"] isEqualToString:@"1"] && ![[(NSDictionary *)dict objectForKey:@"status"] isEqualToString:@"0"])
        {
            isTokenValid=NO;
        }
    }
   
    self.responseSuccessful(dict);
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    if(self.progressblock){
        
        float percent=totalBytesWritten*100.0f/totalBytesExpectedToWrite;
        NSLog(@"PER - %f",percent);
        self.progressblock(percent);
    }
}


-(void)dealloc{
    if(mutableData){
		[mutableData setLength:0];
		mutableData = nil;
	}
	if(conn){
		conn = nil;
	}
    
    self.responseFail=nil;
    self.responseSuccessful=nil;
    self.progressblock=nil;
  
}

-(NSString *) getJsonFromDictionary:(NSDictionary *) dictData
{
    NSString *jsonString=nil;
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}


-(id) getJsonDictFromString:(NSString *)strPatam
{
  NSData *data = [strPatam dataUsingEncoding:NSUTF8StringEncoding];
  id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}


@end
