//
//  MyWKWebViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/1/5.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "MyWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "CrossH5ViewController.h"

@interface MyWKWebViewController ()
<WKNavigationDelegate,
WebViewControllerProtocol
>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation MyWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag:NO];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CrossH5" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
   // 检测代码 https://gist.github.com/HeHongling/7a0f2b266b41bd88cd28ccb3d7b0dce9
    
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView
                                                WithRequest:navigationAction.request
                                               enableVerify:YES]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 在这里添加您的逻辑代码
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)reloadContent {
    [self.webView reload];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
