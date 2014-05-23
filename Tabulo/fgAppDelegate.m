//
//  AppDelegate.m
//  Prototype
//
//  Created by Serge Menard on 13-10-24.
//  Copyright (c) 2013 Frozenfrog Games. All rights reserved.
//

#import "fgAppDelegate.h"
#import "fgGameAdapter.h"

@implementation fgAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[fgGameAdapter alloc] initWithNibName:@"GameAdapter" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification object:application];
    
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.viewController viewWillDisappear:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.viewController viewWillAppear:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.viewController = nil;
    self.window = nil;
}

@end
