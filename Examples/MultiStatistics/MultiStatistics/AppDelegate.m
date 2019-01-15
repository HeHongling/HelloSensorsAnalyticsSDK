//
//  AppDelegate.m
//  MultiStatistics
//
//  Created by apple on 2018/12/12.
//  Copyright © 2018 Telit. All rights reserved.
//

#import "AppDelegate.h"
#if __has_include(<SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

#import <UMCommon/UMConfigure.h>
#import <UMAnalytics/MobClick.h>

static NSString *const kSensorsServerURL = @"http://test-hechun.datasink.sensorsdata.cn/sa?project=hehongling&token=d28b875ed9ac268f";

static NSString *const kAppChannel = @"AppStore";
static NSString *const kUmengAppKey = @"5c3563edf1f55696db001434";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupUmeng];
    return YES;
}

- (void)setupSensors {
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:kSensorsServerURL andDebugMode:SensorsAnalyticsDebugOff];
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart
                                                         |SensorsAnalyticsEventTypeAppEnd
                                                         |SensorsAnalyticsEventTypeAppViewScreen
                                                         |SensorsAnalyticsEventTypeAppClick];
}


- (void)setupUmeng {
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:kUmengAppKey channel:kAppChannel];
    [MobClick setScenarioType:E_UM_NORMAL];
}

@end
