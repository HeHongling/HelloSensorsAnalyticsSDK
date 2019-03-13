//
//  NestedViewController.h
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/13.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NestedViewControllerProtocol <NSObject>
@required
- (void)setupChildViewControllers;
@end


@interface NestedViewController : UIViewController
@property (nonatomic, weak) id<NestedViewControllerProtocol> child;
@property (nonatomic, assign, readonly) NSInteger curSelected;
@end

