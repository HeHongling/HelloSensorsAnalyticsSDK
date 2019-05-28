//
//  NotificationViewController.m
//  RemoteNotificationContent
//
//  Created by HeHongling on 2019/5/28.
//  Copyright © 2019 Henry. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
    for (UNNotificationAttachment *attachment in notification.request.content.attachments) {
        if ([attachment.URL.pathExtension isEqualToString:@"jpeg"]) {
            self.imageView.image = [UIImage imageWithContentsOfFile:attachment.URL.path];
        }
    }
    
}


@end
