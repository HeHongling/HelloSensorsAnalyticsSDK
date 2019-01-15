//
//  AppDelegate+RemoteNotification.h
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/20.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

typedef NS_OPTIONS(NSUInteger, SAVendorPushServices) {
    SAVendorPushServiceNone     = 0,
    SAVendorPushServiceJPush    = 1 << 0,
    SAVendorPushServiceUMPush   = 1 << 1,
    SAVendorPushServiceXGPush   = 1 << 2,
};

@interface AppDelegate (Notification)<UNUserNotificationCenterDelegate>
- (void)registerRemoteNotificationsWithVendors:(SAVendorPushServices)vendorServices withLaunchOptions:(NSDictionary *)launchOptions;
@end
