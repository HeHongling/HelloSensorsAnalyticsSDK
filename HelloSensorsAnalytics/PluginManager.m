//
//  PluginManager.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/12.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "PluginManager.h"


@implementation Plugin
@end


@interface Module : NSObject
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, strong) NSMutableArray <Plugin *>*subPlugins;
@end

@implementation Module
@end


@interface PluginManager ()
@property (nonatomic, strong) NSMutableArray <Module *>*dataArray;
@end


@implementation PluginManager

+ (instancetype)sharedManager {
    static PluginManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)addPlugin:(NSString *)clsName
            title:(NSString *)title
      description:(NSString *)desc
           module:(NSString *)moduleName {
    Class vcCls = NSClassFromString(clsName);
    if (!vcCls) {
        return;
    }
    Plugin *plugin = [Plugin new];
    plugin.relateCls = vcCls;
    plugin.pluginTitle = title;
    plugin.pluginDesc = desc;
    plugin.belongsModule = moduleName;
    
    BOOL hasModule = NO;
    for (Module *moduleModel in self.dataArray) {
        if ([moduleModel.moduleName isEqualToString:moduleName] ) {
            hasModule = YES;
            [moduleModel.subPlugins addObject:plugin];
        }
    }
    
    if (!hasModule) {
        Module *newModule = [Module new];
        newModule.moduleName = moduleName;
        newModule.subPlugins = [NSMutableArray array];
        [newModule.subPlugins addObject:plugin];
        [self.dataArray addObject:newModule];
    }
}

- (Plugin *)pluginForIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.section].subPlugins[indexPath.row];
}


#pragma mark- UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].moduleName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.dataArray.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataArray[section].subPlugins.count;
    return count;
}

- (NSArray *)allPlugins {
    return [self.dataArray copy];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
//        cell.detailTextLabel.numberOfLines = 0;
    }
    Plugin *pluginModel = self.dataArray[indexPath.section].subPlugins[indexPath.row];
    cell.textLabel.text = pluginModel.pluginTitle;
    cell.detailTextLabel.text = pluginModel.pluginDesc;
    return cell;
}

- (NSMutableArray<Module *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end
