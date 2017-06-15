//http://192.168.1.26:8081/sharing/uploads/TechnicalDesignArchitecture_V3.pdf
//http://tapt.ospdigital.tv/test-harness/
//com.tristate.Tapt
//com.tristate.$(PRODUCT_NAME:rfc1034identifier)

//----------------------- Application Name -------------------------//

#define APP_NAME @"Tapt"
#define IS_IOS_8 [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0

//----------------------- Application alert message -------------------------//
#define ALERT_NO_INTERNET @"Please check your internet connection."

//----------------------- Google sign in Client Id -------------------------//

//#define GOOGLE_CLIENT_ID @"250574121036-tu98sbicuhgendt28mb8dnsdg81s5bfm.apps.googleusercontent.com"
//#define GOOGLE_CLIENT_ID @"250574121036.apps.googleusercontent.com"
#define GOOGLE_CLIENT_ID @"340549547595-clmfq4v1qdqdp0k7ahac6rr1qd066dkn.apps.googleusercontent.com"
//----------------------- Facebook App Id -------------------------//
#define FACEBOOK_APP_ID @"fb830085773706512"

//----------------------- Webdservice url-------------------------//
#define WEBSERVICE_HOST @""
#define WEBSERVICE_URL_ENCRYPTED @""
#define WEBSERVICE_URL @"http://tapt.ospdigital.tv/process.php"
#define WEBSERVICE_IMG_LOGO_URL @"http://tapt.ospdigital.tv/logo/"
#define WEBSERVICE_IMG_BASE_URL @"http://tapt.ospdigital.tv/images/"


//----------------------- Colors used in application -------------------------//
#define BORDER_COLOR [UIColor colorWithRed:184.0f/255.0 green:86.0f/255.0 blue:234.0f/255.0 alpha:1.0f]

#define IMAGE_PLACEHOLDER @"profile-circle-contact.png"
//----------------------- Private - Please don't change -------------------------//
//#define DATABASE_NAME @"CustomDiet.sqlite"


#define SAFESTRING(str) ISVALIDSTRING(str) ? str : @""
#define ISVALIDSTRING(str) (str != nil && [str isKindOfClass:[NSNull class]] == NO)
#define VALIDSTRING_PREDICATE [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {return (BOOL)ISVALIDSTRING(evaluatedObject);}]

//LinkedIN
#define LINKED_IN_API @"75o015hwt629gg";
#define LINKED_IN_SECRETE_KEY @"fGnWkIMpbccEp5pL";

#define TWITTER_BASE_URL @"https://twitter.com/";
#define FACEBOOK_BASE_URL @"https://www.facebook.com/";
#define LINKEDIN_BASE_URL @"https://www.linkedin.com/";
#define SKYPE_BASE_URL @"http://www.skype.com/en/";


//Phone Number Format
#define PHONE_FILTER @"### ### ####";

//In App Purchase - settings. - ProductID
#define BUYALL_PRODUCT_ID           @"com.llama.wealthywalrus.all"
#define FUNNY_PRODUCT_ID            @"com.llama.wealthywalrus.funny"
#define GROSS_PRODUCT_ID            @"com.llama.wealthywalrus.gross"
#define POPCULTURE_PRODUCT_ID       @"com.llama.wealthywalrus.popculture"
#define RANDOM1_PRODUCT_ID          @"com.llama.wealthywalrus.random1"
#define RANDOM2_PRODUCT_ID          @"com.llama.wealthywalrus.random2"
#define TEEN_PRODUCT_ID             @"com.llama.wealthywalrus.teen"
