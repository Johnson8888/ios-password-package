//
//  SettingViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SettingViewController.h"
#import "Utils.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

/// 是否支持 震动反馈
@property (nonatomic,assign) BOOL isSupportFeedBack;
/// 是否支持 DarkMode
@property (nonatomic,assign) BOOL isSupportDarkMode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *titleArray;

@end


@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 44.0f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"com.password.package.setting.viewcontroller.identifier"];
    
    
    /// 是否支持震动反馈
    self.isSupportFeedBack = [Utils isSupportTapFeedBack];
    if (self.isSupportFeedBack) {
        TTLog(@"支持震动反馈");
    }
    
    self.isSupportDarkMode = NO;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 13.0) {
        self.isSupportDarkMode = YES;
    }
    
    /// 通用
    /// 1.是否允许 震动反馈(options)
    /// 2.备份到iCloud
    /// 3.从iCloud恢复
    /// 4.邮件导出
    
    NSMutableArray *generalArray = [NSMutableArray arrayWithArray:@[@"按键震动反馈",@"备份到iCloud",@"从iCloud恢复",@"邮件导出"]];
    if (self.isSupportFeedBack == NO) {
        [generalArray removeObjectAtIndex:0];
    }
    
    /// 安全
    /// 1.pinCode
    /// 2.useSystemLock (options)
    /// 3.autoLockDuration
    /// 4.clearPasteboardDuration
    NSArray *securityArray = @[@"使用密码",@"使用FaceID或TouchID",@"自动锁定时间",@"清理剪切板时间"];
    
    /// 主题
    /// 1. mainTheme
    /// 2. 暗黑模式 (options )
    NSMutableArray *themeArray = [NSMutableArray arrayWithArray:@[@"当前主题",@"是否跟随系统主题设置"]];
    if (self.isSupportDarkMode == NO) {
        [themeArray removeLastObject];
    }
    
    /// 支持
    /// 1.意见反馈
    /// 2.隐私协议
    /// 3.版本号
    NSArray *supportArray = @[@"意见反馈",@"隐私协议",@"版本号"];
    
    self.dataArray = @[generalArray,securityArray,themeArray,supportArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.password.package.setting.viewcontroller.identifier"];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.tabBarController.tabBar.hidden = YES;
    if (indexPath.section == 0) {
        if (self.isSupportFeedBack) {
            if (indexPath.row == 0) {
                TTLog(@"震动反馈");
            }
            if (indexPath.row == 1) {
                TTLog(@"备份到iCloud");
                [self backUpToiCloud];
            }
            if (indexPath.row == 2) {
                TTLog(@"从iCloud恢复");
                [self downFromiCloud];
            }
            if (indexPath.row == 3) {
                TTLog(@"邮件导出");
                [self exportWithEmail];
            }
        } else {
            if (indexPath.row == 0) {
                TTLog(@"备份到iCloud");
                [self backUpToiCloud];
            }
            if (indexPath.row == 1) {
                TTLog(@"从iCloud恢复");
                [self downFromiCloud];
            }
            if (indexPath.row == 2) {
                TTLog(@"邮件导出");
                [self exportWithEmail];
            }
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            TTLog(@"自动锁屏时间");
            [self setAutoLockDuration];
        }
        if (indexPath.row == 3) {
            TTLog(@"清理剪切板时间");
            [self clearPasteboardDuration];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TTLog(@"设置当前主题");
            [self selectThemeAction];
        }
        if (indexPath.row == 1) {
            TTLog(@"是否跟随系统主题设置");
        }
    }
    
    if (indexPath.section == 3) {
        if(indexPath.row == 0) {
            TTLog(@"意见反馈")
            [self feedBackAction];
        }
        if (indexPath.row == 1) {
            TTLog(@"隐私协议");
            [self privatePolicy];
        }
        if (indexPath.row == 2) {
            TTLog(@"版本号");
        }
    }
}


- (void)backUpToiCloud {
    TTLog(@"backUpToiClound");
}

- (void)downFromiCloud {
    TTLog(@"downFromiClound");
}

- (void)exportWithEmail {
    TTLog(@"exportWithEmail");
}

- (void)setAutoLockDuration {
    TTLog(@"setAutoLockDuration");
}

- (void)clearPasteboardDuration {
    TTLog(@"clearPasteboardDuration");
}


- (void)selectThemeAction {
    TTLog(@"selectThemeAction");
}


- (void)feedBackAction {
    TTLog(@"feedBackAction");
}

- (void)privatePolicy {
    TTLog(@"privatePolicy");
}


@end
