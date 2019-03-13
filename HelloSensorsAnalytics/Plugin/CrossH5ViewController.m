//
//  CrossH5ViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2018/9/6.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "CrossH5ViewController.h"
#import "MyWKWebViewController.h"
#import "MyUIWebViewController.h"

@interface CrossH5ViewController ()<NestedViewControllerProtocol, UIWebViewDelegate, WKNavigationDelegate>
@end

@implementation CrossH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag:NO];
}

#pragma mark- NestedViewControllerProtocol

- (void)setupChildViewControllers {
    NSURL *testURL = [NSURL URLWithString:@"https://www.sensorsdata.cn/manual/app_h5.html"];
    MyWKWebViewController *wkWebVC = [[MyWKWebViewController alloc] initWithURL:testURL webViewDelegate:self];
    wkWebVC.title = @"WKWebView";
    MyUIWebViewController *uiWebVC = [[MyUIWebViewController alloc] initWithURL:testURL webViewDelegate:self];
    uiWebVC.title = @"UIWebView";
    
    [self addChildViewController:wkWebVC];
    [self addChildViewController:uiWebVC];
}

// ----------------------------------------------------------------------------
// 检测 Gist https://gist.github.com/HeHongling/7a0f2b266b41bd88cd28ccb3d7b0dce9
// ----------------------------------------------------------------------------
#pragma mark- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView
                                                WithRequest:request
                                               enableVerify:NO]) {
        return NO;
    }
    
    return YES;
}

#pragma mark- WKNavigationDelegate

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView
                                                WithRequest:navigationAction.request
                                               enableVerify:YES]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
