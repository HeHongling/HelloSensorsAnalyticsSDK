//
//  NestedViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/13.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "NestedViewController.h"

@interface NestedViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UISegmentedControl *segCtrl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger curSelected;
@end

@implementation NestedViewController

- (instancetype)init {
    self = [super init];
    if ([self conformsToProtocol:@protocol(NestedViewControllerProtocol)]) {
        self.child = (id<NestedViewControllerProtocol>)self;
    } else {
        NSAssert(NO, @"子类必须实现 NestedViewControllerProtocol 协议");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewControllers];
    [self nestedViewController_setupNavigationBar];
    [self nestedViewController_setupSubviews];
}

- (void)setupChildViewControllers {
    NSAssert(NO, @"子类必须实现 setupChildViewControllers 方法");
}

- (void)nestedViewController_setupNavigationBar {
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
}

- (void)nestedViewController_setupSubviews {
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

- (NSInteger)curSelected {
    return self.segCtrl.selectedSegmentIndex;
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
