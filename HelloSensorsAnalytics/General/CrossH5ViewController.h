//
//  CrossH5ViewController.h
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2018/9/6.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WebViewControllerProtocol <NSObject>
@required
- (void)reloadContent;
@end


@interface CrossH5ViewController : UIViewController

@end
