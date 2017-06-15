//
//  WebViewViewController.m
//  Tapt
//
//  Created by Parth on 22/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController

@synthesize strUrl;
@synthesize strTitle;
@synthesize webView;
@synthesize lblTitle;
@synthesize indicator;

@synthesize prevButton,nextButton,toolbar;
- (void)viewDidLoad {
    [super viewDidLoad];
      [appDelegate setShouldRotate:NO];
    lblTitle.text=strTitle;
//    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@",                                       userLoginURLString, self.requestToken.key];
    
//    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    

    NSURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:strUrl]];
    [webView loadRequest:request];
   [indicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webview {
    
//    [self showHud];
    [indicator startAnimating];
    prevButton.enabled = YES;
    nextButton.enabled = YES;
    if (![webview canGoBack])
        prevButton.enabled = NO;
    if (![webview canGoForward])
        nextButton.enabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self createStopButton];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self hidHud];
    [indicator stopAnimating];
    prevButton.enabled = YES;
    nextButton.enabled = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self createRefreshButton];
    
//    [indicator stopAnimating];
}



-(IBAction)btnGoBack:(id)sender
{
    isFirst=YES;
    
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        
    }
}

-(IBAction)btnGoForward:(id)sender
{
    isFirst=YES;
    
    if ([self.webView canGoForward])
    {
        [self.webView goForward];
    }
}


- (void)createRefreshButton {
    NSMutableArray *newToolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:webView action:@selector(reload)];
    refreshButton.tintColor=[UIColor blackColor];
    
    [newToolbarItems addObject:prevButton];
    [newToolbarItems addObject:nextButton];
    [newToolbarItems addObject:space];
    [newToolbarItems addObject:refreshButton];
    
    toolbar.items = newToolbarItems;
}


- (void)createStopButton {
    NSMutableArray *newToolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self.webView action:@selector(stopLoading)];
    
    stopButton.tintColor=[UIColor blackColor];
    [newToolbarItems addObject:prevButton];
    [newToolbarItems addObject:nextButton];
    [newToolbarItems addObject:space];
    [newToolbarItems addObject:stopButton];
    
    toolbar.items = newToolbarItems;
}
#pragma mark -set orientation
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
