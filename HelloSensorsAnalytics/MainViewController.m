//
//  MainViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2018/9/5.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "MainViewController.h"

NSUInteger numberOfExamplesInSection(NSArray *examples, NSInteger section) {
    NSDictionary *groupInfo = examples[section];
    NSArray *examplesItems = groupInfo[@"exampleItems"];
    return examplesItems.count;
}

NSString *groupNameInSection(NSArray *examples, NSInteger section) {
    NSDictionary *groupInfo = examples[section];
    return groupInfo[@"groupName"];
}

NSDictionary *exampleInfoAtIndexPath(NSArray *examples, NSIndexPath *indexPath) {
    NSDictionary *groupInfo = examples[indexPath.section];
    NSArray *examplesItems = groupInfo[@"exampleItems"];
    NSDictionary *exampleInfo = examplesItems[indexPath.row];
    return exampleInfo;
}

NSString *exampleTitleAtIndexPath(NSArray *examples, NSIndexPath *indexPath) {
    NSString *title = [exampleInfoAtIndexPath(examples, indexPath) objectForKey:@"exampleTitle"];
    return title?: @"";
}

NSString *exampleDescriptionAtIndexPath(NSArray *examples, NSIndexPath *indexPath) {
    NSString *detail = [exampleInfoAtIndexPath(examples, indexPath) objectForKey:@"exampleDetail"];
    return detail?: @"";
}

UIViewController *exampleControllerAtIndexPath(NSArray *examples, NSIndexPath *indexPath) {
    NSString *controllerName = [exampleInfoAtIndexPath(examples, indexPath) objectForKey:@"exampleController"];
    if (!controllerName || controllerName.length < 1) {
        return nil;
    }
    
    Class vcCls = NSClassFromString(controllerName);
    if (!vcCls) {
        return nil;
    }
    UIViewController *vc = [(UIViewController *)[vcCls alloc] init];
    if (!vc || ![vc isKindOfClass:[UIViewController class]]) {
        return nil;
    }
    return vc;
}


@interface MainViewController ()
@property (nonatomic, copy) NSArray *examples;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfExamplesInSection(self.examples, section);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = exampleTitleAtIndexPath(self.examples, indexPath);
    cell.detailTextLabel.text = exampleDescriptionAtIndexPath(self.examples, indexPath);
    return cell;
}

#pragma mark- UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return groupNameInSection(self.examples, section);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = exampleControllerAtIndexPath(self.examples, indexPath);
    if (!vc) {
        [self showAlert:@"暂无相应示例" title:@"错误"];
        return;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- EventHandler

- (void)didTappedRightBarButtonItem:(UIBarButtonItem *)sender {
    
}

#pragma mark- PrivateM

- (void)showAlert:(NSString *)message title:(NSString *)title {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title
                                                                      message:message
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alertCtr addAction:action];
    [self presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark- Accessor

- (NSArray *)examples {
    if (_examples == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SAExamples" ofType:@"plist"];
        NSArray *examples = [[NSArray alloc] initWithContentsOfFile:filePath];
        _examples = examples;
    }
    return _examples;
}

@end
