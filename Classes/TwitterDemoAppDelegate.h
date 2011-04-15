/**
 * @class TwitterDemoAppDelegate
 */

@interface TwitterDemoAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UINavigationController *mainNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
