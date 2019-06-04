//
//  MainViewController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2018/9/5.
//  Copyright © 2018 SensorsData. All rights reserved.
//

#import "MainViewController.h"
#import "PluginManager.h"


@interface MainViewController ()<UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    NSLog(@"1: %@", [LDNetGetAddress deviceIPAdress]);
//    NSLog(@"2: %@", [LDNetGetAddress getGatewayIPAddress]);
////    NSLog(@"3: %@", [LDNetGetAddress outPutDNSServers]);
//    NSLog(@"4: %tu", [LDNetGetAddress getNetworkTypeFromStatusBar]);
//    
    [self setupData];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupData {

    [[PluginManager sharedManager] addPlugin:@"CrossH5ViewController"
                                       title:@"H5 打通"
                                 description:@"App 与 H5 打通"
                                      module:@"SDK 功能"];
    
    [[PluginManager sharedManager] addPlugin:@"InjectJSViewController"
                                       title:@"JS 注入"
                                 description:@"App 内第三方 web 注入神策 SDK"
                                      module:@"SDK 功能"];
    
    [[PluginManager sharedManager] addPlugin:@"DynamicTitleController"
                                       title:@"动态标题"
                                 description:@"解决页面标题动态获取时，采集错误问题"
                                      module:@"解决方案"];
    
    [[PluginManager sharedManager] addPlugin:@"ChannelMatchingController"
                                       title:@"渠道匹配"
                                 description:@"Mock trackInsallation, 测试渠道匹配效果"
                                      module:@"实用功能"];
    
    [[PluginManager sharedManager] addPlugin:@"AppContextController"
                                       title:@"应用信息"
                                 description:@"设备信息、SDK 信息"
                                      module:@"实用功能"];
    
    [[PluginManager sharedManager] addPlugin:@"<#controller#>"
                                       title:@"<#name#>"
                                 description:@"<#description#>"
                                      module:@"<#module#>"];
    
    [[PluginManager sharedManager] addPlugin:@"<#controller#>"
                                       title:@"<#name#>"
                                 description:@"<#description#>"
                                      module:@"<#module#>"];
    
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Plugin *plugin = [[PluginManager sharedManager] pluginForIndexPath:indexPath];
    if (plugin && plugin.relateCls) {
        UIViewController *targetVc = (UIViewController *)[[plugin.relateCls alloc] init];
        if ([targetVc isKindOfClass:[UIViewController class]]) {
            __block BOOL hasPush = NO;
            [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.class == plugin.relateCls) {
                    hasPush = YES;
                    [self.navigationController popToViewController:obj animated:YES];
                }
            }];
            if (!hasPush) {
                [self.navigationController pushViewController:targetVc animated:YES];
            }
        }
    } else {
        [self showAlert:@"找不到相关示例" title:@"ERROR"];
    }
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

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.sectionFooterHeight = 0.01;
        _tableView.sectionHeaderHeight = 38;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = 55;
        _tableView.rowHeight = 55;
        _tableView.dataSource = [PluginManager sharedManager];
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
