//
//  AppDelegate.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 19/06/2018.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate.h"

//#define SA_SERVER_URL @"<#CustomServerURL#>"
#ifndef SA_SERVER_URL
#define SA_SERVER_URL @"http://test-hechun.datasink.sensorsdata.cn/sa?project=hehongling&token=d28b875ed9ac268f"
#endif

#define SA_AUTOTRACK_APPSTART 1
#define SA_AUTOTRACK_APPEND 1
#define SA_AUTOTRACK_APPCLICK 0
#define SA_AUTOTRACK_VIEWSCREEN 0

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *localServerURL = [[NSUserDefaults standardUserDefaults] valueForKey:SAUserDefaultsServerURL];
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:localServerURL.length? localServerURL : SA_SERVER_URL
                                    andLaunchOptions:launchOptions
                                        andDebugMode:SensorsAnalyticsDebugAndTrack];
    
    [[SensorsAnalyticsSDK sharedInstance] trackInstallation:@"AppInstall"];
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:(SA_AUTOTRACK_APPSTART& 1) << 0
                                                         |(SA_AUTOTRACK_APPEND& 1) << 1
                                                         |(SA_AUTOTRACK_APPCLICK& 1) << 2
                                                         |(SA_AUTOTRACK_VIEWSCREEN& 1) << 3];
    return YES;
}

@end
