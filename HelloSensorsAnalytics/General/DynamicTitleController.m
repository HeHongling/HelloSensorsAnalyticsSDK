//
//  DynamicTitleController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2018/12/3.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "DynamicTitleController.h"


@interface DynamicTitleController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *myWebView;
@end

@implementation DynamicTitleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DynamicTitle" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [self.myWebView loadRequest:request];
    
    [self.view addSubview:self.myWebView];
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIWebView *)myWebView {
    if (_myWebView == nil) {
        _myWebView = [[UIWebView alloc] init];
        _myWebView.delegate = self;
    }
    return _myWebView;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [[SensorsAnalyticsSDK sharedInstance] trackViewScreen:self];
}

@end
