//
//  AppDelegate+RemoteNotification.m
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/20.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate+RemoteNotification.h"
//{
//    "aps": {
//        "alert": {
//            "title": "Title",
//            "subtitle": "subtitle",
//            "body": "This is body!"
//        },
//        "category": "MEETING_INVITATION",
//        "image-url":"https://www.baidu.com/img/bd_logo1.png",
//        "mutable-content":1,
//        "content-available":1,
//        "sound":"default",
//        "badge":1
//    }
//}


@implementation AppDelegate (Notification)

- (void)registerNotification {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UNNotificationAction *maybeAction = [UNNotificationAction actionWithIdentifier:@"MAYBE_ACTION" title:@"Maybe" options:UNNotificationActionOptionNone];
    UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"ACCEPT_ACTION" title:@"Accept" options:UNNotificationActionOptionForeground];
    UNNotificationAction *declineAction = [UNNotificationAction actionWithIdentifier:@"DECLINE_ACTION" title:@"Decline" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *likeAction = [UNNotificationAction actionWithIdentifier:@"LIKE_ACTION" title:@"Like" options:UNNotificationActionOptionNone];
    UNNotificationAction *dislikeAction = [UNNotificationAction actionWithIdentifier:@"DISLIKE_ACTION" title:@"Dislike" options:UNNotificationActionOptionNone];
    UNNotificationAction *commentAction = [UNTextInputNotificationAction actionWithIdentifier:@"COMMENT_ACTION" title:@"Comment" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"评论" textInputPlaceholder:@"This is place holder"];
    
    UNNotificationCategory *meetingInviteCategory = [UNNotificationCategory categoryWithIdentifier:@"MEETING_INVITATION"
                                                                                           actions:@[maybeAction, acceptAction, declineAction]
                                                                                 intentIdentifiers:@[]
                                                                     hiddenPreviewsBodyPlaceholder:@""
                                                                                           options:UNNotificationCategoryOptionCustomDismissAction];
    UNNotificationCategory *songRecommendCategory = [UNNotificationCategory categoryWithIdentifier:@"SONG_RECOMMEND"
                                                                                           actions:@[likeAction, dislikeAction, commentAction]
                                                                                 intentIdentifiers:@[]
                                                                     hiddenPreviewsBodyPlaceholder:@""
                                                                                           options:UNNotificationCategoryOptionCustomDismissAction];
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center setNotificationCategories:[NSSet setWithObjects:meetingInviteCategory, songRecommendCategory, nil]];
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert| UNAuthorizationOptionBadge| UNAuthorizationOptionSound
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) { // 点击允许
                                  NSLog(@"注册成功");
                                  [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//                                      NSLog(@"settings: %@", settings);
                                  }];
                              } else { // 点击不允许
                                  NSLog(@"注册失败");
                              }
    }];
    
    
    
}


#pragma mark- fetch token call back

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceTokenString);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

#pragma mark- UNUserNotificationCenterDelegate

// App 处于前台状态时才会调用此方法
// 代理如果没有实现此方法，或者没有及时调用 completionHandler，通知将不予展现
// completionHandler 中 UNNotificationPresentationOptions 参数的作用是确定通知以何种形式展现
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSLog(@"willPresentNotification: %@", notification.request.content.categoryIdentifier);
    completionHandler(UNNotificationPresentationOptionAlert);
}

// 用户与通知交互时调用此方法，如点击推送打开 App、清除该推送或者选择一个 Action
// 该方法会在 didFinishLaunchingWithOptions 后立即回调，所以需要确保 delegate 在 didFinishLaunchingWithOptions: return 之前设置完成
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    
    NSLog(@"didReceiveNotificationResponse: %@", response.notification.request.content);
    NSLog(@"didTapAction: %tu", response.actionIdentifier);
    completionHandler();
}

// The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    
}





@end
