//
//  BIDAppDelegate.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDAppDelegate.h"
#import "BIDFirstViewController.h"
#import "BIDSecondViewController.h"
#import "BIDThirdViewController.h"
#import "BIDFourthViewController.h"
#import "BIDMapViewController.h"

@implementation BIDAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    // 어플리케이션 내의 모든 BarButtonItem의 틴트 색상이 검은색이 됨
    
    UIViewController *viewController1 = [[BIDFirstViewController alloc] initWithNibName:@"BIDFirstViewController" bundle:nil];
    UIViewController *viewController2 = [[BIDSecondViewController alloc] initWithNibName:@"BIDSecondViewController" bundle:nil];
    UIViewController *viewController3 = [[BIDThirdViewController alloc] initWithNibName:@"BIDThirdViewController" bundle:nil];
    UIViewController *viewController4 = [[BIDFourthViewController alloc] initWithNibName:@"BIDFourthViewController" bundle:nil];
    UINavigationController *myNaviViewController1 = [[UINavigationController alloc]initWithRootViewController:viewController2];
    myNaviViewController1.navigationBar.tintColor = [UIColor blackColor];
    UINavigationController *myNaviViewController2 = [[UINavigationController alloc]initWithRootViewController:viewController3];
    myNaviViewController2.navigationBar.tintColor = [UIColor blackColor];
    UINavigationController *myNaviViewController3 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    myNaviViewController3.navigationBar.tintColor = [UIColor blackColor];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:myNaviViewController3, myNaviViewController1, myNaviViewController2, viewController4, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"] != 1) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        [[NSUserDefaults standardUserDefaults] setValue:(__bridge NSString *)uuidStringRef forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"uuid : %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"]);
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
