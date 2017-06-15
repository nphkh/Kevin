

#import "PullRefreshViewController.h"

@implementation PullRefreshViewController
@synthesize _refreshHeaderView;
@synthesize _loadMore;
@synthesize tableView;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		self._refreshHeaderView = view;
		//[view release];
	}
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)removePullToRefresh{
    [self._refreshHeaderView removeFromSuperview];
    self._refreshHeaderView = nil;
    self._refreshHeaderView.delegate = nil;
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
    
    if(!_reloading){
            [self refreshTableView];
        }
        _reloading = YES;

}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

-(void)forceForRefreshView{
    
    if([self isNetworkReachable])
    {
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    }
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	 
	[self reloadTableViewDataSource];
 	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
   	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self isNetworkReachable]) {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
    {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
    }
	
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // [super scrollViewDidEndDecelerating:scrollView];
}

/*
- (void)dealloc{
    [tableView release];
    self._refreshHeaderView = nil;
    [super dealloc];
}
 */
 
@end
