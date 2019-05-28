//
//  AppDelegate+RemoteNotification.h
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/20.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (Notification)<UNUserNotificationCenterDelegate>

- (void)registerNotification;
@end
