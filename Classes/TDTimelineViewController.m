/**
 * @class TDTimelineViewController
 * @author Nik S Dyonin <wolf.step@gmail.com>
 */

#import "TDTimelineViewController.h"
#import "TDTimelineDataSource.h"

@implementation TDTimelineViewController

- (void)syncLoad {
	[dataSource loadTimelineSync];
}

- (void)asyncLoad {
	[dataSource loadTimelineAsync];
}

- (void)reloadData:(TDTimelineDataSource *)sender {
	[indicator stopAnimating];
	
	[self.tableView reloadData];
}

- (void)loadView {
	[super loadView];
	
	NSString *titleString = [[NSString alloc] initWithFormat:@"Твиты от %@", USERNAME];
	self.title = titleString;
	[titleString release];

	dataSource = [[TDTimelineDataSource alloc] init];
	dataSource.target = self;
	dataSource.selector = @selector(reloadData:);

	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGRect tmpRect = indicator.frame;
	tmpRect.origin.x = floor((self.view.frame.size.width - tmpRect.size.width) / 2.0f);
	tmpRect.origin.y = floor((self.view.frame.size.height - tmpRect.size.height) / 2.0f) - 40.0f;
	indicator.frame = tmpRect;
	indicator.hidesWhenStopped = YES;
	[self.view addSubview:indicator];
	[indicator release];
	
	[indicator startAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource.tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *text = [[dataSource.tweets objectAtIndex:indexPath.row] valueForKey:@"text"];
	CGSize sz = [text sizeWithFont:[UIFont boldSystemFontOfSize:14]
				 constrainedToSize:CGSizeMake(290.0f, FLT_MAX)
					 lineBreakMode:UILineBreakModeWordWrap];
	
	return sz.height + 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TweetCell";

	
	UITextView *textView = nil;
	UILabel *dateLabel = nil;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)  {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];		
		
		textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 290.0f, 30.0f)];
		textView.backgroundColor = [UIColor clearColor];
		textView.font = [UIFont boldSystemFontOfSize:14];
		textView.textColor = RGB(0, 0, 0);
		textView.editable = NO;
		textView.dataDetectorTypes = UIDataDetectorTypeLink;
		textView.tag = 1;
		textView.scrollEnabled = NO;
		[cell.contentView addSubview:textView];
		[textView release];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 20.0f, 300.0f, 20.0f)];
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.font = [UIFont boldSystemFontOfSize:12];
		dateLabel.textColor = RGB(127, 128, 129);
		dateLabel.tag = 2;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
    }
	else  {
		textView = (UITextView *)[cell.contentView viewWithTag:1];
		dateLabel = (UILabel *)[cell.contentView viewWithTag:2];
	}
	
	NSString *text = [[dataSource.tweets objectAtIndex:indexPath.row] valueForKey:@"text"];
	CGSize size = [text sizeWithFont:textView.font
				   constrainedToSize:CGSizeMake(290.0f, FLT_MAX)
					   lineBreakMode:UILineBreakModeWordWrap];
	textView.text = text;
	textView.frame = CGRectMake(5.0f, 0.0f, 290.0f, size.height + 25.0f);


	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
	NSDate *date = [formatter dateFromString:[[dataSource.tweets objectAtIndex:indexPath.row] objectForKey: @"created_at"]];
	[formatter setDateFormat:@"HH:mm dd.MM.yyyy"];
	NSString *dateStr = [formatter stringFromDate:date];

	dateLabel.text = dateStr;
	[dateLabel sizeToFit];
	CGRect tmpRect = dateLabel.frame;
	tmpRect.origin.x = 14.0f;
	tmpRect.origin.y = textView.frame.origin.y + textView.frame.size.height + 5.0f;
	dateLabel.frame = tmpRect;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)dealloc {
	[dataSource release];
	[super dealloc];
}

@end
