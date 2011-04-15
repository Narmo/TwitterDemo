/**
 * @class TDTimelineDataSource
 */

@interface TDTimelineDataSource : NSObject {
	NSMutableArray *tweets;
	
	id target;
	SEL selector;
	
	NSURLConnection *mConnection;
	NSMutableData *tweetsData;
}

@property (nonatomic, readonly) NSMutableArray *tweets;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

- (void)loadTimelineSync;
- (void)loadTimelineAsync;

@end
