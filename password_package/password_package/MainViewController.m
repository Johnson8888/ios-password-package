//
//  ViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "MainViewController.h"
#if __has_include(<CYLTabBarController/CYLTabBarController.h>)
#import <CYLTabBarController/CYLTabBarController.h>
#else
#import "CYLTabBarController.h"
#endif
#import <Masonry.h>
#import "Utils.h"
#import <JHUD/JHUD.h>
#import <ProgressHUD.h>
#import "PPWebsiteModel.h"
#import "PPDataManager.h"
#import "PPPasswordCreator.h"
#import "LoginViewController.h"
#import "CSYGroupButtonView.h"
#import "SearchItemViewCell.h"
#import "SearchItemViewController.h"
#import "CreatePasswordViewController.h"
#import "WUGesturesUnlockViewController.h"
#import "PresentWebsiteViewController.h"
#import "ShowWebSiteViewController.h"
#import "InputWebsiteViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PP_MAIN_REFRESH_DATA_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:PP_MAIN_REFRESH_DATA_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:PP_RETRIEVE_DATA_SUCCESS_NOTIFICATION
                                               object:nil];
//    [self showEmptyMessageView];
    
    self.tableView.rowHeight = 64.0f;
    self.tableView.tableFooterView = [[UIView alloc] init];
    NSArray *arrayLeft = @[@"按钮1",@"按钮2",@"按钮3"];
    //相应数组
    CSYGroupButtonView *groupButton = [[CSYGroupButtonView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 85, self.view.bounds.size.height - 100 - 65, 65, 65) mainButtonTitle:@"添加" selectedTitle:@"添加" otherButtonsTitle:arrayLeft];
    groupButton.ButtonClickBlock = ^(UIButton *btn) {
        NSLog(@"%@ tag=%ld",btn.titleLabel.text,(long)btn.tag);
        if (btn.tag == 1) {
            [self showCreatePasswordViewController];
        }
        if (btn.tag == 2) {
            [self showSelectedItemViewController];
        }
    };
    [self.view addSubview:groupButton];
    TTLog(@"view did load");
    [self refreshData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemViewCell class]) bundle:nil] forCellReuseIdentifier:@"com.main.view.controller.search.item.cell"];
    
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([WUGesturesUnlockViewController gesturesPassword].length > 0) {
            WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
            [self presentViewController:vc animated:YES completion:nil];
        }
    });
    
//    [self showUseSystemLockAlert];
    
}



/// 弹出适用系统锁定功能
- (void)showUseSystemLockAlert {
    if ([Utils canUseTouchID]) {
        TTLog(@"can use TouchID");
        [Utils alertWithTitle:@"提示"
                       detail:@"您可以设置指纹锁,解锁更方便快捷"
                     callBack:^(NSInteger index) {
            if (index == 1) {
                TTLog(@"use");
                [self verifyTouchID];
            }
        }];

    }
    if ([Utils canUseFaceID]) {
        TTLog(@"can use FaceID");
    }
}



- (void)verifyTouchID {
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"验证手机指纹"
                      reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"TouchID 验证成功");
            });
        }else if(error){
            
            switch (error.code) {
                case LAErrorAuthenticationFailed:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 验证失败");
                    });
                    break;
                }
                case LAErrorUserCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被用户手动取消");
                    });
                }
                    break;
                case LAErrorUserFallback:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"用户不使用TouchID,选择手动输入密码");
                        
                        
                    });
                }
                    break;
                case LAErrorSystemCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                    });
                }
                    break;
                case LAErrorPasscodeNotSet:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                    });
                }
                    break;
                case LAErrorBiometryNotEnrolled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                    });
                }
                    break;
                case LAErrorBiometryNotAvailable:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无效");
                    });
                }
                    break;
                case LAErrorBiometryLockout:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                    });
                }
                    break;
                case LAErrorAppCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                    });
                }
                    break;
                case LAErrorInvalidContext:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                    });
                }
                    break;
                default:
                    break;
            }
        }
    }];


}






/// 刷新数据
- (void)refreshData {
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    NSMutableArray *array = [[PPDataManager sharedInstance] getAllWebsite];
    self.dataArray = array.mutableCopy;
    [self.tableView reloadData];
//    TTLog(@"refreshData = %@",self.dataArray);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchItemViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"com.main.view.controller.search.item.cell"];
    PPWebsiteModel *model = self.dataArray[indexPath.row];
    cell.dataModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
//    UIImpactFeedbackStyleLight,
//    UIImpactFeedbackStyleMedium,
//    UIImpactFeedbackStyleHeavy,
//    [feedBackGenertor impactOccurred];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PresentWebsiteViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PresentWebsiteViewController class])];
    
    __block  __weak MainViewController *weakSelf = self;
    PPWebsiteModel *dataModel = self.dataArray[indexPath.row];
    sViewController.websiteModel = dataModel;
    /// 删除回调
    sViewController.deleteCallBack = ^{
        [weakSelf refreshData];
    };
    /// 展示时候的回调
    sViewController.viewCallBack = ^(PPWebsiteModel *model) {
        [weakSelf showViewSiteViewControllerWithModel:model];
    };
    /// 需要修改时候的回调
    sViewController.editCallBack = ^(PPWebsiteModel *model) {
        [weakSelf showEditViewControllerWithModel:model];
    };
    /// 需要分享时候的回调
    sViewController.shareCallBack = ^(PPWebsiteModel *model) {
        [weakSelf shareActionWithModel:model];
    };
    sViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:sViewController animated:YES completion:nil];
}



- (void)showSelectedItemViewController {
    SearchItemViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SearchItemViewController class])];
    sViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:sViewController animated:YES completion:nil];
}

- (void)showViewSiteViewControllerWithModel:(PPWebsiteModel *)model {
    ShowWebSiteViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ShowWebSiteViewController class])];
    sViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    sViewController.websiteModel = model;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:sViewController animated:YES];
}

- (void)showCreatePasswordViewController {
    CreatePasswordViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreatePasswordViewController class])];
    cViewController.alertText = @"复制成功!";
    cViewController.buttonText = @"复制";
    cViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:cViewController animated:YES completion:nil];
}

- (void)showEditViewControllerWithModel:(PPWebsiteModel *)model {
    InputWebsiteViewController *inputWebsiteViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputWebsiteViewController class])];
    inputWebsiteViewController.websiteModel = model;
    [self.navigationController presentViewController:inputWebsiteViewController animated:YES completion:^{}];
}

- (IBAction)pressedAddBarButton:(UIBarButtonItem *)sender {
    [self showSelectedItemViewController];
}




/// 分享功能
- (void)shareActionWithModel:(PPWebsiteModel *)model {
    NSString *shareText = [NSString stringWithFormat:@"账号: %@ \n密码: %@",model.account,model.password];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, nil];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"%@",activityType);
        if (completed) {
            [ProgressHUD showSuccess:@"分享成功"];
        } else {
            [ProgressHUD showError:@"分享失败,请重试!"];
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    vc.completionWithItemsHandler = myBlock;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}



- (void)showEmptyMessageView {
    UIView *hudView = [self.view viewWithTag:999];
    if (hudView == nil) {
        JHUD *hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
        hudView.tag = 999;
        hudView.indicatorViewSize = CGSizeMake(138, 110);
        hudView.messageLabel.text = @"";
        hudView.customImage = [UIImage imageNamed:@"ic_empty_box"];
        [hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        hudView.refreshButton.hidden = YES;
    }
}


@end
