//
//  AppDelegate.m
//  Budget
//
//  Created by Christopher Constable on 3/11/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ExpenseManager.h"

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.rootViewController = [[RootViewController alloc] init];
    self.window.rootViewController = self.rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Save every time the user presses the home button
    [[ExpenseManager sharedManager] saveExpenses];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Save if the user force-closes the app
    [[ExpenseManager sharedManager] saveExpenses];
}

@end
