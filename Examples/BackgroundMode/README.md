# PushDemo


系统远程推送注册方法

```Objective-C
    UNUserNotificationCenter *notCenter = [UNUserNotificationCenter currentNotificationCenter];
    notCenter.delegate = self;
    [notCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge
    completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) { // 用户选择接受 Push 消息
            dispatch_async(dispatch_get_main_queue(), ^{
                [application registerForRemoteNotifications];
            });
        }
    }];
```

一般推送厂商有类似方法，并替换 delegate



## 友盟

## 信鸽

信鸽配置方法 `- startXGWithAppID: appKey: delegate:`  会将自己设置为 UNUserNotificationCenter 的 delegate，然后在内部调用 UIApplication.sharedApplication.delegate 相关方法，造成是 UNUserNotificationCenter 回调的假象 


### LocationUpdate
* 开启  `Background Modes --> Location Updates`  之后，位置更新时即会后台启动 App
* 如果此时需要记录用户当前位置信息，需要建立 CLLocationManager 并 update
[Handling Location Events in the Background](https://developer.apple.com/documentation/corelocation/getting_the_user_s_location/handling_location_events_in_the_background?language=objc)

