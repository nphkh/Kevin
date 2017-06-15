//
//  OAuthTwitterDemoViewController.m
//  OAuthTwitterDemo
//
//  Created by Ben Gottlieb on 7/24/09.
//  Copyright Stand Alone, Inc. 2009. All rights reserved.
//

#import "OAuthTwitterDemoViewController.h"
#import "SA_OAuthTwitterEngine.h"


#define kOAuthConsumerKey				@"COs2bdBrLQUYkr6RkJzQCQ"		//REPLACE ME
#define kOAuthConsumerSecret			@"qn0zHcWllp2ToFaTYvgpLWiDDGl8WLgKNcUO820d3nM"		//REPLACE ME

@implementation OAuthTwitterDemoViewController



//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];

	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAuthDAta" object:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



//=============================================================================================================================
//#pragma mark ViewController Stuff
//- (void)dealloc {
//	//[_engine release];
//    [super dealloc];
//}
- (void) viewDidAppear: (BOOL)animated {
	if (_engine)
       return;
    
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
    _engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
    UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	
	if (controller) 
		//[self presentModalViewController: controller animated: YES];
    [self presentViewController:controller animated:YES completion:nil];
	else {
		[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	}

}


@end