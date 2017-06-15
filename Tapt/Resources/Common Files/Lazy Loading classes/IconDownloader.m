/*
     File: IconDownloader.m 
 Abstract: Helper object for managing the downloading of a particular app's icon.
 As a delegate "NSURLConnectionDelegate" is downloads the app icon in the background if it does not
 yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 
 A simple BOOL tracks whether or not a download is already in progress to avoid redundant requests.
  
  Version: 1.0 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2009 Apple Inc. All Rights Reserved. 
  
 */

#import "IconDownloader.h"
#import "NSString+Extensions.h"

#define kAppIconHeight 48


@implementation IconDownloader


@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize dataDict;
@synthesize strPhotoName;
@synthesize strDirectoryName;
@synthesize isGooglePlaceImage;

#pragma mark



- (void)startDownload:(NSString*)strURL
{
	self.strPhotoName = [strURL lastPathComponent];
	strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:strURL]] delegate:self];
    self.imageConnection = conn;

}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    if([delegate respondsToSelector:@selector(imageDonwloadFail:)]){
        [delegate imageDonwloadFail:self];
    }
	else if ([delegate respondsToSelector:@selector(failWithError:withIndexPath:)]) {
		[delegate failWithError:error withIndexPath:indexPathInTableView];
	}
     
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}
- (void)_stopReceiveWithStatus:(NSString *)statusString code:(int)statusCode {
    if (imageConnection != nil) {
        [imageConnection cancel];
    }
	if([delegate respondsToSelector:@selector(imageDonwloadFail:)]){
        [delegate imageDonwloadFail:self];
    }
	else if ([delegate respondsToSelector:@selector(failWithError:withIndexPath:)]) {
		[delegate failWithError:nil withIndexPath:indexPathInTableView];
	}
	 self.activeDownload = nil;
	self.imageConnection = nil;
}
- (void)connection:(NSURLConnection *)conection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse;
	NSString *contentTypeHeader;
	
	assert(conection == imageConnection);
	httpResponse = (NSHTTPURLResponse *)response;
	
	assert([httpResponse isKindOfClass:[NSHTTPURLResponse class]]);
	
	if ((httpResponse.statusCode / 100) != 2) {
		[self _stopReceiveWithStatus:@"HTTP error" code:httpResponse.statusCode];
	} 
	else {
		contentTypeHeader = [httpResponse.allHeaderFields objectForKey:@"Content-Type"];
		
		if (contentTypeHeader == nil)
			[self _stopReceiveWithStatus:@"No Content-Type!" code:-1];
		else
			[activeDownload setLength:0];
	}
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    NSString *imagePath;
    if (image) {
        if(strDirectoryName){
            NSString *pathInCache = [NSString stringWithFormat:@"/Images/%@/",strDirectoryName];
            imagePath  = [self.strPhotoName pathInDirectory:pathInCache cachedData:YES];
        }
        else if(isGooglePlaceImage){
            NSArray *array = [strPhotoName componentsSeparatedByString:@"&"];
            for(NSString *strKey in array){
                NSRange range = [strKey rangeOfString:@"photoreference="];
                if(range.location !=NSNotFound){
                    NSString *imageName = [strKey substringFromIndex:range.length];
                    
                    //Change
                    if([imageName length]>254)
                        imageName=[imageName substringToIndex:254];
                    //
                    
                    imagePath = [imageName pathInDirectory:@"/Images/" cachedData:YES];
                    break;
                }
            }
        }
        else{
             imagePath = [self.strPhotoName pathInDirectory:@"/Images/" cachedData:YES];
        }
       
        [self.activeDownload writeToFile:imagePath atomically:YES];                                   
    }

    
    self.activeDownload = nil;
    self.imageConnection = nil;
    
    if([delegate respondsToSelector:@selector(imageDonwloaded:withIconDownloader:)])
        [delegate imageDonwloaded:image withIconDownloader:self];
    else if([delegate respondsToSelector:@selector(appImageDidLoad:withImage:)])
        [delegate appImageDidLoad:self.indexPathInTableView withImage:image];
     

}

@end

