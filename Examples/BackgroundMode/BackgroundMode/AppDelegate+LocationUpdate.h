//
//  AppDelegate+LocationUpdate.h
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/21.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate (LocationUpdate)

- (void)registerLocationUpdateServiceWithLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
