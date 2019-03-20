//
//  SensorsUtil.h
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/14.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SensorsUtil : NSObject

+ (NSString *)sdkServerURL;
+ (NSString *)sdkServerDesc;
+ (NSString *)sdkDistinctId;
+ (NSString *)sdkLoginId;
+ (NSString *)sdkAnonymousId;
+ (NSString *)sdkDeviceId;

+ (NSString *)idfaString;
+ (NSString *)idfvString;

+ (void)fetchLocalIPAddressWithCompletion:(void(^)(NSString *localIP))completion;
+ (void)fetchInternetIPAddressWithCompletion:(void(^)(NSString *internetIP))completion;
@end

