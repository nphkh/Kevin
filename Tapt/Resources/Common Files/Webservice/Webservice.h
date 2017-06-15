

#import <Foundation/Foundation.h>
#import "NSString+AESEncryption.h"

typedef void(^ResponseReceivedSuccessfully)(id jsonObj);
typedef void(^ResponseFail)(NSError *error);
typedef void(^DataRateProgress)(float progressInPercent);



@protocol WebserviceDelegate;

@interface Webservice : NSObject {
	NSURLConnection *conn;
	NSMutableData *mutableData;
    BOOL busy;
    long long expectedContentLength;
    BOOL encryptionOn;
}


@property (nonatomic) BOOL busy;
@property (nonatomic,strong) ResponseReceivedSuccessfully responseSuccessful;
@property (nonatomic,strong) ResponseFail responseFail;
@property (nonatomic,strong) DataRateProgress progressblock;

-(void)cancelWebservice;

-(void)callPostWebService:(NSString *) params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;

-(void)callPostWebServiceNew:(NSMutableDictionary *) params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;

-(void) callGetWebServiceUsingURL:(NSURL *) url onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;


-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;

-(void)callJSONMethod:(NSString *)methodName withImage:(NSData*)imageData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock;

-(void)callPOSTWebServiceWithImage:(NSData*)imageData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock;

@end

