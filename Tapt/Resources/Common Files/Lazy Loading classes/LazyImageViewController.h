

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "BaseViewContoller.h"
#import "LazyImageViewController.h"
#import "PullRefreshViewController.h"

@interface LazyImageViewController : PullRefreshViewController <UIScrollViewDelegate,IconDownloaderDelegate>

//@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong)  NSMutableDictionary *photoDict;
@property (nonatomic) NSInteger isCommonLastName;
@property (nonatomic) NSInteger isGooglePlaceImg;
- (void)loadImagesForOnscreenRows;
- (void)refreshImages;
- (void)startDownloadingImage:(NSString*)strURL withIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)imageIfExist:(NSString*)strURL;
- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath WithURL:(NSString*)strURL;
- (void)setImageURL:(NSString*)strURL forIndexPath:(NSIndexPath*)indexPath;
- (BOOL)isDownloading:(NSString*)strURL;
@end
