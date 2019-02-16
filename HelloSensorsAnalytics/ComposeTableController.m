//
//  ComposeTableController.m
//  HelloSensorsAnalytics
//
//  Created by HeHongling on 2019/2/13.
//  Copyright © 2019 SensorsData. All rights reserved.
//

#import "ComposeTableController.h"

@interface ComposeTableController ()
@property (weak, nonatomic) IBOutlet UILabel *loginIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *sandboxClearLbl;
@property (weak, nonatomic) IBOutlet UILabel *keychainClearLbl;

@end

@implementation ComposeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.loginIdLbl.text = [SensorsAnalyticsSDK sharedInstance].loginId.length? [SensorsAnalyticsSDK sharedInstance].loginId: @"[匿名]";
    self.sandboxClearLbl.text = @"";
    self.keychainClearLbl.text = @"";
}

#pragma mark- EventHandler

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            [self serverURLSetting];
        }
    } else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            [self userLogin];
        }
    } else if (2 == indexPath.section) {
        if (0 == indexPath.row) {
            [self clearSandboxFlag];
        } else if (1 == indexPath.row) {
            [self clearKeychainFlag];
        }
    }
}

- (void)clearSandboxFlag {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HasTrackInstallation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.sandboxClearLbl.text = @"[clean]";
}

- (void)clearKeychainFlag {
    [[SensorsAnalyticsSDK sharedInstance] clearKeychainData];
    self.keychainClearLbl.text = @"[clean]";
}

- (void)userLogin {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户登录"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *field;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"为空则退出登录";
        NSString *curServerURL = [[SensorsAnalyticsSDK sharedInstance] loginId];
        textField.text = curServerURL?:@"[匿名]";
        
        field = textField;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if (field.text.length > 0) {
                                                              [[SensorsAnalyticsSDK sharedInstance] login:field.text];
                                                          } else {
                                                              [[SensorsAnalyticsSDK sharedInstance] logout];
                                                          }
                                                          self.loginIdLbl.text = field.text;
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)serverURLSetting {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"数据接收地址"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *field;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"为空则使用代码中配置 ServerURL";
        NSString *curServerURL = [[SensorsAnalyticsSDK sharedInstance] valueForKey:@"serverURL"];
        textField.text = curServerURL?:@"Not found";
        
        field = textField;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[NSUserDefaults standardUserDefaults] setObject:field.text
                                                                                                    forKey:SAUserDefaultsServerURL];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end
