
#import "LazyImageViewControllerCollectionView.h"
#import "IconDownloader.h"
#import "NSString+Extensions.h"
//#import "CHTCollectionViewWaterfallLayout.h"


@implementation LazyImageViewControllerCollectionView
@synthesize imageDownloadsInProgress;
@synthesize photoDict;
@synthesize isCommonLastName;
@synthesize isGooglePlaceImg;
@synthesize isS3CloudStorage;
@synthesize collectionV;
@synthesize isFooterLoaderEnable;
@synthesize strNibFooter;
//@synthesize tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoDict = [NSMutableDictionary dictionary];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    UICollectionViewFlowLayout *layoutFlow=self.collectionV.collectionViewLayout;
    layoutFlow.footerReferenceSize=CGSizeMake(0, 0);
    [self.collectionV registerNib:[UINib nibWithNibName:@"LoadMoreTblBottomViewGallery" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerview"];
   
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) setImageWithKey:(NSString *) strKey WithBucket:(NSString *) strBucket forIndexPath:(NSIndexPath*)indexPath
{

    
    NSString *strPath=[[NSString stringWithFormat:@"%@/%@",strBucket,strKey] pathInCacheDirectory];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:strPath])
    {
        UIImage *image=[UIImage imageWithContentsOfFile:strPath];
        id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
        if([cell respondsToSelector:@selector(loadImage:)])
            [cell performSelector:@selector(loadImage:) withObject:image];

    }
    else
    {
//        if([photoDict objectForKey:indexPath]==nil)
//        {
//        S3FileDownloader *fileDownLoader=[[S3FileDownloader alloc] init];
//        fileDownLoader.delegate=self;
//        [fileDownLoader downloadFile:strKey withBucketName:strBucket onIndexPath:indexPath];
//        [photoDict setObject:fileDownLoader forKey:indexPath];
//        }
    }
    
}

-(void) setImageWithKey:(NSString *) strKey WithBucket:(NSString *) strBucket forIndexPath:(NSIndexPath*)indexPath withTag:(int) tag
{
    NSString *strPath=[[NSString stringWithFormat:@"%@/%@",strBucket,strKey] pathInCacheDirectory];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:strPath])
    {
        UIImage *image=[UIImage imageWithContentsOfFile:strPath];
        id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
        if([cell respondsToSelector:@selector(loadImage:)])
            [cell performSelector:@selector(loadImage:) withObject:image];
        
    }
    else
    {
        if([photoDict objectForKey:indexPath]==nil)
        {
//            S3FileDownloader *fileDownLoader=[[S3FileDownloader alloc] init];
//            fileDownLoader.delegate=self;
//            [fileDownLoader downloadFile:strKey withBucketName:strBucket onIndexPath:indexPath];
//            [photoDict setObject:fileDownLoader forKey:indexPath];
        }
    }
}




-(UIImage *) fileExistsWithName:(NSString *)fileName withBucket:(NSString *)strBucket
{
  NSString *strPath=[[NSString stringWithFormat:@"%@/%@",strBucket,fileName] pathInCacheDirectory];
    if([[NSFileManager defaultManager] fileExistsAtPath:strPath])
    {
        UIImage *image=[UIImage imageWithContentsOfFile:strPath];
        return image;
        
    }
    return nil;
}

// S3FileDownloaderDelegate


-(void) fileDownloadSuccessfullyDoneWithKey:(NSString *)key fromPath:(NSString *)strPath onIndexPath:(NSIndexPath *)indexPath
{
    [photoDict removeObjectForKey:indexPath];
    UIImage *image=[UIImage imageWithContentsOfFile:strPath];
    
//    if([[NSFileManager defaultManager] fileExistsAtPath:strPath])
//    {
//        NSError *error=nil;
//        [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
//        NSData *data=UIImageJPEGRepresentation(image, 0.4f);
//        //[[NSFileManager defaultManager] createFileAtPath:strPath contents:UIImageJPEGRepresentation(image, 0.4f) attributes:nil];
//        [data writeToFile:strPath options:NSDataWritingAtomic error:&error];
//    }
    
    
    id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(loadImage:)])
        [cell performSelector:@selector(loadImage:) withObject:image];
}

-(void) fileDownloadFailedWithError:(NSError *) error withIndexPath:(NSIndexPath *)indexPath
{
    
     [photoDict removeObjectForKey:indexPath];
    
    id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(loadImage:)])
        [cell performSelector:@selector(loadImage:) withObject:[UIImage imageNamed:@"noimage.png"]];
}


- (void)setImageURL:(NSString*)strURL forIndexPath:(NSIndexPath*)indexPath{
   
    [photoDict setObject:strURL forKey:indexPath];
}



- (void)startDownloadingImage:(NSString*)strURL withIndexPath:(NSIndexPath*)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) {
        if(strURL){
            [self startIconDownload:nil forIndexPath:indexPath WithURL:strURL];
        }
        else{
            id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
            if([cell respondsToSelector:@selector(loadImage:)])
                [cell performSelector:@selector(loadImage:) withObject:[UIImage imageNamed:@"noimage.png"]];
        }
    }
}


- (UIImage*)imageIfExist:(NSString*)strPhotoURL{
    
    
    if((NSNull*)strPhotoURL != [NSNull null]){
        
        NSString *strPhotoName = [strPhotoURL lastPathComponent];
        NSString *strThumbnailIcon = nil;
        if(isCommonLastName){
            NSArray *array = [strPhotoURL pathComponents];
            NSString *secondLastComponent = [array objectAtIndex:[array count]-2];
            strThumbnailIcon = [strPhotoName pathInDirectory:[NSString stringWithFormat:@"/Images/%@/",secondLastComponent] cachedData:YES];
        }
        else if(isGooglePlaceImg){
            NSString *strLastPath = [strPhotoURL lastPathComponent];
            NSArray *array = [strLastPath componentsSeparatedByString:@"&"];
            for(NSString *strKey in array){
                NSRange range = [strKey rangeOfString:@"photoreference="];

                if(range.location !=NSNotFound){
                    NSString *imageName = [strKey substringFromIndex:range.length];
                    if([imageName length]>254)
                        imageName=[imageName substringToIndex:254];
                    strThumbnailIcon = [imageName pathInDirectory:@"/Images/" cachedData:YES];
                    break;
                }

            }
        }
        else{
            strThumbnailIcon = [strPhotoName pathInDirectory:@"/Images/" cachedData:YES];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:strThumbnailIcon]){
            return nil;
        }
        else{
            return [UIImage imageWithContentsOfFile:strThumbnailIcon];
        }
        
    }
    else{
        return [UIImage imageNamed:@"noimage.png"];
    }
}

//Optional Method For special Case
- (BOOL)isDownloading:(NSString*)strURL{
    if (imageDownloadsInProgress) {
		NSArray *arry = [imageDownloadsInProgress allValues];
		for (IconDownloader *icon in arry) {
            NSString *strPhotoName = [strURL lastPathComponent];
			if([strPhotoName isEqualToString:strURL]){
                return YES;
            }
		}
	}
    return NO;
}
#pragma mark -
#pragma mark ImageDownload
#pragma mark -



- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath WithURL:(NSString*)strURL
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
//        iconDownloader.isGooglePlaceImage = isGooglePlaceImg;
        iconDownloader.dataDict = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        if(isCommonLastName){
            NSArray *array = [strURL pathComponents];
            NSString *secondLastComponent = [array objectAtIndex:[array count]-2];
            iconDownloader.strDirectoryName = secondLastComponent;
        }
        [iconDownloader startDownload:strURL];
 
    }
}

- (void)refreshImages{
    if(self.imageDownloadsInProgress){
        NSArray *arry = [imageDownloadsInProgress allValues];
        for (IconDownloader *icon in arry) {
            [icon cancelDownload];
        }
        [self.imageDownloadsInProgress removeAllObjects];
    } 
    [photoDict removeAllObjects];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if(self.isS3CloudStorage)
    {
    
    }
    else
    {
	if ([self.photoDict count] > 0)
    {
        NSArray *visiblePaths = [self.collectionV indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths){
            NSString *strPhotoURL = [self.photoDict objectForKey:indexPath];
            UIImage *image = [self imageIfExist:strPhotoURL];
            if(image){
                id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
                if([cell respondsToSelector:@selector(loadImage:)])
                    [cell performSelector:@selector(loadImage:) withObject:image];
            }
            else{
                [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
            }
        }
    }
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath withImage:(UIImage*)image{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader != nil){
		id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
        if([cell respondsToSelector:@selector(loadImage:)])
            [cell performSelector:@selector(loadImage:) withObject:image];
	}	
    if([self respondsToSelector:@selector(reloadTableForImage)]){
        [self performSelector:@selector(reloadTableForImage)];
    }
}
-(void)failWithError:(NSError*)error withIndexPath:(NSIndexPath*)indexPath{
    
    
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader != nil){
		id cell = [self.collectionV cellForItemAtIndexPath:indexPath];
       

         if([cell respondsToSelector:@selector(loadImage:)])
            [cell performSelector:@selector(loadImage:) withObject:nil];
	}	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
    
    if([self respondsToSelector:@selector(tableViewScrollDelelarateEnd)])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tablescroll" object:nil];
    }
    
    if(self.isFooterLoaderEnable && (scrollView.contentSize.height-(scrollView.contentOffset.y+scrollView.bounds.size.height))<=0)
    {
//        NSArray *visibleRows = [self.collectionV visibleCells];
//        UITableViewCell *lastVisibleCell = [visibleRows lastObject];
        int row = [self.collectionV numberOfItemsInSection:0];
        NSIndexPath *indexPPAth = [NSIndexPath indexPathForRow:row-1 inSection:0];
       // NSIndexPath *indexPPAth = [self.collectionV indexPathForCell:lastVisibleCell];
       
//        CHTCollectionViewWaterfallLayout *layoutFlow=(CHTCollectionViewWaterfallLayout *)self.collectionV.collectionViewLayout;
//        layoutFlow.footerHeight=98.0;
//
//        layoutFlow.footerReferenceSize=CGSizeMake(320, 98);
        [self.collectionV scrollToItemAtIndexPath:indexPPAth atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
     
        [self performSelector:@selector(addLoadMoreData) withObject:nil afterDelay:0.5f];
        
    }
 
    
   // [super scrollViewDidEndDecelerating:scrollView];
}

-(void) hideLoadMore
{
   
    NSArray *visibleRows = [self.collectionV visibleCells];
    UICollectionViewCell *lastVisibleCell = [visibleRows firstObject];
    NSIndexPath *indexPPAth1 = [self.collectionV indexPathForCell:lastVisibleCell];
    int row = [self.collectionV numberOfItemsInSection:0];
    NSIndexPath *indexPPAth = [NSIndexPath indexPathForRow:row-1 inSection:0];
   
    if(row==indexPPAth1.row+1)
    [self.collectionV scrollToItemAtIndexPath:indexPPAth atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
   
    [self performSelector:@selector(hideFooter) withObject:nil afterDelay:0.5f];

    
}

-(void)hideFooter
{
    UICollectionViewFlowLayout *layoutFlow=self.collectionV.collectionViewLayout;
    layoutFlow.footerReferenceSize=CGSizeMake(0, 0);
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath;
}

-(void) clearAllOperations
{
   
//    NSArray *arry = [photoDict allValues];
//    for (int i=0;i<arry.count;i++)
//    {
//        S3FileDownloader *fileDownLoader1 = [arry objectAtIndex:i];
//        if (![fileDownLoader1 isKindOfClass:[NSString class]]) {
//            [fileDownLoader1 clearAll];
//        }
//        
//    }
//    [S3TransferManager destroy];
    self.imageDownloadsInProgress = nil;
    self.photoDict = nil;
}


-(void)dealloc{
    
    [self clearAllOperations];
  // self.tableView=nil;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView=nil;
    if(kind == UICollectionElementKindSectionFooter)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerview" forIndexPath:theIndexPath];
    }
    
    return theView;
}
@end
