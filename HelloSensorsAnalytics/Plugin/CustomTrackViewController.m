//
//  CustomTrackViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/1/17.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "CustomTrackViewController.h"

@interface CustomTrackViewController ()

@end

@implementation CustomTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[SensorsAnalyticsSDK sharedInstance] track:@"JST" withProperties:@{@"aAa": @(1),
//                                                                        @"BBB": @[@"aaa", @"jjj"],
                                                                        @"CCC": @"ccc"
                                                                        }];
}

@end
