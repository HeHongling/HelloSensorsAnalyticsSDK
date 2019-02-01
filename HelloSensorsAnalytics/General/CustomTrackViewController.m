//
//  CustomTrackViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/1/17.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "CustomTrackViewController.h"
#import "CTPropertyItem.h"
#import "CTPropertyCell.h"

@interface CustomTrackViewController ()
@property (nonatomic, strong) NSMutableArray *rootItems;
@property (nonatomic, strong) NSMutableArray *displayItems;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;
@end

@implementation CustomTrackViewController

- (instancetype)init {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight = 46;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

#pragma mark- datasource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CTPropertyItem *item = self.displayItems[indexPath.row-1];
        [self.displayItems removeObject:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (item.valueType == CTPropertyTypeChild) {
            [item.superItem removeChildItem:item];
        } else {
            [self.rootItems removeObject:item];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayItems.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    CTPropertyItem *bindItem;
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cellIdentifier = @"HeaderCell";
    } else {
        bindItem = self.displayItems[indexPath.row-1];
        cellIdentifier = [CTPropertyCell cellIdentifierForItemType:bindItem.valueType];
    }
    
    CTPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    __weak typeof(self) weakSelf = self;
    cell.commonAddButtonHandler = ^(CTPropertyCell *cell) {
        if (bindItem.valueType == CTPropertyTypeChild) {
            [weakSelf insertElementWithType:CTPropertyTypeChild
                                 sourceItem:bindItem
                            sourceIndexPath:[tableView indexPathForCell:cell]];
        } else {
            
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"属性类型"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"String" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [weakSelf insertElementWithType:CTPropertyTypeString
                                                                                sourceItem:bindItem
                                                                           sourceIndexPath:[tableView indexPathForCell:cell]];
                                                       }]];
            
//            [alertCtr addAction:[UIAlertAction actionWithTitle:@"Date" style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction * _Nonnull action) {
//                                                           [weakSelf insertElementWithType:CTPropertyTypeDate
//                                                                                sourceItem:bindItem
//                                                                           sourceIndexPath:[tableView indexPathForCell:cell]];
//                                                       }]];
            
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"Array" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [weakSelf insertElementWithType:CTPropertyTypeArray
                                                                                sourceItem:bindItem
                                                                           sourceIndexPath:[tableView indexPathForCell:cell]];
                                                       }]];
            
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"Bool" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [weakSelf insertElementWithType:CTPropertyTypeBool
                                                                                sourceItem:bindItem
                                                                           sourceIndexPath:[tableView indexPathForCell:cell]];
                                                       }]];
            
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"Number" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [weakSelf insertElementWithType:CTPropertyTypeNumber
                                                                                sourceItem:bindItem
                                                                           sourceIndexPath:[tableView indexPathForCell:cell]];
                                                       }]];
            
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
            [self presentViewController:alertCtr animated:YES completion:NULL];
        }
    };
    
    if (bindItem.valueType == CTPropertyTypeArray) {
        cell.arrayAddButtonHandler = ^(CTPropertyCell *cell) {
            [weakSelf insertElementWithType:CTPropertyTypeChild
                                 sourceItem:bindItem
                            sourceIndexPath:[tableView indexPathForCell:cell]];
        };
    }
    
    cell.propertyItem = bindItem;
    return cell;
}

- (void)insertElementWithType:(CTPropertyType)type
                   sourceItem:(CTPropertyItem *)sourceItem
              sourceIndexPath:(NSIndexPath *)indexPath {
    NSInteger targetIndex = indexPath.row + 1;
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:targetIndex inSection:indexPath.section];
    CTPropertyItem *targetItem = [CTPropertyItem new];
    targetItem.valueType = type;
    [self.displayItems insertObject:targetItem atIndex:indexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[targetIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    if (type != CTPropertyTypeChild) {
        [self.rootItems addObject:targetItem];
        return;
    }
    
    if (sourceItem.valueType == CTPropertyTypeArray) {
        [sourceItem addChildItem:targetItem];
    } else if (sourceItem.valueType == CTPropertyTypeChild) {
        [sourceItem.superItem addChildItem:targetItem];
    }
}



- (NSMutableArray *)rootItems {
    if (_rootItems == nil) {
        _rootItems = [NSMutableArray array];
    }
    return _rootItems;
}

- (NSMutableArray *)displayItems {
    if (_displayItems == nil) {
        _displayItems = [NSMutableArray array];
    }
    return _displayItems;
}
@end
