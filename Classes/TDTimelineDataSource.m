/**
 * @class TDTimelineDataSource
 * @author Nik S Dyonin <wolf.step@gmail.com>
 */

#import "TDTimelineDataSource.h"
#import "JSON.h"

@implementation TDTimelineDataSource

@synthesize tweets, target, selector;

- (void)loadTimelineSync {
	NSString *tweetsUrlString = [[NSString alloc] initWithFormat:@"http://twitter.com/statuses/user_timeline/%@.json", USERNAME];
	NSURL *url = [[NSURL alloc] initWithString:tweetsUrlString];
	[tweetsUrlString release];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[url release];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		TRACE(@"TDTimelineDataSource (-loadTimelineSync) error occured: %@", error);
	}
	else {
		NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSError *jsonError;
		tweets = [[parser objectWithString:responseString error:&jsonError] retain];
		[responseString release];

		TRACE(@"TDTimelineDataSource (-loadTimelineSync) loaded tweets: %@", tweets);
	}
	[request release];

	@try {
		[target performSelectorOnMainThread:selector withObject:self waitUntilDone:NO];
	}
	@catch (NSException *e) {
		TRACE(@"TDTimelineDataSource (-loadTimelineSync) exception: %@", e);
	}
}

- (void)loadTimelineAsync {
	NSString *tweetsUrlString = [[NSString alloc] initWithFormat:@"http://twitter.com/statuses/user_timeline/%@.json", USERNAME];
	NSURL *url = [[NSURL alloc] initWithString:tweetsUrlString];
	[tweetsUrlString release];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[url release];

	mConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	if (mConnection) {
		tweetsData = [[NSMutableData alloc] init];
	}
	else {
		@try {
			[target performSelectorOnMainThread:selector withObject:self waitUntilDone:NO];
		}
		@catch (NSException *e) {
			TRACE(@"TDTimelineDataSource (-loadTimelineAsync) exception: %@", e);
		}
	}

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	@try {
		[target performSelectorOnMainThread:selector withObject:self waitUntilDone:NO];
	}
	@catch (NSException *e) {
		TRACE(@"TDTimelineDataSource (-connection:didFailWithError:) exception: %@", e);
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[tweetsData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[NSString alloc] initWithData:tweetsData encoding:NSUTF8StringEncoding];
	[tweetsData release];
	tweetsData = nil;
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSError *jsonError;
	tweets = [[parser objectWithString:responseString error:&jsonError] retain];
	[responseString release];

	TRACE(@"TDTimelineDataSource (-connectionDidFinishLoading:) loaded tweets: %@", tweets);

	[mConnection release];
	mConnection = nil;

	@try {
		[target performSelectorOnMainThread:selector withObject:self waitUntilDone:NO];
	}
	@catch (NSException *e) {
		TRACE(@"TDTimelineDataSource (-connection:didFailWithError:) exception: %@", e);
	}
}

- (void)dealloc {
	target = nil;
	[tweets release];
	[super dealloc];
}

@end
