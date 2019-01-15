//
//  AppDelegate.m
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/20.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate.h"
#if __has_include(<SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

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

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
                                    andLaunchOptions:launchOptions
                                        andDebugMode:SensorsAnalyticsDebugAndTrack];
    
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:(SA_AUTOTRACK_APPSTART& 1) << 0
     |(SA_AUTOTRACK_APPEND& 1) << 1
     |(SA_AUTOTRACK_APPCLICK& 1) << 2
     |(SA_AUTOTRACK_VIEWSCREEN& 1) << 3];
    
    return YES;
}


@end
