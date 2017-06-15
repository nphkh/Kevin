

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "BaseViewContoller.h"

@interface PullRefreshViewController : BaseViewContoller <EGORefreshTableHeaderDelegate,UIScrollViewDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) BOOL _loadMore;

-(void)refreshTableView;
- (void)doneLoadingTableViewData;
- (void)reloadTableViewDataSource;
-(void)forceForRefreshView;
- (void)removePullToRefresh;
@end
