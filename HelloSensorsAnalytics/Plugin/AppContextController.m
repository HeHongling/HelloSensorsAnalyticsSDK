//
//  AppContextController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/3/15.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "AppContextController.h"
#import "ModuleDataSource.h"
#import <LDNetGetAddress.h>
#import "SensorsUtil.h"

@interface LongPressCopyCell : UITableViewCell

@end

@implementation LongPressCopyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        [ges.view becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:[(LongPressCopyCell *)ges.view contentView].frame inView:ges.view];
        [menu setMenuVisible:YES];
    }
}

- (BOOL)canBecomeFirstResponder {
    NSString *targetStr = self.detailTextLabel.text;
    if (targetStr && targetStr.length > 0 && ![targetStr isEqualToString:@"null"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuControllerWillHide:)
                                                     name:UIMenuControllerWillHideMenuNotification
                                                   object:nil];
        return YES;
    }
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = self.detailTextLabel.text;
}

- (void)menuControllerWillHide:(NSNotification *)aNot {
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface AppContextModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL needAccessory;
@property (nonatomic, assign) SEL selector;
+ (instancetype)contextWithTitle:(NSString *)title subTitle:(NSString *)subTitle selector:(SEL)selector needAccessory:(BOOL)needAccessory;
@end

@implementation AppContextModel
+ (instancetype)contextWithTitle:(NSString *)title subTitle:(NSString *)subTitle selector:(SEL)selector needAccessory:(BOOL)needAccessory {
    AppContextModel *model = [[self alloc] init];
    model.title = title;
    model.subTitle = subTitle;
    model.selector = selector;
    model.needAccessory = needAccessory;
    return model;
}
@end


@interface AppContextController ()<ModuleDataDelegate, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ModuleDataSource *moduleDataSource;
@property (nonatomic, strong) AppContextModel *serverURLModel, *anonymousIdModel, *loginIdModel;
@property (nonatomic, strong) AppContextModel *localIPModel, *internetIPModel, *idfaModel, *idfvModel;
@end

@implementation AppContextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)initData {
    
    self.serverURLModel = [AppContextModel contextWithTitle:@"Server" subTitle:[SensorsUtil sdkServerDesc]?: @"null" selector:@selector(changeServerURL) needAccessory:YES];
    [self.moduleDataSource addCellModel:self.serverURLModel belongModule:@"SDK 信息"];
    
    self.anonymousIdModel = [AppContextModel contextWithTitle:@"匿名" subTitle:[SensorsUtil sdkAnonymousId] selector:@selector(resetAnonymousId) needAccessory:YES];
    [self.moduleDataSource addCellModel:self.anonymousIdModel belongModule:@"SDK 信息"];
    
    self.loginIdModel = [AppContextModel contextWithTitle:@"用户" subTitle:[SensorsUtil sdkLoginId]?: @"null" selector:@selector(loginLogout) needAccessory:YES];
    [self.moduleDataSource addCellModel:self.loginIdModel belongModule:@"SDK 信息"];
    
    AppContextModel *distinctIdModel = [AppContextModel contextWithTitle:@"事件" subTitle:[SensorsUtil sdkDistinctId] selector:NULL needAccessory:NO];
    [self.moduleDataSource addCellModel:distinctIdModel belongModule:@"SDK 信息"];
    
    AppContextModel *deviceIdModel = [AppContextModel contextWithTitle:@"设备" subTitle:[SensorsUtil sdkDeviceId] selector:NULL needAccessory:NO];
    [self.moduleDataSource addCellModel:deviceIdModel belongModule:@"SDK 信息"];
    
    self.idfaModel = [AppContextModel contextWithTitle:@"IDFA" subTitle:[SensorsUtil idfaString] selector:NULL needAccessory:NO];
    [self.moduleDataSource addCellModel:self.idfaModel belongModule:@"应用信息"];
    
    self.idfvModel = [AppContextModel contextWithTitle:@"IDFV" subTitle:[SensorsUtil idfvString] selector:NULL needAccessory:NO];
    [self.moduleDataSource addCellModel:self.idfvModel belongModule:@"应用信息"];
    
    AppContextModel *localIPModel = [AppContextModel contextWithTitle:@"内网" subTitle:@"null" selector:NULL needAccessory:NO];
    [self.moduleDataSource addCellModel:localIPModel belongModule:@"应用信息"];
    [SensorsUtil fetchLocalIPAddressWithCompletion:^(NSString *localIP) {
        localIPModel.subTitle = localIP;
        NSIndexPath *targetIndexPath = [self.moduleDataSource indexPathForCellModel:localIPModel];
        [self.tableView reloadRowsAtIndexPaths:@[targetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    AppContextModel *internetIPModel = [AppContextModel contextWithTitle:@"外网" subTitle:@"null" selector:NULL needAccessory:NO];
    [self.moduleDataSource addCellModel:internetIPModel belongModule:@"应用信息"];
    [SensorsUtil fetchInternetIPAddressWithCompletion:^(NSString *internetIP) {
        if (internetIP && internetIP.length) {
            internetIPModel.subTitle = internetIP;
            NSIndexPath *targetIndexPath = [self.moduleDataSource indexPathForCellModel:internetIPModel];
            [self.tableView reloadRowsAtIndexPaths:@[targetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark-

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LongPressCopyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    AppContextModel *model = [self.moduleDataSource cellModelForIndexPath:indexPath];
    if (!cell) {
        cell = [[LongPressCopyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Menlo" size:13];
    }
    if (model.needAccessory) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0 green:102/255.0 blue:204/255.0 alpha:1.0];
    } else {
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
//    cell.accessoryType = model.needAccessory? UITableViewCellAccessoryDisclosureIndicator: UITableViewCellAccessoryNone;
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    return cell;
}

#pragma mark-

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppContextModel *model = [self.moduleDataSource cellModelForIndexPath:indexPath];
    if ([self respondsToSelector:model.selector]) {
        [self performSelector:model.selector];
    }
}


#pragma mark-



- (void)changeServerURL {
    
}

- (void)resetAnonymousId {
    
}

- (void)loginLogout {
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (ModuleDataSource *)moduleDataSource {
    if (_moduleDataSource == nil) {
        _moduleDataSource = [[ModuleDataSource alloc] initWithDelegate:self];
    }
    return _moduleDataSource;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self.moduleDataSource;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0.01;
    }
    return _tableView;
}

- (AppContextModel *)internetIPModel {
    if (_internetIPModel == nil) {
        _internetIPModel = [AppContextModel contextWithTitle:@"公网 IP" subTitle:nil selector:NULL needAccessory:NO];
    }
    return _internetIPModel;
}


@end
