//
//  ChannelPreciseMatchingController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/13.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "ChannelPreciseMatchingController.h"

@interface ChannelPreciseMatchingController ()
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation ChannelPreciseMatchingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.centerY.equalTo(self.view).multipliedBy(1.7);
    }];
    
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:[UIColor blueColor]];
        [_nextBtn.layer setBorderWidth:1.0];
        [_nextBtn.layer setBorderColor:[UIColor orangeColor].CGColor];
        [_nextBtn.layer setCornerRadius:10.0];
    }
    return _nextBtn;
}

@end
