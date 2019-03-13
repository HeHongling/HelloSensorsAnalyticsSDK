//
//  AppDelegate.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 19/06/2018.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate.h"
#import <SensorsDebugger.h>
#import "MainViewController.h"
#import "PluginManager.h"

//#define SA_SERVER_URL @"<#CustomServerURL#>"
#ifndef SA_SERVER_URL
#define SA_SERVER_URL @"http://test-hechun.datasink.sensorsdata.cn/sa?project=hehongling&token=d28b875ed9ac268f"
#endif

#define SA_AUTOTRACK_APPSTART 0
#define SA_AUTOTRACK_APPEND 0
#define SA_AUTOTRACK_APPCLICK 0
#define SA_AUTOTRACK_VIEWSCREEN 1

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
                                    andLaunchOptions:launchOptions
                                        andDebugMode:SensorsAnalyticsDebugAndTrack];
    
    [[SensorsAnalyticsSDK sharedInstance] trackInstallation:@"AppInstall"];
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:(SA_AUTOTRACK_APPSTART& 1) << 0
                                                         |(SA_AUTOTRACK_APPEND& 1) << 1
                                                         |(SA_AUTOTRACK_APPCLICK& 1) << 2
                                                         |(SA_AUTOTRACK_VIEWSCREEN& 1) << 3];
    
    MainViewController *mainVc =  [[MainViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVc];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
