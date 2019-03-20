//
//  AppDelegate.h
//  BackgroundMode
//
//  Created by HeHongling on 2018/9/20.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void)trackEvent:(NSString *)event properties:(NSDictionary *)properties;

@end

