//
//  InjectJSViewController.m
//  HelloSensorsAnalytics
//
//  Created by Henry on 2019/1/21.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "InjectJSViewController.h"
#import "MyWKWebViewController.h"
#import "MyUIWebViewController.h"

/**
 1. 需要注入的 js 需要包含神策 js SDK + 初始化 SDK 代码
 2. 如果 H5 为 https，则注入的 js 也应该使用 https 加载
 3. 注入之后，相当于目标 H5 集成了神策 SDK，如果需要使用 App 上报事件，仍需要走打通 App 与 H5 打通流程
 */

static NSString *const localH5Path = @"simple-page.html";
static NSString *const localJSPath = @"sensors.js";
static NSString *const remoteH5Path = @"https://www.baidu.com/s?wd=%E7%A5%9E%E7%AD%96%E6%95%B0%E6%8D%AE";
static NSString *const remoteJSPath = @"https://hehongling.github.io/external/sensorsdata/js/injection.js";

@interface InjectJSViewController ()<NestedViewControllerProtocol, UIWebViewDelegate, WKNavigationDelegate>
@end

@implementation InjectJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag:NO];
    [self initUI];
}

- (void)initUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self
                                                                               action:@selector(refreshWebViewContent)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark- NestedViewControllerProtocol

- (void)setupChildViewControllers {
    NSURL *localH5URL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:localH5Path];
    NSURL *remoteH5URL = [NSURL URLWithString:remoteH5Path];
    
    MyUIWebViewController *uiWebVC = [[MyUIWebViewController alloc] initWithURL:localH5URL webViewDelegate:self];
    uiWebVC.title = @"UIWebView";
    MyWKWebViewController *wkWebVC = [[MyWKWebViewController alloc] initWithURL:remoteH5URL webViewDelegate:self];
    wkWebVC.title = @"WKWebView";
    
    [self addChildViewController:uiWebVC];
    [self addChildViewController:wkWebVC];
}

#pragma mark- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *injectionJS = [NSString stringWithFormat:@"var script = document.createElement('script');"
                             "script.type = 'text/javascript';"
                             "script.src = \'%@\';"
                             "document.getElementsByTagName('head')[0].appendChild(script);", localJSPath];
    [webView stringByEvaluatingJavaScriptFromString:injectionJS];
}

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

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJS = [NSString stringWithFormat:@"var script = document.createElement('script');"
                             "script.type = 'text/javascript';"
                             "script.src = \'%@\';"
                             "document.getElementsByTagName('head')[0].appendChild(script);", remoteJSPath];
    [webView evaluateJavaScript:injectionJS completionHandler:NULL];
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView
                                                WithRequest:navigationAction.request
                                               enableVerify:NO]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark- event handler

- (void)refreshWebViewContent {
    UIViewController *curChild = self.childViewControllers[self.curSelected];
    if ([curChild respondsToSelector:NSSelectorFromString(@"reloadContent")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [curChild performSelector:NSSelectorFromString(@"reloadContent")];
#pragma clang diagnostic pop
    }
}

@end
