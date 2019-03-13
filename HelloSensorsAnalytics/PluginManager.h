//
//  PluginManager.h
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/12.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plugin: NSObject
@property (nonatomic, assign) Class relateCls;
@property (nonatomic, copy) NSString *pluginTitle;
@property (nonatomic, copy) NSString *pluginDesc;
@property (nonatomic, copy) NSString *belongsModule;
@end


@interface PluginManager : NSObject<UITableViewDataSource>

+ (instancetype)sharedManager;
- (void)addPlugin:(nonnull NSString *)clsName
            title:(nonnull NSString *)title
      description:(NSString *)desc
           module:(nonnull NSString *)moduleName;

- (Plugin *)pluginForIndexPath:(NSIndexPath *)indexPath;

@end

