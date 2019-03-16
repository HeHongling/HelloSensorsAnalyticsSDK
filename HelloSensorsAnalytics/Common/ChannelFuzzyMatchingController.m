//
//  ChannelFuzzyMatchingController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/13.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "ChannelFuzzyMatchingController.h"
#import <SafariServices/SafariServices.h>
#import <SVProgressHUD.h>

@interface ChannelFuzzyMatchingController ()<SFSafariViewControllerDelegate>
@property (nonatomic, strong) UILabel *serverLbl, *trackLbl, *visitTipLbl;
@property (nonatomic, strong) UITextField *channelAddressField;
@property (nonatomic, strong) UIButton *changeServerBtn, *visitLinkBtn, *triggerTrackBtn;
@end

@implementation ChannelFuzzyMatchingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self setupData];
    
    self.channelAddressField.text = @"https://test-hechun.datasink.sensorsdata.cn/r/PFK";
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.channelAddressField];
    [self.channelAddressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).multipliedBy(0.8);
        make.left.equalTo(self.view).offset(8);
    }];
    
    [self.view addSubview:self.visitTipLbl];
    [self.visitTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.channelAddressField);
        make.top.equalTo(self.channelAddressField.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.visitLinkBtn];
    [self.visitLinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.channelAddressField);
        make.right.equalTo(self.view).mas_offset(-8);
        make.left.equalTo(self.channelAddressField.mas_right).offset(8);
    }];
    
    
    [self.view addSubview:self.serverLbl];
    [self.serverLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.channelAddressField.mas_top).offset(-50);
        make.left.right.equalTo(self.channelAddressField);
    }];
    
    [self.view addSubview:self.changeServerBtn];
    [self.changeServerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.visitLinkBtn);
        make.centerY.equalTo(self.serverLbl);
    }];
    
    [self.view addSubview:self.trackLbl];
    [self.trackLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.visitTipLbl.mas_bottom).offset(50);
        make.left.right.equalTo(self.channelAddressField);
    }];
    
    [self.view addSubview:self.triggerTrackBtn];
    [self.triggerTrackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.visitLinkBtn);
        make.centerY.equalTo(self.trackLbl);
    }];
    
//    [self.view addSubview:self.nextBtn];
//    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.view).multipliedBy(1.7);
//        make.centerX.equalTo(self.view);
//        make.width.equalTo(self.view).multipliedBy(0.5);
//    }];
}

- (void)setupData {
    self.serverLbl.text = [[SensorsAnalyticsSDK sharedInstance] valueForKey:@"serverURL"];
}

#pragma mark-

- (void)channelAddressDidChangeValue:(UITextField *)sender {
//    - (BOOL)isUrl {
//
//        if(self == nil) {
//            return NO;
//        }
//
//        NSString *url;
//        if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
//            url = [NSString stringWithFormat:@"http://%@",self];
//        }else{
//            url = self;
//        }
//        NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
//        NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
//        return [urlTest evaluateWithObject:url];
//    }
}

- (void)didTappedChangeServerButton:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"数据接收地址" message:@"当前数据接收地址为" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *field;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = [[SensorsAnalyticsSDK sharedInstance] valueForKey:@"serverURL"];
        field = textField;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[SensorsAnalyticsSDK sharedInstance] setServerUrl:field.text];
                                                          self.serverLbl.text = field.text;
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)didTappedVisitChannelLinkButton:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:self.channelAddressField.text];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
}

- (void)didTappedTriggerTrackInstallationButton:(UIButton *)sender {
    [[SensorsAnalyticsSDK sharedInstance] clearKeychainData];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasTrackInstallation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SensorsAnalyticsSDK sharedInstance] trackInstallation:@"AppInstall"];
        [SVProgressHUD dismiss];
    });
}

#pragma mark-

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    if (didLoadSuccessfully) {
        self.visitTipLbl.text = @"访问渠道链接成功";
        self.visitTipLbl.textColor = [UIColor greenColor];
        self.triggerTrackBtn.enabled = YES;
        self.triggerTrackBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
    } else {
        self.visitTipLbl.text = @"访问渠道链接失败";
        self.visitTipLbl.textColor = [UIColor redColor];
        self.triggerTrackBtn.enabled = NO;
        self.triggerTrackBtn.backgroundColor = [UIColor lightGrayColor];
    }
}



#pragma mark-
- (UILabel *)serverLbl {
    if (_serverLbl == nil) {
        _serverLbl = [[UILabel alloc] init];
        _serverLbl.numberOfLines = 0;
        _serverLbl.font = [UIFont systemFontOfSize:13];
    }
    return _serverLbl;
}

- (UILabel *)visitTipLbl {
    if (_visitTipLbl == nil) {
        _visitTipLbl = [[UILabel alloc] init];
        _visitTipLbl.font = [UIFont systemFontOfSize:11];
        _visitTipLbl.text = @"  访问完成后点击左上角【完成】返回此界面";
        _visitTipLbl.textColor = [UIColor brownColor];
        _visitTipLbl.numberOfLines = 0;
    }
    return _visitTipLbl;
}

- (UIButton *)changeServerBtn {
    if (_changeServerBtn == nil) {
        _changeServerBtn = [[UIButton alloc] init];
        [_changeServerBtn setTitle:@" 更改 " forState:UIControlStateNormal];
        _changeServerBtn.layer.cornerRadius = 5;
         [_changeServerBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:136/255.0 blue:255/255.0 alpha:1.0]];
        [_changeServerBtn addTarget:self action:@selector(didTappedChangeServerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeServerBtn;
}

- (UITextField *)channelAddressField {
    if (_channelAddressField == nil) {
        _channelAddressField = [[UITextField alloc] init];
        _channelAddressField.borderStyle = UITextBorderStyleRoundedRect;
        _channelAddressField.placeholder = @"输入渠道链接";
        _channelAddressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _channelAddressField;
}

- (UIButton *)visitLinkBtn {
    if (_visitLinkBtn == nil) {
        _visitLinkBtn = [[UIButton alloc] init];
        [_visitLinkBtn setTitle:@" 访问 " forState:UIControlStateNormal];
        [_visitLinkBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _visitLinkBtn.layer.cornerRadius = 5;
        [_visitLinkBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:136/255.0 blue:255/255.0 alpha:1.0]];
        [_visitLinkBtn addTarget:self action:@selector(didTappedVisitChannelLinkButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visitLinkBtn;
}

- (UILabel *)trackLbl {
    if (_trackLbl == nil) {
        _trackLbl = [[UILabel alloc] init];
        _trackLbl.text = @"trackInstallation";
        _trackLbl.font = [UIFont systemFontOfSize:18];
    }
    return _trackLbl;
}

- (UIButton *)triggerTrackBtn {
    if (_triggerTrackBtn == nil) {
        _triggerTrackBtn = [[UIButton alloc] init];
        [_triggerTrackBtn setTitle:@" 触发 " forState:UIControlStateNormal];
//         [_triggerTrackBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:136/255.0 blue:255/255.0 alpha:1.0]];
        [_triggerTrackBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_triggerTrackBtn addTarget:self action:@selector(didTappedTriggerTrackInstallationButton:) forControlEvents:UIControlEventTouchUpInside];
        _triggerTrackBtn.layer.cornerRadius = 5;
        _triggerTrackBtn.enabled = NO;
    }
    return _triggerTrackBtn;
}


@end
