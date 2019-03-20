//
//  SensorsUtil.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/14.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "SensorsUtil.h"
#import <AdSupport/AdSupport.h>
#import <LDNetGetAddress.h>
#import <SensorsAnalyticsSDK.h>

@implementation SensorsUtil

+ (NSString *)sdkServerURL {
    return [[SensorsAnalyticsSDK sharedInstance] valueForKey:@"serverURL"];
}

+ (NSString *)sdkServerDesc {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:self.sdkServerURL];
    if (!urlComponents) {
        return nil;
    }
    NSString *host = urlComponents.host;
    if (host.length < 1) {
        return nil;
    }
    NSString *firstComponent = [[host componentsSeparatedByString:@"."] firstObject];
    NSString *project;
    for (NSURLQueryItem *item in urlComponents.queryItems) {
        if ([item.name isEqualToString:@"project"]) {
            project = item.value;
        }
    }
    
    return [project?:@"default" stringByAppendingFormat:@"@%@", firstComponent];
}

+ (NSString *)sdkDistinctId {
    return self.sdkLoginId?: self.sdkAnonymousId;
}

+ (NSString *)sdkAnonymousId {
    return [[SensorsAnalyticsSDK sharedInstance] distinctId];
}

+ (NSString *)sdkLoginId {
    return [[SensorsAnalyticsSDK sharedInstance] loginId];
}

+ (NSString *)sdkDeviceId {
    return [SensorsAnalyticsSDK valueForKey:@"getUniqueHardwareId"];
}

+ (NSString *)idfaString {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)idfvString {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (void)fetchLocalIPAddressWithCompletion:(void (^)(NSString *))completion {
    if (!completion) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *localIPAddress = [LDNetGetAddress deviceIPAdress];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(localIPAddress);
        });
    });
}

+ (void)fetchInternetIPAddressWithCompletion:(void (^)(NSString *))completion {
    if (!completion) {
        return;
    }
    
    NSURL *url1 = [NSURL URLWithString:@"http://icanhazip.com/"];
    NSURL *url2 = [NSURL URLWithString:@"https://api.ipify.org/"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 3;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    BOOL (^isValidIP)(NSString *) = ^BOOL(NSString *ipString) {
        if (ipString && ipString) {
            NSString *regex = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            return [predicate evaluateWithObject:ipString];
        }
        return NO;
    };
    
    [[session dataTaskWithURL:url1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && data.length > 0) {
            NSString *contentStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (isValidIP(contentStr)) {
                [self executeInMainQueue:^{
                    completion(contentStr);
                }];
                return ;
            }
        }
        [[session dataTaskWithURL:url2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && data.length > 0) {
                NSString *contentStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (isValidIP(contentStr)) {
                    [self executeInMainQueue:^{
                        completion(contentStr);
                    }];
                } else {
                    [self executeInMainQueue:^{
                        completion(nil);
                    }];
                }
            }
        }] resume];
    }] resume];
}

+ (void)executeInMainQueue:(void(^)(void))block {
    if ([[NSThread currentThread] isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@end
