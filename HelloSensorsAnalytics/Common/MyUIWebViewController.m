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
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *webViewContentURL;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;
@end

@implementation MyUIWebViewController

- (instancetype)initWithURL:(NSURL *)url
            webViewDelegate:(id<UIWebViewDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    _webViewContentURL = url;
    _webViewDelegate = delegate;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    NSURL *localURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"blank-white-page" ofType:@"html"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webViewContentURL?: localURL]];
}

- (void)reloadContent {
    [self.webView reload];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [UIWebView new];
        _webView.delegate = self.webViewDelegate;
    }
    return _webView;
}
@end
