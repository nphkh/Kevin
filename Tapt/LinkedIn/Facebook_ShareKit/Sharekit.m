


#import "Sharekit.h"

static Sharekit *share = nil;

@implementation Sharekit
@synthesize _facebook;
@synthesize _permissions;
@synthesize _delegate;
@synthesize accountStore;
@synthesize facebookAccount;
@synthesize accountType;
@synthesize instagram;
@synthesize documentInterActionController;
+ (id)shareObject {
	@synchronized(self) {
		if(!share) {
			share = [[Sharekit alloc] init];
			share._permissions =  [[NSArray arrayWithObjects:
							  @"read_stream", @"publish_stream", @"offline_access",nil] retain];
			Facebook *fc = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID];
			share._facebook = fc;
			[fc release];
			share._facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
			share._facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
			
		}
	}
	return share;
}
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(!share) {
			share = [super allocWithZone:zone];
			return share;
		} 
	}
	return nil; 
}

- (id)copyWithZone:(NSZone *)zone {	return self; }
- (id)retain { return self;	}
- (unsigned)retainCount { return UINT_MAX; }
- (void)release { }
- (id)autorelease {	return self; }


-(BOOL)isIOS6{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer > 6.01) {
        return YES;
    } else {
        return NO;
    }
}



#pragma mark - Facebook-

//ios6+ --- START ---
- (void)FacebookPostMessage:(NSString *)status withImage:(UIImage *)image andUrl:(NSString *)ShareUrl forViewController:(UIViewController *)viewController{
    __block NSString *key = @"me/feed";
    __block NSString *message = status;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:message];
        if (image){
            [mySLComposerSheet addImage:image];
            key = @"me/feed";
        }
        
        [mySLComposerSheet addURL:[NSURL URLWithString:ShareUrl]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:{
                    message = @"Post Canceled";

                }
                    break;
                case SLComposeViewControllerResultDone:{
                    message = @"Post Sucessful";
                }
                    break;
                default:
                    break;
            }
            if ([_delegate respondsToSelector:@selector(fbPostSuccessfulWithKey:withMessage:andData:)]) {
                [_delegate fbPostSuccessfulWithKey:key withMessage:message andData:nil];
            }
        }];
        
        [viewController presentViewController:mySLComposerSheet animated:YES completion:^{

        }];
    }
}
//@"first_name",@"last_name"
- (void)facebookLoginDetail{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        if(!self.accountStore)
            self.accountStore = [[ACAccountStore alloc] init];
        ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        [self.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                                   options:@{ACFacebookAppIdKey: FACEBOOK_APP_ID, ACFacebookPermissionsKey: @[@"email"],ACFacebookAudienceKey:ACFacebookAudienceFriends}
                                                completion:^(BOOL granted, NSError *error) {
                                                    if(granted){
                                                        NSArray *accounts = [self.accountStore accountsWithAccountType:facebookTypeAccount];
                                                        self.facebookAccount = [accounts lastObject];
                                                        [self fetchDetail];
                                                    }else{
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            NSLog(@"%@",error.description);
                                                            if([error code]== ACErrorAccountNotFound){
                                                                [self performSelectorOnMainThread:@selector(perFormActionwithDict:) withObject:@{@"key":@"me",@"message":@"Account not found. Please setup your account in Settings app.",@"info":@"",@"isFail":@YES} waitUntilDone:YES];
                                                            }
                                                            else{
                                                                [self performSelectorOnMainThread:@selector(perFormActionwithDict:) withObject:@{@"key":@"me",@"message":@"Account access denied.",@"info":@"",@"isFail":@YES} waitUntilDone:YES];
                                                            }
                                                        });
                                                    }
                                                }];
    }
    else{
        [self performSelectorOnMainThread:@selector(perFormActionwithDict:) withObject:@{@"key":@"me",@"message":@"Account access denied.",@"info":@"",@"isFail":@YES} waitUntilDone:YES];
    }
    
}

- (void)fetchDetail{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = self.facebookAccount;
    
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(!error){
            NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *dictInfo =[NSJSONSerialization JSONObjectWithData: [meDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options: NSJSONReadingMutableContainers
                                                                             error: nil];
            if (!dictInfo) {
                [self performSelectorOnMainThread:@selector(perFormActionwithDict:) withObject:@{@"key":@"me",@"message":@"Unknown error occured.",@"info":@"",@"isFail":@YES} waitUntilDone:YES];
            }
            else{
                NSMutableDictionary *dict = [dictInfo valueForKey:@"error"];
                if (dict) {
                    NSString *message = [dict objectForKey:@"message"];
                    [self performSelectorOnMainThread:@selector(perFormActionwithDict:) withObject:@{@"key":@"me",@"message":message,@"info":@"",@"isFail":@YES} waitUntilDone:YES];

                }
                else{
                    [self performSelectorOnMainThread:@selector(perFormActionwithDict:) withObject:@{@"key":@"me",@"message":@"",@"info":dictInfo,@"isFail":@NO} waitUntilDone:YES];
                    
                }
            }
        }
    }];
}

-(void)perFormActionwithDict:(NSMutableDictionary*)dictInfo{
    
    NSString *key = [dictInfo valueForKey:@"key"];
    NSString *message = [dictInfo valueForKey:@"message"];
    NSMutableDictionary *dict = [dictInfo valueForKey:@"info"];
    BOOL isFail = [[dictInfo valueForKey:@"isFail"]boolValue];
    
    if (isFail) {
        if ([_delegate respondsToSelector:@selector(fbPostFailWithKey:withError:)]) {
            [_delegate fbPostFailWithKey:key withError:message];
        }
    }
    else{
        if ([_delegate respondsToSelector:@selector(fbPostSuccessfulWithKey:withMessage:andData:)]) {
            [_delegate fbPostSuccessfulWithKey:key withMessage:@"" andData:dict];
        }
    }
}

#pragma mark Twitter Login

- (void)twitterLoginDetail{
    //    if ([self isIOS6]){
    if(!self.accountStore)
        self.accountStore = [[ACAccountStore alloc] init];
    self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:self.accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if(granted)
         {
             NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
             if ([accountsArray count] > 0)
             {
                 ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                 // Creating a request to get the info about a user on Twitter
                 SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                 [twitterInfoRequest setAccount:twitterAccount];
                 // Making the request
                 [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if ([urlResponse statusCode] == 429) {
                             [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Rate limit reached"} waitUntilDone:YES];
                             return;
                         }
                         if (error) {
                             [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":error.localizedDescription} waitUntilDone:YES];
                             return;
                         }
                         if (responseData) {
                             NSError *error = nil;
                             NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                             
                             int tweetID = [NSString stringWithFormat:@"%d",[[(NSDictionary *)TWData objectForKey:@"id"] intValue]];
                             NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                             NSString *name        = [(NSDictionary *)TWData objectForKey:@"name"];
                             int followers         = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                             int following         = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                             int tweets            = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                             NSString *profileImgStrURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                             NSString *bannerImgStrURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                             profileImgStrURL = [profileImgStrURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                             NSString *bannerURLString;
                             if (bannerImgStrURL) {
                                 bannerURLString = [NSString stringWithFormat:@"%@/mobile_retina", bannerImgStrURL];
                             }
                             //set value for dictionary
                             NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                             [dict setValue:[NSString stringWithFormat:@"%d", tweetID] forKey:@"id"];
                             [dict setValue:screen_name forKey:@"screen_name"];
                             [dict setValue:name forKey:@"name"];
                             [dict setValue:[NSString stringWithFormat:@"%d",followers] forKey:@"folloers"];
                             [dict setValue:[NSString stringWithFormat:@"%d",following] forKey:@"following"];
                             [dict setValue:[NSString stringWithFormat:@"%d",tweets] forKey:@"tweets"];
                             [dict setValue:profileImgStrURL forKey:@"profileImgStrURL"];
                             [dict setValue:bannerImgStrURL forKey:@"bannerImgStrURL"];
                             [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":dict,@"message":@""} waitUntilDone:YES];
                         }
                     });
                 }];
             }
             else
             {
                 //                if ([error code] == 6) {
                 [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account access denied, please set up your Twitter account in your device's settings (Settings--> Twitter)."} waitUntilDone:YES];
                 //                }
             }
         }
         else
         {

             [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account access denied, please set up your Twitter account in your device's Settings (Settings--> Twitter)."} waitUntilDone:YES];
        
         }

     }];
//    }
//    else
//    {
//         [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account not found. Please setup your account in settings app."} waitUntilDone:YES];
//    }
}



-(void)performTwitterDelegateMethodwithDict:(NSMutableDictionary *)dict{
    NSMutableDictionary *dictinfo = [dict valueForKey:@"info"];
    NSString *message = [dict valueForKey:@"message"];
    if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)])
        [_delegate twUserDetailWithData:dictinfo withMessage:message];
}

//IOS6 --- end ---

#pragma mark - Follow on TWITTER -

-(void)followOnTwitter:(NSString *)user isID:(BOOL)isID
{
    if(!self.accountStore)
        self.accountStore = [[ACAccountStore alloc] init];
    self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"] parameters:[NSDictionary dictionaryWithObject:user forKey:@"user_id"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            
                            // Filter the preferred data
                             int tweetID = [NSString stringWithFormat:@"%d",[[(NSDictionary *)TWData objectForKey:@"id"] intValue]];
                            NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                            NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                            
                            int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                            int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                            
                            
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            [dict setValue:[NSString stringWithFormat:@"%d", tweetID] forKey:@"id"];
                            [dict setValue:screen_name forKey:@"screen_name"];
                            [dict setValue:name forKey:@"name"];
                            [dict setValue:[NSString stringWithFormat:@"%d",followers] forKey:@"folloers"];
                            [dict setValue:[NSString stringWithFormat:@"%d",following] forKey:@"following"];

                            [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":dict,@"message":@""} waitUntilDone:YES];
                            
                        }
                    });
                }];
            }
            else
            {
                
                [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account access denied, please set up your Twitter account in your device's Settings (Settings--> Twitter)."} waitUntilDone:YES];
                
            }

        }
        else
        {
            [self performSelectorOnMainThread:@selector(performTwitterDelegateMethodwithDict:) withObject:@{@"info":@"",@"message":@"Account access denied, please set up your Twitter account in your device's Settings (Settings--> Twitter)."} waitUntilDone:YES];

        }
    }];

}

-(BOOL)isFBlogin{
    if ([self isIOS6])
        return YES;
    else
        return ([self._facebook isSessionValid]);
}

- (void)loginFacebook {
	[_facebook authorize:_permissions delegate:self];
}

- (void)logoutFacebook {
	[_facebook logout:self];
}


- (void)fbuploadPhoto:(UIImage*)image withMessage:(NSString*)msg withViewController:(UIViewController *)viewController{
	
    if ([self isIOS6]) {
        [self FacebookPostMessage:msg withImage:image andUrl:nil forViewController:viewController];
    }
    else{
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       image, @"source",
                                       msg,@"message",
                                       nil];
        
        [self._facebook requestWithGraphPath:@"me/photos"
                                   andParams:params 
                               andHttpMethod:@"POST" 
                                 andDelegate:self];							 
	}
}

- (void)fbuploadVideo:(NSData*)videoData withTitle:(NSString*)title withDescription:(NSString *)description{
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   videoData, @"video.mov",
                                   @"video/quicktime", @"contentType",
                                   title, @"title",
                                   description, @"description",
								   nil];

	
	[self._facebook requestWithGraphPath:@"me/videos"
                               andParams:params
                           andHttpMethod:@"POST"
                             andDelegate:self];							 
	
}

- (void)fbUserProfile{
    if ([self isIOS6]) {
        [self facebookLoginDetail];
    }
    else
        [self._facebook requestWithGraphPath:@"me" andDelegate:self];						 
}

- (void)fbPublishMessage:(NSString*)message withViewController:(UIViewController *)viewController{
    
    if ([self isIOS6])
        [self FacebookPostMessage:message withImage:nil andUrl:nil forViewController:viewController];
    else
    {
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        message, @"message",
                                        nil];
        
        [_facebook requestWithGraphPath:@"me/feed"
                              andParams:params 
                          andHttpMethod:@"POST" 
                            andDelegate:self];
    }
}
/**
 * Called when the user has logged in successfully.
 */


- (void)fbDidLogin {
	
	[[NSUserDefaults standardUserDefaults] setObject:self._facebook.accessToken forKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:self._facebook.expirationDate forKey:@"ExpirationDate"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	if([_delegate respondsToSelector:@selector(fbDidLogin)])
		[_delegate fbDidLogin];
	
	self._delegate = nil;
	
}
/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	if([_delegate respondsToSelector:@selector(fbDidNotLogin:)])
		[_delegate fbDidNotLogin:cancelled];
	
	self._delegate = nil;
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ExpirationDate"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	if([_delegate respondsToSelector:@selector(fbDidLogout)])
		[_delegate fbDidLogout];
	
	self._delegate = nil;
}


- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
    
}

- (void)request:(FBRequest*)request didLoad:(id)result{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *message = @"";
    NSString *key = @"";
    if ([request.url hasPrefix:@"https://graph.facebook.com/me/feed"]) {
        key = @"me/feed";
        NSString *post_id = [result objectForKey:@"id"];
        if (post_id.length > 0) {
            message = @"Your message has been posted on your Facebook account.";
        } else {
            message = @"Your message could not been posted on your Facebook account.";
        }
    }
    else if ([request.url hasPrefix:@"https://graph.facebook.com/me/photos"]){
        key = @"me/photos";
        message = @"Photo has been posted on your Facebook account.";
    }
    else if ([request.url hasPrefix:@"https://graph.facebook.com/me"]){
        key = @"me";
        dict = result;
    }
    else if ([request.url hasPrefix:@"https://graph.facebook.com/me/videos"]){
        key = @"me/videos";
        message = @"Video has been posted on your Facebook account.";
    }
    else{}

    if ([_delegate respondsToSelector:@selector(fbPostSuccessfulWithKey:withMessage:andData:)])
        [_delegate fbPostSuccessfulWithKey:key withMessage:message andData:dict];
    
    self._delegate = nil;

}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
     NSString *key = @"";
    if ([request.url hasPrefix:@"https://graph.facebook.com/me/feed"])
        key = @"me/feed";
    else if ([request.url hasPrefix:@"https://graph.facebook.com/me/photos"])
        key = @"me/photos";
    else if ([request.url hasPrefix:@"https://graph.facebook.com/me"])
        key = @"me";
    else if ([request.url hasPrefix:@"https://graph.facebook.com/me/videos"])
        key = @"me/videos";
    else{}

    if ([_delegate respondsToSelector:@selector(fbPostFailWithKey:withError:)])
        [_delegate fbPostFailWithKey:key withError:error.localizedDescription];
        
        self._delegate = nil;
}


#pragma mark - Twitter -
-(void)tweetWithViewController:(UIViewController*)vc withStatus:(NSString *)status addImage:(UIImage*)img addURL:(NSString *)url{
    NSString *message = [NSString stringWithFormat:@"%@",status];
    if ([self isIOS6]) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            if (img)
                [tweetSheet addImage:img];
            if (url)
                [tweetSheet addURL:[NSURL URLWithString:url]];
            else
                url=@"";
            if (message.length > 104)
                message = [message substringWithRange:NSMakeRange(0, 105)];
            [tweetSheet setInitialText:message];
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result){
                switch (result) {
                    case SLComposeViewControllerResultCancelled:{
                        [tweetSheet dismissViewControllerAnimated:YES completion:nil];
                       if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)]) {
                           [_delegate twUserDetailWithData:nil withMessage:@"Tweet cancelled"];
                       }
                    }
                        break;
                    case SLComposeViewControllerResultDone:{
                        [tweetSheet dismissViewControllerAnimated:YES completion:nil];
                        if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)]) {
                            [_delegate twUserDetailWithData:nil withMessage:@"Tweet Sucessful"];
                        }

                    }
                        break;
                    default:
                        break;

                }
            }];
            [vc presentViewController:tweetSheet animated:YES completion:nil];
        }
    }
    else{
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        if (message.length > 104)
            message = [message substringWithRange:NSMakeRange(0, 105)];
        [twitter setInitialText:message];
        if (img)
            [twitter addImage:img];
        [twitter addURL:[NSURL URLWithString:url]];
        
        if([TWTweetComposeViewController canSendTweet]){
            [vc presentViewController:twitter animated:YES completion:nil];
        } else {
            if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)]) {
                [_delegate twUserDetailWithData:nil withMessage:@"You might be in Airplane Mode or not have service. Try again later."];
            }
            return;
        }
        twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
            if (TWTweetComposeViewControllerResultCancelled) {
                if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)]) {
                    [_delegate twUserDetailWithData:nil withMessage:@"Tweet cancelled"];
                }
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
            if (TWTweetComposeViewControllerResultDone) {
                if ([_delegate respondsToSelector:@selector(twUserDetailWithData:withMessage:)]) {
                    [_delegate twUserDetailWithData:nil withMessage:@"Tweet Sucessful"];
                }
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
    }
}





#pragma mark - Mail Composer -

-(void)mailWithViewController:(UIViewController*)vc To:(NSArray*)toArray cc:(NSArray*)ccArray bcc:(NSArray*)bccArray WithMessage:(NSString*)message andImage:(UIImage*)image andSubject:(NSString *)subject name:(NSString *)name
{
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
		if ([mailClass canSendMail]){
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
			if (!subject.length)
                [picker setSubject:@"EveryDay Video"];
			
			
			// Set up recipients
			NSArray *toRecipients = toArray; 	
			[picker setToRecipients:toRecipients];
			[picker setCcRecipients:ccArray];
			[picker setBccRecipients:bccArray];
			[picker setMessageBody:message isHTML:YES];
			// Attach an image to the email
			if(image){
				NSData *myData = UIImageJPEGRepresentation(image, 0.5);
				[picker addAttachmentData:myData mimeType:@"image/png" fileName:name];
			}
			
			// Fill out the email body text
			[vc presentViewController:picker animated:YES completion:nil];
			[picker release];
		}
		else {
			[UIAlertView infoAlertWithMessage:@"Device can not send email." andTitle:@"Alert"];
		}
	}
	else {
		[UIAlertView infoAlertWithMessage:@"Device can not send email." andTitle:@"Alert"];
	}
		
}


-(void)mailWithViewController:(UIViewController*)vc To:(NSArray*)toArray cc:(NSArray*)ccArray bcc:(NSArray*)bccArray WithMessage:(NSString*)message andVideo:(NSData *)VideoData
{
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
		if ([mailClass canSendMail]){
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;			
			[picker setSubject:@"EveryDay Video"];
			
			
			// Set up recipients
			NSArray *toRecipients = toArray;
			[picker setToRecipients:toRecipients];
			[picker setCcRecipients:ccArray];
			[picker setBccRecipients:bccArray];
			[picker setMessageBody:message isHTML:NO];
			// Attach an image to the email
		
            [picker addAttachmentData:VideoData mimeType:@"video/quicktime" fileName:@"EveryDay Video"];
			
			
			// Fill out the email body text
			[vc presentViewController:picker animated:YES completion:nil];
			[picker release];
		}
		else {
			[UIAlertView infoAlertWithMessage:@"Device can not send email." andTitle:@"Alert"];
		}
	}
	else {
		[UIAlertView infoAlertWithMessage:@"Device can not send email." andTitle:@"Alert"];
	}
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	if([_delegate respondsToSelector:@selector(mailComposeController:didFinishWithResult:error:)])
		[_delegate mailComposeController:controller didFinishWithResult:result error:error];
	
	self._delegate = nil;
}


-(void)messageTo:(NSArray*)toArray WithBody:(NSString*)body inViewController:(UIViewController*)vc{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil){
			if ([messageClass canSendText]){
				MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                picker.messageComposeDelegate=self;
				picker.recipients = toArray;
				picker.body = body;
				[vc presentViewController:picker animated:YES completion:nil];
			}
			else {
				[UIAlertView infoAlertWithMessage:@"Device can not send SMS." andTitle:@"SMS"];
			}
	}
	else{
		[UIAlertView infoAlertWithMessage:@"Device can not send SMS." andTitle:@"SMS"];
	}
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	if([_delegate respondsToSelector:@selector(messageComposeViewController:didFinishWithResult:)])
		[_delegate messageComposeViewController:controller didFinishWithResult:result];
	
	self._delegate = nil;
}




#pragma mark - INSTAGRAM LOGIN METHOD -

- (void)instagramLoginDetail{
    if (!self.instagram)
        self.instagram = [[Instagram alloc] initWithClientId:@"d0698316189c4d648ce6c518c248fcd9" delegate:self];
    
    self.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    self.instagram.sessionDelegate = self;
    if ([self.instagram isSessionValid]) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        NSArray *arr = [accessToken componentsSeparatedByString:@"."];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@",[arr objectAtIndex:0]], @"method", nil];
        [self.instagram requestWithParams:params delegate:self];
    } else {
        [self.instagram authorize:[NSArray arrayWithObjects:@"basic", nil]];
    }
}

#pragma mark  INSTRAGRAM SHARING
-(void)igShareImage:(UIImage*)image withCaption:(NSString*)caption withViewController:(UIViewController *)vc
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        CGRect rect = CGRectMake(0 ,0 , 0, 0);
        
        
        NSData *data = UIImagePNGRepresentation(image);
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Restaurant.igo"];
        [data writeToFile:jpgPath atomically:YES];
        
        NSURL *igImageHookFile = [NSURL fileURLWithPath:jpgPath];
        
        
        self.documentInterActionController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        self.documentInterActionController.UTI = @"com.instagram.photo";
        self.documentInterActionController.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
        [self.documentInterActionController presentOpenInMenuFromRect:rect inView:vc.view animated:YES ];
    }
    
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/in/app/instagram/id389801252?mt=8"]];
    }
}
//Used to share the snapshot of game in instagram.
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}


#pragma - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    [[NSUserDefaults standardUserDefaults] setObject:self.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    [self instagramLoginDetail];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    if ([_delegate respondsToSelector:@selector(instagramLoginFailWithMessage:)]) {
        [_delegate instagramLoginFailWithMessage:message];
    }
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

#pragma mark - IGRequestDelegate

- (void)IGrequest:(IGRequest *)request didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(instagramLoginFailWithMessage:)]) {
        [_delegate instagramLoginFailWithMessage:[error localizedDescription]];
    }
}

- (void)IGrequest:(IGRequest *)request didLoad:(id)result {
    if ([_delegate respondsToSelector:@selector(instagramLoginSuccessfulWithDict:)]) {
        [_delegate instagramLoginSuccessfulWithDict:result];
    }
}


@end
