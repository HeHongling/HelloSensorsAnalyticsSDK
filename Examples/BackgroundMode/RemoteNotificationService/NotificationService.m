//
//  NotificationService.m
//  RemoteNotificationService
//
//  Created by HeHongling on 2019/5/28.
//  Copyright © 2019 Henry. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    NSString *imageURL = [self.bestAttemptContent.userInfo[@"aps"] valueForKey:@"image-url"];
    if (!imageURL.length) {
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    
    [self loadAttachmentForURLString:imageURL withType:@"jpg" completionHandler:^(UNNotificationAttachment *attachment) {
        if (attachment) {
            NSMutableArray *mutableCopy = [self.bestAttemptContent.attachments mutableCopy];
            [mutableCopy addObject:attachment];
            self.bestAttemptContent.attachments = mutableCopy;
        }
        self.contentHandler(self.bestAttemptContent);
    }];
    
}
                                  
- (void)loadAttachmentForURLString:(NSString *)urlStr withType:(NSString *)type
                 completionHandler:(void(^)(UNNotificationAttachment *attachment))completionHandler {
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *tmpLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSURL *targetURL = [NSURL fileURLWithPath:[[tmpLocation.path stringByDeletingPathExtension] stringByAppendingPathExtension:fileExt]];
                        NSError *error;
                        
                        [[NSFileManager defaultManager] moveItemAtURL:tmpLocation toURL:targetURL error:&error];
                        if (error) {
                            completionHandler(nil);
                        }
                        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:targetURL options:nil error:&error];
                        if (error) {
                            completionHandler(nil);
                        }
                        completionHandler(attachment);
                    }
                }] resume];
}

- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    return [@"." stringByAppendingString:ext];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
