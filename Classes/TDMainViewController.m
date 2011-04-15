/**
 * @class TDMainViewController
 * @author Nik S Dyonin <wolf.step@gmail.com>
 */

#import "TDMainViewController.h"
#import "TDTimelineViewController.h"

@implementation TDMainViewController

- (void)loadView {
	[super loadView];
	
	UIButton *syncButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[syncButton setTitle:@"Синхронная загрузка" forState:UIControlStateNormal];
	[syncButton sizeToFit];
	[syncButton addTarget:self action:@selector(syncButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *asyncButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[asyncButton setTitle:@"Асинхронная загрузка" forState:UIControlStateNormal];
	[asyncButton sizeToFit];
	[asyncButton addTarget:self action:@selector(asyncButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	
	CGRect tmpRect = syncButton.frame;
	tmpRect.origin.x = floor((self.view.frame.size.width - tmpRect.size.width) / 2.0f);
	tmpRect.origin.y = 60.0f;
	syncButton.frame = tmpRect;
	[self.view addSubview:syncButton];
	
	tmpRect = asyncButton.frame;
	tmpRect.origin.x = floor((self.view.frame.size.width - tmpRect.size.width) / 2.0f);
	tmpRect.origin.y = syncButton.frame.origin.y + syncButton.frame.size.height + 30.0f;
	asyncButton.frame = tmpRect;
	[self.view addSubview:asyncButton];
	
	self.title = @"Твиты";
}

- (void)syncButtonAction:(UIButton *)sender {
	TDTimelineViewController *timelineViewController = [[TDTimelineViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:timelineViewController animated:YES];
	[timelineViewController release];
	[timelineViewController syncLoad];
}

- (void)asyncButtonAction:(UIButton *)sender {
	TDTimelineViewController *timelineViewController = [[TDTimelineViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:timelineViewController animated:YES];
	[timelineViewController release];
	[timelineViewController asyncLoad];
}

@end
