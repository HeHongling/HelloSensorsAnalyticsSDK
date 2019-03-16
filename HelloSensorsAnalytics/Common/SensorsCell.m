//
//  SensorsCell.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/15.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "SensorsCell.h"

@interface SensorsCell ()
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *accessoryView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation SensorsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.width.lessThanOrEqualTo(self);
    }];
    
    [self addSubview:self.accessoryView];
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(self);
        make.width.equalTo(self.accessoryView.mas_height);
        make.height.lessThanOrEqualTo(self.mas_height);
    }];
    return self;
}


- (UIView *)topLineView {
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:17];
    }
    return _textLabel;
}

- (UIImageView *)accessoryView {
    if (_accessoryView == nil) {
        _accessoryView = [[UIImageView alloc] init];
        
    }
    return _accessoryView;
}

@end
