//
//  ChannelMatchingController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/13.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "ChannelMatchingController.h"
#import "ChannelFuzzyMatchingController.h"
#import "ChannelPreciseMatchingController.h"


@interface ChannelMatchingController ()<NestedViewControllerProtocol>

@end

@implementation ChannelMatchingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupChildViewControllers {
    ChannelFuzzyMatchingController *fuzzy = [[ChannelFuzzyMatchingController alloc] init];
    fuzzy.title = @"模糊匹配";
    [self addChildViewController:fuzzy];
    
    ChannelPreciseMatchingController *precise = [[ChannelPreciseMatchingController alloc] init];
    precise.title = @"精准匹配";
    [self addChildViewController:precise];
}

@end
