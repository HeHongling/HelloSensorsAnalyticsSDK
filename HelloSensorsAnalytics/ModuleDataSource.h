//
//  ModuleDataSource.h
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/15.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModuleDataDelegate <NSObject>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface ModuleDataSource : NSObject<UITableViewDataSource>
- (instancetype)initWithDelegate:(id<ModuleDataDelegate>)delegate;

- (void)addCellModel:(id)model belongModule:(NSString *)module;

- (id)cellModelForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForCellModel:(id)cellModel;
@end

