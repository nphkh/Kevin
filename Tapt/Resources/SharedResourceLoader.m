
#import "SharedResourceLoader.h"
//#import "Constant.h"
#import "UIAlertView+utils.h"


static SharedResourceLoader *sharedResource = nil;

@implementation SharedResourceLoader
@synthesize productRequest;

/*
    Shared Object creation for Resource loaded.
 */

+ (id)shareObject {
	@synchronized(self) {
		if(!sharedResource) {
			sharedResource = [[SharedResourceLoader alloc] init];
		}
	}
	return sharedResource;
}
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(!sharedResource) {
			sharedResource = [super allocWithZone:zone];
			return sharedResource;
		} 
	}
	return nil; 
}

- (id)copyWithZone:(NSZone *)zone {	return self; }
- (id)retain { return self;	}
- (unsigned)retainCount { return UINT_MAX; }
- (oneway void)release { }
- (id)autorelease {	return self; }

/*
 Method should be called for getting all details about product based on productID.
 */

-(BOOL)requestForProducts:(NSSet*)set{
    if([SKPaymentQueue canMakePayments]){
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        self.productRequest = request;
        [request release];
        [productRequest start];
        return YES;
    }
    else{
        [UIAlertView infoAlertWithMessage:@"App Purchase features is currently disabled in your phone setting, please enable ‘In-App Purchases’ in General > Restrictions." andTitle:nil];
        return NO;
    }
}

/*
 Method should be called for purchasing product.
 */
-(void)purchaseProduct:(SKProduct*)product{
	//identifier
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)restoreInAppPurchase{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
#pragma mark -
#pragma mark SKRequestDelegate Methods
#pragma mark -

/*
 This method will be called from storekit framework once application will get response for product.
 */

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
   
    NSArray *products = response.products;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductDetailLoaded" object:products];
    if(self.productRequest){
        self.productRequest.delegate = nil;
        self.productRequest = nil;
    }
}
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
//    NSLog(@"hi cancel");
//}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTransaction" object:nil];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


#pragma mark -
#pragma mark Payment Transaction
#pragma mark -

- (void) completeTransaction: (SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSString *productIdentifier = transaction.payment.productIdentifier;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PurchaseDone" object:productIdentifier];
	NSLog(@"Transaction completed!");
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
     NSString *productIdentifier = transaction.payment.productIdentifier;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"restoreComplete" object:productIdentifier];
	NSLog(@"Transaction restored!");
}


//- (void) failedTransaction: (SKPaymentTransaction *)transaction {
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTransaction" object:nil];
//    }

- (void) failedTransaction: (SKPaymentTransaction *)transaction {
    NSError *error=transaction.error;
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTransaction" object:nil];
    if(error)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"restoreComplete" object:queue];
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTransaction" object:nil];
}
/*
Payment delegate method for updating status of payment queue.
 */

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {

	for (SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
				
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
				
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
				
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
				
            default:
                break;
        }
    }
}

@end
