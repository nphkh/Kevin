

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "BaseViewContoller.h"
//#import "PullRefreshViewController.h"

@interface LazyImageViewControllerCollectionView : BaseViewContoller <UIScrollViewDelegate,IconDownloaderDelegate>
  
   

@property (nonatomic, weak) IBOutlet UICollectionView *collectionV;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong)  NSMutableDictionary *photoDict;
@property (nonatomic) NSInteger isCommonLastName;
@property (nonatomic) NSInteger isGooglePlaceImg;

@property (nonatomic) BOOL isS3CloudStorage;
@property (nonatomic) BOOL isFooterLoaderEnable;
@property (nonatomic,strong) NSString  *strNibFooter;


- (void)loadImagesForOnscreenRows;
- (void)refreshImages;
- (void)startDownloadingImage:(NSString*)strURL withIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)imageIfExist:(NSString*)strURL;
- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath WithURL:(NSString*)strURL;
- (void)setImageURL:(NSString*)strURL forIndexPath:(NSIndexPath*)indexPath;
- (BOOL)isDownloading:(NSString*)strURL;



// s3 Cloud lazy loading.

//-(void) setImageWithKey:(NSString *) strKey WithBucket:(NSString *) strBucket forIndexPath:(NSIndexPath*)indexPath;
//-(UIImage *) fileExistsWithName:(NSString *)fileName withBucket:(NSString *)strBucket;
-(void) hideLoadMore;

-(void) clearAllOperations;
@end
