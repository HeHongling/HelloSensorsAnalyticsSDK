//
//  MyWKWebViewController.h
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/1/5.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface MyWKWebViewController : UIViewController

- (instancetype)initWithURL:(NSURL *)url webViewDelegate:(id<WKNavigationDelegate>)delegate;
@end
