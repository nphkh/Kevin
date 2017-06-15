
#import <UIKit/UIKit.h>

@interface UITableViewCell (NIB)

+ (NSString*)cellID;
+ (NSString*)nibName;

+ (id)dequeOrCreateInTable:(UITableView*)tableView;
+ (id)loadCell;
@end
