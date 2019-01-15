//
//  ViewController.m
//  JSInjection
//
//  Created by HeHongling on 2018/9/5.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "ViewController.h"
#if __has_include(<SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webview.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://www.jd.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"SensorsAnalyticsSDK" ofType:@"js"];
    NSString *jsString = [NSString stringWithContentsOfFile:jsPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    // 去除 <script> 标识
    NSRange tagRange = [jsString rangeOfString:@"<script>"];
    jsString = [jsString substringFromIndex:(tagRange.location + tagRange.length)];
    jsString = [jsString substringToIndex:[jsString rangeOfString:@"</script>"].location];
    jsString = [NSString stringWithFormat:@"javascript:%@", jsString];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    return YES;
}

@end
