//
//  SettingViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SettingViewController.h"
#import <iCloudDocumentSync/iCloud.h>
#import "ClearPasteboardViewController.h"
#import "SetAutoLockViewController.h"
#import "SelectThemeViewController.h"
#import <MessageUI/MessageUI.h>
#import "PPBankCardModel.h"
#import "PPWebsiteModel.h"
#import "PPDataManager.h"
#import <ProgressHUD.h>
#import <sys/utsname.h>
#import "DetailCell.h"
#import "SwitchCell.h"
#import "AppConfig.h"
#import "Utils.h"


static NSString *normalCellIdentifier = @"com.password.package.setting.viewcontroller.identifier";
static NSString *switchCellIdentifier = @"com.password.package.setting.switch.cell.idenfitifer";
static NSString *detailCellIdentifier = @"com.password.package.setting.detail.cell.identifier";


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,iCloudDelegate>

/// 是否支持 震动反馈
@property (nonatomic,assign) BOOL isSupportFeedBack;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *titleArray;

@end


@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[iCloud sharedCloud] setDelegate:self];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 44.0f;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:normalCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SwitchCell class]) bundle:nil] forCellReuseIdentifier:switchCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailCell class]) bundle:nil] forCellReuseIdentifier:detailCellIdentifier];

    
    /// 是否支持震动反馈
    self.isSupportFeedBack = [Utils isSupportTapFeedBack];
    if (self.isSupportFeedBack) {
        TTLog(@"支持震动反馈");
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
    
    NSMutableArray *securityArray = [NSMutableArray arrayWithArray:@[@"自动锁屏时间",@"清理剪切板时间"]];
    if ([Utils canUseFaceID]) {
        [securityArray insertObject:@"使用FaceID解锁" atIndex:1];
    }
    if ([Utils canUseTouchID]) {
        [securityArray insertObject:@"使用TouchID解锁" atIndex:1];
    }
    
    
    /// 主题
    /// 1. mainTheme
    NSMutableArray *themeArray = [NSMutableArray arrayWithArray:@[@"当前主题"]];
    
    
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
    
    AppConfig *appConfig = [AppConfig config];
    if (indexPath.section == 0) {
        if (self.isSupportFeedBack) {
            if (indexPath.row == 0) {
                TTLog(@"震动反馈");
                SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
                cell.nameLabel.text = @"震动反馈";
                cell.switchMenu.on = appConfig.isSharkFeedBack;
                return cell;
            }
            if (indexPath.row == 1) {
                TTLog(@"备份到iCloud");
                DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"备份到iCloud";
                cell.detailLabel.text = [self timeDescriptionWithTimeStamp:appConfig.lastUploadTimeStamp];
                return cell;
            }
            if (indexPath.row == 2) {
                TTLog(@"从iCloud恢复");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"从iCloud恢复";
                cell.detailLabel.text = [self timeDescriptionWithTimeStamp:appConfig.lastDownloadTimeStamp];
                return cell;
            }
            if (indexPath.row == 3) {
                TTLog(@"邮件导出");
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                cell.textLabel.text = @"邮件导出";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                TTLog(@"备份到iCloud");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"备份到iCloud";
                cell.detailLabel.text = [self timeDescriptionWithTimeStamp:appConfig.lastUploadTimeStamp];
                return cell ;
            }
            if (indexPath.row == 1) {
                TTLog(@"从iCloud恢复");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"从iCloud恢复";
                cell.detailLabel.text = [self timeDescriptionWithTimeStamp:appConfig.lastDownloadTimeStamp];
                return cell;
            }
            if (indexPath.row == 2) {
                TTLog(@"邮件导出");
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                cell.textLabel.text = @"邮件导出";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
    }
    
    if (indexPath.section == 1) {
        if ([Utils canUseFaceID] || [Utils canUseTouchID]) {
            if (indexPath.row == 0) {
                SwitchCell *cell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
                if ([Utils canUseFaceID]) {
                    cell.nameLabel.text = @"使用FaceID解锁";
                }
                if ([Utils canUseTouchID]) {
                    cell.nameLabel.text = @"使用TouchID解锁";
                }
                cell.switchMenu.on = appConfig.userSystemLock;
                cell.switchCallBack = ^(BOOL isOn) {
                    AppConfig *cc = [AppConfig config];
                    cc.userSystemLock = isOn;
                    [AppConfig saveConfig:cc];
                    [tableView reloadData];
                };
                return cell;
            }
            if (indexPath.row == 1) {
                TTLog(@"自动锁屏时间");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"自动锁屏时间";
                cell.detailLabel.text = [self durationToDescription:appConfig.autoLockDuration];
                return cell;
            }
            if (indexPath.row == 2) {
                TTLog(@"清理剪切板时间");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"清理剪切板时间";
                cell.detailLabel.text = [self durationToDescription:appConfig.clearPasteboardDuration];
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                TTLog(@"自动锁屏时间");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"自动锁屏时间";
                cell.detailLabel.text = [self durationToDescription:appConfig.autoLockDuration];
                return cell;
            }
            if (indexPath.row == 1) {
                TTLog(@"清理剪切板时间");
                DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
                cell.nameLabel.text = @"清理剪切板时间";
                cell.detailLabel.text = [self durationToDescription:appConfig.clearPasteboardDuration];
                return cell;
            }
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TTLog(@"当前主题");
            DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
            cell.nameLabel.text = @"当前主题";
            cell.detailLabel.text = [self themeDescriptionOfThemeValue:appConfig.mainTheme];
            return cell;
        }
    }
    
    if (indexPath.section == 3) {
        if(indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            TTLog(@"意见反馈")
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
            cell.textLabel.text = @"隐私协议";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            TTLog(@"隐私协议");
            return cell;
        }
        if (indexPath.row == 2) {
            DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
            cell.nameLabel.text = @"版本号";
            NSString *shortVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            cell.detailLabel.text = [NSString stringWithFormat:@"v%@",shortVersion];
            TTLog(@"版本号");
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        NSInteger startIndex = 0;
        if ([AppConfig config].userSystemLock) {
            startIndex = 1;
        }
        if (indexPath.row == startIndex) {
            TTLog(@"自动锁屏时间");
            [self setAutoLockDuration];
        }
        if (indexPath.row == startIndex + 1) {
            TTLog(@"清理剪切板时间");
            [self clearPasteboardDuration];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TTLog(@"当前主题");
            [self selectThemeAction];
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


/// 备份到 iCloud
- (void)backUpToiCloud {
    TTLog(@"backUpToiClound");
    BOOL cloudIsAvailable = [[iCloud sharedCloud] checkCloudAvailability];
    if (cloudIsAvailable == NO) {
        [self alertWithTitle:@"提示" detail:@"本设备未登陆iCloud账号" callBack:^(NSInteger index) {}];
        return;
    }
    BOOL cloudContainerIsAvailable = [[iCloud sharedCloud] checkCloudUbiquityContainer];
    if (cloudIsAvailable == NO || cloudContainerIsAvailable == NO) {
        [self alertWithTitle:@"提示" detail:@"当前iCloud连接失败,请检查网络设置并重试!" callBack:^(NSInteger index) {}];
        return;
    }
    
    NSData *contentData = [PPDataManager getDBFileData];
    TTLog(@"contentData.length = %lu",(unsigned long)contentData.length);
    [[iCloud sharedCloud] saveAndCloseDocumentWithName:DB_FILE_NAME
                                           withContent:contentData
                                            completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (error == nil) {
            AppConfig *config = [AppConfig config];
            config.lastUploadTimeStamp = [[NSDate date] timeIntervalSince1970];
            [AppConfig saveConfig:config];
            [self.tableView reloadData];
            [Utils showPopWithText:@"备份数据成功!"];
        } else {
            [Utils showPopWithText:@"备份数据失败,请重试!"];
        }
        TTLog(@"cloudDocument = %@ error = %@",cloudDocument,error.description);
    }];
    
}


/// 从 iCloud恢复
- (void)downFromiCloud {
    BOOL cloudIsAvailable = [[iCloud sharedCloud] checkCloudAvailability];
    if (cloudIsAvailable == NO) {
        [self alertWithTitle:@"提示" detail:@"本设备未登陆iCloud账号" callBack:^(NSInteger index) {}];
        return;
    }
    BOOL cloudContainerIsAvailable = [[iCloud sharedCloud] checkCloudUbiquityContainer];
    if (cloudIsAvailable == NO || cloudContainerIsAvailable == NO) {
        [self alertWithTitle:@"提示" detail:@"当前iCloud连接失败,请检查网络设置并重试!" callBack:^(NSInteger index) {}];
        return;
    }

    [[iCloud sharedCloud] retrieveCloudDocumentWithName:DB_FILE_NAME
                                             completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (!error) {
            NSString *fileName = [cloudDocument.fileURL lastPathComponent];
            NSData *fileData = documentData;
            NSError *retrieveResult = [PPDataManager retrieveToDBWithData:fileData];
            TTLog(@"retrieve success fileName = %@ fileData = %lu retrieveResult = %@",fileName,(unsigned long)fileData.length,retrieveResult);
            if (retrieveResult == nil) {
                [[PPDataManager sharedInstance] reOpenDB];
                /// 发送恢复数据成功的通知
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:PP_RETRIEVE_DATA_SUCCESS_NOTIFICATION
                                                                    object:nil];
                AppConfig *config = [AppConfig config];
                config.lastDownloadTimeStamp = [[NSDate date] timeIntervalSince1970];
                [AppConfig saveConfig:config];
                [self.tableView reloadData];
                [Utils showPopWithText:@"恢复数据成功!"];
            } else {
                [Utils showPopWithText:@"恢复数据失败,请重试!"];
            }
        } else {
            [Utils showPopWithText:@"恢复数据失败,请重试!"];
        }
    }];
    TTLog(@"downFromiClound");
}



/// 自动锁屏的时间
- (void)setAutoLockDuration {
    SetAutoLockViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SetAutoLockViewController class])];
    __weak SettingViewController *weakSelf = self;
    sViewController.saveCallBack = ^{
        [weakSelf.tableView reloadData];
    };
    [self.navigationController presentViewController:sViewController animated:YES completion:^{}];
    TTLog(@"setAutoLockDuration");
}


/// 清理 剪切板的间隔
- (void)clearPasteboardDuration {
    ClearPasteboardViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ClearPasteboardViewController class])];
    __weak SettingViewController *weakSelf = self;
    cViewController.clearCallBack = ^{
        [weakSelf.tableView reloadData];
    };
    [self.navigationController presentViewController:cViewController animated:YES completion:^{}];
    TTLog(@"clearPasteboardDuration");
}


/// 选择主题
- (void)selectThemeAction {
    TTLog(@"selectThemeAction");
    SelectThemeViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SelectThemeViewController class])];
    __weak SettingViewController *weakSelf = self;
    sViewController.selectThemeCallBack = ^{
        [weakSelf.tableView reloadData];
    };
    [self.navigationController presentViewController:sViewController animated:YES completion:^{}];
    
}



/// 隐私服务
- (void)privatePolicy {
    TTLog(@"privatePolicy");
}



/// 邮件导出
- (void)exportWithEmail {
    TTLog(@"exportWithEmail");
    if ([MFMailComposeViewController canSendMail] == NO) {
        [self alertWithTitle:@"提示" detail:@"请先在设备中开启邮件服务" callBack:^(NSInteger index) {}];
        return;
    }
    
    NSArray *siteArray = [[PPDataManager sharedInstance] getAllWebsite];
    NSArray *bankCardArray = [[PPDataManager sharedInstance] getAllBackCard];
    
    NSMutableString *webSiteString = [NSMutableString string];
    for (int i = 0; i < siteArray.count;++i) {
        PPWebsiteModel *model = siteArray[i];
        NSString *tag = [NSString stringWithFormat:@"%d. 名称:%@ 账号:%@ 密码:%@ 地址:%@ 描述:%@ \n",(i+1),model.title,model.account,model.password,model.link,model.describe];
        webSiteString = [NSMutableString stringWithString:[webSiteString stringByAppendingString:tag]];
        TTLog(@"model= %@ tag = %@",model.account,tag);
    }
    
    NSMutableString *backString = [NSMutableString string];
    for (int i = 0; i < bankCardArray.count; ++i) {
        PPBankCardModel *model = bankCardArray[i];
        NSString *type = @"";
        if (model.type == PP_DEPOSIT_CARD) {
            type = @"储蓄卡";
        }
        if (model.type == PP_CREDIT_CARD) {
            type = @"信用卡";
        }
        NSString *bankTag = [NSString stringWithFormat:@"%d. 账号:%@ 密码:%@ pin码:%@ cvv码:%@ 过期时间:%@ 类型:%@ 描述:%@\n",(i+1),model.account,model.password,model.pin,model.cvvCode,model.expireDate,type,model.describe];
        backString = [NSMutableString stringWithString:[backString stringByAppendingString:bankTag]];
        TTLog(@"bankModel = %@ bankTag = %@",model.account,bankTag);
    }
    NSString *exportString = [NSString stringWithFormat:@"网站账户信息: \n%@ \n银行账户信息:\n%@",webSiteString,backString];
    exportString = [exportString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    [mailCompose setMessageBody:exportString isHTML:NO];
    [mailCompose setMailComposeDelegate:self];
    NSString *displayName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *subTitle = [NSString stringWithFormat:@"'%@'导出数据",displayName];
    [mailCompose setSubject:subTitle];
    // 设置邮件代理
    [self presentViewController:mailCompose animated:YES completion:nil];
}


/// 意见反馈
- (void)feedBackAction {
    TTLog(@"feedBackAction");
    //创建可变的地址字符串对象
    if ([MFMailComposeViewController canSendMail] == NO) {
        [self alertWithTitle:@"提示" detail:@"请先在设备中开启邮件服务" callBack:^(NSInteger index) {}];
        return;
    }
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置收件人
    [mailCompose setToRecipients:@[SUPPORT_EMAIL_ADDRESS]];
    // 设置抄送人
    NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *systemVersionString = [[UIDevice currentDevice] systemVersion];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platformString = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    NSString *displayName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *themeString = [NSString stringWithFormat:@"'%@'建议反馈_%@_%@_%@",displayName,versionString,systemVersionString,platformString];
    [mailCompose setSubject:themeString];
    //设置邮件的正文内容
    [mailCompose setMessageBody:@"" isHTML:NO];
    // 如使用HTML格式，则为以下代码
    // [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}


/// 给出Alert提示 用于给用户下载购买过的视频
/// @param title Title
/// @param detail 详细描述
/// @param callBack 点击后的回调
- (void)alertWithTitle:(NSString *)title
                detail:(NSString *)detail
              callBack:(MMPopupItemHandler)callBack {
    NSArray *items =@[MMItemMake(@"确定", MMItemTypeHighlight, callBack)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title
                                 detail:detail
                                  items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    alertView.attachedView = [UIApplication sharedApplication].keyWindow;
    [alertView show];
}


#pragma iCloud

- (void)iCloudAvailabilityDidChangeToState:(BOOL)cloudIsAvailable withUbiquityToken:(id)ubiquityToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    
}

- (void)iCloudDidFinishInitializingWitUbiquityToken:(id)cloudToken
                              withUbiquityContainer:(NSURL *)ubiquityContainer {
    
}
- (void)iCloudFileUpdateDidBegin {
    TTLog(@"iCloudFileUpdateDidBegin");
}


- (void)iCloudFileUpdateDidEnd {
    TTLog(@"iCloudFileUpdateDidEnd");
}

- (void)iCloudFilesDidChange:(NSMutableArray *)files withNewFileNames:(NSMutableArray *)fileNames {
    
}


- (void)iCloudFileConflictBetweenCloudFile:(NSDictionary *)cloudFile andLocalFile:(NSDictionary *)localFile {
    
}


#pragma MFMailConposeViewController Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}




/// 将 时间间隔 转化为 时间描述
/// @param duration 时间间隔
- (NSString *)durationToDescription:(NSInteger)duration {
    ///   默认是 立刻  10秒 30秒 1分钟 5分钟 10分钟
    ///   10秒 30秒 1分钟 2分钟 5分钟 从不
    if (duration == 0) {
        return @"立刻";
    }
    if (duration == PP_NEVER_TO_DO_TAG) {
        return @"从不";
    }
    NSInteger t1 = duration % 60;
    NSInteger t2 = duration / 60;
    if (t1 != 0) {
        return [NSString stringWithFormat:@"%ld秒",(long)duration];
    }
    if (t1 == 0) {
        return [NSString stringWithFormat:@"%ld分钟",(long)t2];
    }
    return @"";
}


/// 将时间戳转换为时间描述
/// @param timestamp 时间戳
- (NSString *)timeDescriptionWithTimeStamp:(NSInteger)timestamp {
    
    NSInteger currentTimeStamp = [[NSDate new] timeIntervalSince1970];
    NSInteger duration = currentTimeStamp - timestamp;
    if (duration < 60) {
        return @"刚刚";
    }
    if (duration > 60 && duration < 120) {
        return @"1分钟以前";
    }
    if (duration > 120 && duration < 300) {
        return @"2分钟以前";
    }
    if (duration > 300 && duration < 600) {
        return @"5分钟以前";
    }
    if (duration > 600 && duration < 60 * 30) {
        return @"10分钟以前";
    }
    if (duration > 60 * 30 && duration < 60 * 60) {
        return @"30分钟以前";
    }
    if (duration > 60 * 60 && duration < 60 * 60 * 2) {
        return @"1小时前";
    }
    if (currentTimeStamp == duration) {
        return @"从未";
    }
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
   //设定时间格式,这里可以设置成自己需要的格式
       [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}



/// 有 theme主题返回主题描述
/// @param theme 主题的值
- (NSString *)themeDescriptionOfThemeValue:(PPTheme)theme {
    switch (theme) {
        case PP_THEME_WHITE:
            return @"白色";
            break;
        case PP_THEME_RED:
            return @"红色";
            break;
        case PP_THEME_BLUE:
            return @"蓝色";
            break;
        case PP_THEME_GREEN:
            return @"绿色";
            break;
        case PP_THEME_PURPLE:
            return @"紫色";
            break;
        case PP_THEME_BLACK:
            return @"暗黑";
            break;
        default:
            break;
    }
    return @"默认";
}


@end
