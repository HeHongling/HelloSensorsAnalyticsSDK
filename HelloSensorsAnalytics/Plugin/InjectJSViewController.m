//
//  InjectJSViewController.m
//  HelloSensorsAnalytics
//
//  Created by Henry on 2019/1/21.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "InjectJSViewController.h"
#import "CrossH5ViewController.h"
#import "MyWKWebViewController.h"
#import "MyUIWebViewController.h"

/**
 如果 H5 页面为 HTTPS，那么 JS 也需要使用 HTTPS 进行加载，否则可能会被拦截。
 */

static NSString *const localH5Path = @"simple-page.html";
static NSString *const localJSPath = @"sensors.js";
static NSString *const remoteH5Path = @"https://www.baidu.com/s?wd=%E7%A5%9E%E7%AD%96%E6%95%B0%E6%8D%AE";
static NSString *const remoteJSPath = @"https://cdn.jsdelivr.net/gh/HeHongling/HelloSensorsAnalyticsSDK/HelloSensorsAnalytics/General/sensors.js";

@interface InjectJSViewController ()<NestedViewControllerProtocol, UIWebViewDelegate, WKNavigationDelegate>
@end

@implementation InjectJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [webView evaluateJavaScript:injectionJS
              completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                  
              }];
}

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

#pragma mark- others

- (void)refreshWebViewContent {
    UIViewController<WebViewControllerProtocol> *curChild = self.childViewControllers[self.curSelected];
    if ([curChild respondsToSelector:@selector(reloadContent)]) {
        [curChild reloadContent];
    }
}

@end
