/**
 * @class TDTimelineViewController
 */

@class TDTimelineDataSource;

@interface TDTimelineViewController : UITableViewController {
	TDTimelineDataSource *dataSource;
	UIActivityIndicatorView *indicator;
}

- (void)syncLoad;
- (void)asyncLoad;

@end
