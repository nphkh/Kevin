
#import "LazyImageViewController.h"
#import "IconDownloader.h"
#import "NSString+Extensions.h"
//#import "ColleguesCell.h"

@implementation LazyImageViewController
@synthesize imageDownloadsInProgress;
@synthesize photoDict;
@synthesize isCommonLastName;
@synthesize isGooglePlaceImg;
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
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
            id cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell respondsToSelector:@selector(loadImage:)])
                [cell performSelector:@selector(loadImage:) withObject:[UIImage imageNamed:@"photoDefault.png"]];
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
        return [UIImage imageNamed:@"photoDefault.png"];
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
        iconDownloader.isGooglePlaceImage = isGooglePlaceImg;
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
	if ([self.photoDict count] > 0)
    {
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths){
            NSString *strPhotoURL = [self.photoDict objectForKey:indexPath];
            UIImage *image = [self imageIfExist:strPhotoURL];
            if(image){
                id cell = [tableView cellForRowAtIndexPath:indexPath];
                if([cell respondsToSelector:@selector(loadImage:)])
                    [cell performSelector:@selector(loadImage:) withObject:image];
            }
            else{
                [self startDownloadingImage:strPhotoURL withIndexPath:indexPath];
            }
        }
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath withImage:(UIImage*)image{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader != nil){
		id cell = [tableView cellForRowAtIndexPath:indexPath];
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
		id cell = [tableView cellForRowAtIndexPath:indexPath];
       

         if([cell respondsToSelector:@selector(loadImage:)])
            [cell performSelector:@selector(loadImage:) withObject:nil];
	}	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
    
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
    
    if([self respondsToSelector:@selector(tableViewScrollDelelarateEnd)])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tablescroll" object:nil];
    }
    [super scrollViewDidEndDecelerating:scrollView];

}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath;
}

-(void)dealloc{
    if (imageDownloadsInProgress) {
		NSArray *arry = [imageDownloadsInProgress allValues];
		for (IconDownloader *icon in arry) {
			[icon cancelDownload];
		}
		self.imageDownloadsInProgress = nil;
	}
    self.photoDict = nil;
  // self.tableView=nil;
    
}
@end
