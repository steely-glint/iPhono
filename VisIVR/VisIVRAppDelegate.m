//
//  VisIVRAppDelegate.m
//  VisIVR
//
//  Created by Tim Panton on 15/12/2011.
//  Copyright (c) 2011 Westhhawk Ltd. All rights reserved.
//

#import "VisIVRAppDelegate.h"

#import "VisIVRViewController.h"


@implementation VisIVRAppDelegate
@synthesize appInBackground;
@synthesize window = _window;
@synthesize viewController = _viewController;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[VisIVRViewController alloc] initWithNibName:@"VisIVRViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[VisIVRViewController alloc] initWithNibName:@"VisIVRViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    self.viewController.backgroundNotifier = ^{
        [self backgroundCallNotification];
    };
    appInBackground = NO;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    // ideally we'd put any live call on hold.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    appInBackground = YES;
    NSLog(@" appInBackground == YES");

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    appInBackground = NO;
    NSLog(@" appInBackground == NO");

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(NSDictionary *)userInfo
{
    // zapp the badge
    application.applicationIconBadgeNumber= 0;
}


- (void)backgroundCallNotification{
    NSLog(@" in backgroundCallNotification ");

    if (appInBackground){
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = [NSDate date];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotif.alertBody = [NSString stringWithFormat:@"incomming call"]; // put call details here....
        localNotif.alertAction = NSLocalizedString(@"GoTo app", nil);
        
        localNotif.soundName = @"Diggztone_Marimba";
        localNotif.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        [localNotif release];
    }
}
@end
