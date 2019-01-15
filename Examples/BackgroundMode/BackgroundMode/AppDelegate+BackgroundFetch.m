//
//  AppDelegate+BackgroundFetch.m
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/21.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate+BackgroundFetch.h"
#import <SensorsAnalyticsSDK.h>

@implementation AppDelegate (BackgroundFetch)

- (void)registerBackgroundFetch {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
}

- (void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[SensorsAnalyticsSDK sharedInstance] track:@"BackgroundFetch"];
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
