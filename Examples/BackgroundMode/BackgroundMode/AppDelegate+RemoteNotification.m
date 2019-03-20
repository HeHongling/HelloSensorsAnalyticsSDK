//
//  AppDelegate+RemoteNotification.m
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/20.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate+RemoteNotification.h"
#import <SensorsAnalyticsSDK.h>
#import <JPUSHService.h>

static NSString *const kAppChannel = @"AppStore";
static BOOL const kProduction = NO;

static NSString *const kJpushAppKey = @"de4ef20e172c71c9d5ecf878";

@implementation AppDelegate (Notification)

static SAVendorPushServices _vendorServices;

- (void)registerRemoteNotificationsWithVendors:(SAVendorPushServices)vendorServices withLaunchOptions:(NSDictionary *)launchOptions {
    _vendorServices = vendorServices;
    
    // 注册通知
    UNUserNotificationCenter *notCenter = [UNUserNotificationCenter currentNotificationCenter];
    notCenter.delegate = self;
    [notCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert| UNAuthorizationOptionBadge| UNAuthorizationOptionSound
                             completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                 if(granted) { // 用户点击了允许
                                     
                                 }
                             }];
    
    // 注册推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if ((vendorServices & SAVendorPushServiceJPush) == SAVendorPushServiceJPush) {
        [JPUSHService setupWithOption:launchOptions appKey:kJpushAppKey channel:kAppChannel apsForProduction:kProduction];
    }
}

/// 获取 deviceToken 成功
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *tokenStr = [[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""]
                          uppercaseString];
    NSLog(@"Register remote notification success with token: %@", tokenStr);
    [JPUSHService registerDeviceToken:deviceToken];
}

/// 获取 deviceToken 失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Register remote notification failed with error: %@", error);;
}

#pragma mark- 推送处理
/// 接收到推送 || 点击推送
-(void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self trackEvent:@"didReceiveRemoteNotification" properties:nil];
    if (application.applicationState == UIApplicationStateBackground) {
        // track 推送到达
        // 强制 flush
        [[SensorsAnalyticsSDK sharedInstance] track:@"ReceivedPush" withProperties:@{@"state": @"background"}];

    } else if (application.applicationState == UIApplicationStateInactive) {
        // track 推送点击
        [[SensorsAnalyticsSDK sharedInstance] track:@"TouchedPush" withProperties:@{@"state": @"background"}];
    } else {
        [[SensorsAnalyticsSDK sharedInstance] track:@"ReceivedPush" withProperties:@{@"state": @"active"}];
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
            // track 推送到达
        }
    }

    [JPUSHService handleRemoteNotification:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self trackEvent:@"didReceiveRemoteNotification" properties:nil];
}

#pragma mark- 通知处理
/// 系统 >= iOS 10 && App 处于前台时接收到推送
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    [self trackEvent:@"willPresentNotification" properties:nil];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) { // 远程推送
        
    }else{ // 本地推送
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 应用在前台时使用哪些策略
}

/// 用户点击推送(前台或后台)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [self trackEvent:@"didReceiveNotificationResponse" properties:nil];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) { // 远程推送
    }else{ // 本地推送
    }
}

- (void)application:(UIApplication *)application handleIntent:(INIntent *)intent completionHandler:(void (^)(INIntentResponse * _Nonnull))completionHandler {
    [self trackEvent:@"handleIntent" properties:nil];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
