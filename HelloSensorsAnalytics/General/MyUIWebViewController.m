//
//  MyUIWebViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/1/5.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "MyUIWebViewController.h"
#import "CrossH5ViewController.h"


@interface MyUIWebViewController ()
<
UIWebViewDelegate,
WebViewControllerProtocol
>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation MyUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CrossH5" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    // 检测代码 https://gist.github.com/HeHongling/7a0f2b266b41bd88cd28ccb3d7b0dce9
    
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView
                                                WithRequest:request
                                               enableVerify:NO]) {
        return NO;
    }
    
    return YES;
}

- (void)reloadContent {
    [self.webView reload];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [UIWebView new];
        _webView.delegate = self;
    }
    return _webView;
}
@end
