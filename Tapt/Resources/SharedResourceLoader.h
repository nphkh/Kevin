

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SharedResourceLoader : NSObject <SKPaymentTransactionObserver,SKRequestDelegate,SKProductsRequestDelegate> {
    SKProductsRequest *productRequest;
}
@property (nonatomic, retain) SKProductsRequest *productRequest;

-(void)purchaseProduct:(SKProduct*)product;
+ (id)shareObject;
-(BOOL)requestForProducts:(NSSet*)set;

-(void)restoreInAppPurchase;
@end


