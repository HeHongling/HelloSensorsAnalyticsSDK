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

@interface InjectJSViewController ()<UIScrollViewDelegate, UIWebViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UISegmentedControl *segCtrl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation InjectJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupChildViewControllers];
    [self setupNavigationBar];
    [self setupSubviews];
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

- (void)setupNavigationBar {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.childViewControllers.count == 0) {
        return;
    }
    
    NSMutableArray *segTitles = [NSMutableArray arrayWithCapacity:self.childViewControllers.count];
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVC = self.childViewControllers[i];
        [segTitles addObject:childVC.title?: [NSString stringWithFormat:@"index-%2d", i]];
    }
    
    _segCtrl = [[UISegmentedControl alloc] initWithItems:segTitles];
    _segCtrl.selectedSegmentIndex = 0;
    [_segCtrl addTarget:self action:@selector(indexDidChangeForSegmentedControl:)
       forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:self.segCtrl];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self
                                                                               action:@selector(refreshWebViewContent)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupSubviews {
    NSUInteger numberOfChildren = self.childViewControllers.count;
    if (numberOfChildren == 0) {
        return;
    }
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width).multipliedBy(numberOfChildren);
    }];
    
    UIViewController *firstVC = [self.childViewControllers firstObject];
    [self.containerView addSubview:firstVC.view];
    [firstVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(self.scrollView);
        make.top.left.bottom.equalTo(self.containerView);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    self.segCtrl.selectedSegmentIndex = (NSInteger)(offset.x/scrollView.bounds.size.width);
    [self loadChildView];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)seg {
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = seg.selectedSegmentIndex * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
    
    [self loadChildView];
}

- (void)refreshWebViewContent {
    UIViewController<WebViewControllerProtocol> *curChild = self.childViewControllers[self.segCtrl.selectedSegmentIndex];
    if ([curChild respondsToSelector:@selector(reloadContent)]) {
        [curChild reloadContent];
    }
}

- (void)loadChildView {
    NSInteger curIndex = self.segCtrl.selectedSegmentIndex;
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    UIViewController *curVC = self.childViewControllers[curIndex];
    if (curVC.viewLoaded) {
        return;
    }
    [self.containerView addSubview:curVC.view];
    [curVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(self.scrollView);
        make.top.bottom.equalTo(self.containerView);
        make.left.equalTo(self.containerView).offset( curIndex * scrollViewWidth);
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [UIView new];
    }
    return _containerView;
}


@end
