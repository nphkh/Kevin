

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Constants.h"
#import "UIAlertView+utils.h"
#import "IGConnect.h"

@protocol SharkitDelegate <NSObject>
@optional
- (void)fbDidLogin;
- (void)fbDidNotLogin:(BOOL)cancelled;
- (void)fbDidLogout;
//- (void)request:(FBRequest *)request didFailWithError:(NSError *)error;
//- (void)request:(FBRequest *)request didLoad:(id)result;
- (void)fbDialogLogin:(NSString*)token expirationDate:(NSDate*)expirationDate;
- (void)fbDialogNotLogin:(BOOL)cancelled;
- (void)fbPostSuccessfulWithKey:(NSString *)key withMessage:(NSString *)message andData:(id)result;
- (void)fbPostFailWithKey:(NSString *)key withError:(NSString *)error;

//mail
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;

//tweeter
- (void)twUserDetailWithData:(NSMutableDictionary *)dictInfo withMessage:(NSString *)message;

//instagram
-(void)instagramLoginSuccessfulWithDict:(NSMutableDictionary *)dict;
-(void)instagramLoginFailWithMessage:(NSString *)message;


@end


@interface Sharekit : NSObject <IGSessionDelegate,IGRequestDelegate,FBSessionDelegate,FBRequestDelegate,
FBLoginDialogDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate > {
    ACAccountStore *accountStore;
    ACAccount *facebookAccount;
    ACAccountType *accountType;
    Instagram *instagram;
	Facebook* _facebook;
	NSArray* _permissions;
	id <SharkitDelegate> _delegate;
    UIDocumentInteractionController *documentInterActionController;
}
@property (nonatomic, retain) Facebook* _facebook;
@property (nonatomic, retain) NSArray *_permissions;
@property (nonatomic, retain) id <SharkitDelegate> _delegate;
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (retain, nonatomic) ACAccountType *accountType;
@property (retain, nonatomic) Instagram *instagram;
@property (nonatomic, retain) UIDocumentInteractionController *documentInterActionController;

+ (id)shareObject;
//facebook
-(void)loginFacebook;
-(void)logoutFacebook;

- (void)fbuploadPhoto:(UIImage*)image withMessage:(NSString*)msg withViewController:(UIViewController *)viewController;
- (void)fbuploadVideo:(NSData*)videoData withTitle:(NSString*)title withDescription:(NSString *)description;
- (void)fbPublishMessage:(NSString*)message withViewController:(UIViewController *)viewController;
- (void)fbUserProfile;
- (BOOL)isFBlogin;
//twitter

- (void)twitterLoginDetail;
-(void)followOnTwitter:(NSString *)user isID:(BOOL)isID;
-(void)tweetWithViewController:(UIViewController*)vc withStatus:(NSString *)status addImage:(UIImage*)img addURL:(NSString *)url;
//Email
-(void)mailWithViewController:(UIViewController*)vc To:(NSArray*)toArray cc:(NSArray*)ccArray bcc:(NSArray*)bccArray WithMessage:(NSString*)message andImage:(UIImage*)image andSubject:(NSString *)subject name:(NSString *)name;
-(void)mailWithViewController:(UIViewController*)vc To:(NSArray*)toArray cc:(NSArray*)ccArray bcc:(NSArray*)bccArray WithMessage:(NSString*)message andVideo:(NSData *)VideoData;
//sms
-(void)messageTo:(NSArray*)toArray WithBody:(NSString*)body inViewController:(UIViewController*)vc;

//Instagram
- (void)instagramLoginDetail;
-(void)igShareImage:(UIImage*)image withCaption:(NSString*)caption withViewController:(UIViewController *)vc;

@end
