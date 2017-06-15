//
//  WebViewViewController.h
//  Tapt
//
//  Created by Parth on 22/05/15.
//  Copyright (c) 2015 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContoller.h"

@interface WebViewViewController : BaseViewContoller<UIWebViewDelegate>
{
    BOOL isFirst;
}
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strUrl;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

- (void)createRefreshButton;
- (void)createStopButton;

-(IBAction)btnGoBack:(id)sender;
-(IBAction)btnGoForward:(id)sender;


- (IBAction)btnBackAction:(id)sender;
@end
