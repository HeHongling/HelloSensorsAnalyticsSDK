//
//  ModuleDataSource.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/15.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "ModuleDataSource.h"

@interface SAModule : NSObject
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, strong) NSMutableArray *subItems;
@end

@implementation SAModule
@end


@interface ModuleDataSource()
@property (nonatomic, strong) NSMutableArray <SAModule *> *dataArray;
@property (nonatomic, weak) id<ModuleDataDelegate> delegate;
@end


@implementation ModuleDataSource

- (instancetype)init {
    NSAssert(NO, @"user initWithDelegate:");
    return nil;
}

- (instancetype)initWithDelegate:(id<ModuleDataDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    _delegate = delegate;
    return self;
}

- (void)addCellModel:(id)model belongModule:(NSString *)moduleName {
    BOOL hasModule = NO;
    for (SAModule *moduleItem in self.dataArray) {
        if ([moduleItem.moduleName isEqualToString:moduleName]) {
            hasModule = YES;
            [moduleItem.subItems addObject:model];
        }
    }
    
    if (!hasModule) {
        SAModule *newModule = [SAModule new];
        newModule.moduleName = moduleName;
        newModule.subItems = [NSMutableArray array];
        [newModule.subItems addObject:model];
        [self.dataArray addObject:newModule];
    }
}

- (id)cellModelForIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.section].subItems[indexPath.row];
}

- (NSIndexPath *)indexPathForCellModel:(id)cellModel {
    for (int i = 0; i < self.dataArray.count; i++) {
        SAModule *moduleModel = self.dataArray[i];
        NSInteger row = [moduleModel.subItems indexOfObject:cellModel];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForRow:row inSection:i];
        }
    }
    return nil;
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
    NSInteger count = self.dataArray[section].subItems.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSMutableArray<SAModule *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}




#pragma mark- 
@end
