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
#import "AppDelegate+RemoteNotification.h"

//#define SA_SERVER_URL @"<#CustomServerURL#>"
#ifndef SA_SERVER_URL
#define SA_SERVER_URL @"http://test-hechun.datasink.sensorsdata.cn/sa?project=hehongling&token=d28b875ed9ac268f"
#endif

#define SA_AUTOTRACK_APPSTART 1
#define SA_AUTOTRACK_APPEND 1
#define SA_AUTOTRACK_APPCLICK 1
#define SA_AUTOTRACK_VIEWSCREEN 1


@interface AppDelegate ()
@property (nonatomic, strong) NSDictionary *launchOptions;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.launchOptions = launchOptions;
//    [self trackEvent:@"didFinishLaunching" properties:nil];
    [self registerNotification];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyWindow];
    self.window.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self setupSensors];
    });
    return YES;
}


- (void)setupSensors {
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL andDebugMode:SensorsAnalyticsDebugAndTrack];
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:(SA_AUTOTRACK_APPSTART& 1) << 0
     |(SA_AUTOTRACK_APPEND& 1) << 1
     |(SA_AUTOTRACK_APPCLICK& 1) << 2
     |(SA_AUTOTRACK_VIEWSCREEN& 1) << 3];
}

- (void)trackEvent:(NSString *)event properties:(NSDictionary *)properties {
//    if (![SensorsAnalyticsSDK sharedInstance]) {
//        [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL andLaunchOptions:self.launchOptions andDebugMode:SensorsAnalyticsDebugOff];
//        [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:(SA_AUTOTRACK_APPSTART& 1) << 0
//         |(SA_AUTOTRACK_APPEND& 1) << 1
//         |(SA_AUTOTRACK_APPCLICK& 1) << 2
//         |(SA_AUTOTRACK_VIEWSCREEN& 1) << 3];
//    }
    [[SensorsAnalyticsSDK sharedInstance] track:event withProperties:properties];
}


@end
