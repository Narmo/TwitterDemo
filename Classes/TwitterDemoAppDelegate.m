/**
 * @class TwitterDemoAppDelegate
 * @author Nik S Dyonin <wolf.step@gmail.com>
 */

#import "TwitterDemoAppDelegate.h"
#import "TDMainViewController.h"

@implementation TwitterDemoAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	TDMainViewController *mainViewController = [[TDMainViewController alloc] init];
	mainNavController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	[mainViewController release];

	[self.window addSubview:mainNavController.view];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
	[mainNavController release];
	[window release];
	[super dealloc];
}

@end
