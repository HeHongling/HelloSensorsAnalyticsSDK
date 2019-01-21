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

@interface CrossH5ViewController ()<UIScrollViewDelegate, UIWebViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UISegmentedControl *segCtrl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CrossH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewControllers];
    [self setupNavigationBar];
    [self setupSubviews];
    
    [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag:NO];
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

#pragma mark- others

- (void)setupChildViewControllers {
    NSURL *testURL = [NSURL URLWithString:@"https://www.sensorsdata.cn/manual/app_h5.html"];
    MyWKWebViewController *wkWebVC = [[MyWKWebViewController alloc] initWithURL:testURL webViewDelegate:self];
    wkWebVC.title = @"WKWebView";
    MyUIWebViewController *uiWebVC = [[MyUIWebViewController alloc] initWithURL:testURL webViewDelegate:self];
    uiWebVC.title = @"UIWebView";
    
    [self addChildViewController:wkWebVC];
    [self addChildViewController:uiWebVC];
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
