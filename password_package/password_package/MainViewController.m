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
#import "InputCartViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) CSYGroupButtonView *groupButton;
@end

@implementation MainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PP_MAIN_REFRESH_DATA_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
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
    
    self.tableView.rowHeight = 64.0f;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    NSArray *arrayLeft = @[@"",@"",@""];
    //相应数组
    self.groupButton = [[CSYGroupButtonView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 65, self.view.bounds.size.height - 100 - 45, 45, 45) mainButtonTitle:@"" selectedTitle:@"" otherButtonsTitle:arrayLeft];
    
    __weak __block MainViewController *weakSelf = self;
    self.groupButton.ButtonClickBlock = ^(UIButton *btn) {
        if (btn.tag == 1) {
            [weakSelf showCreatePasswordViewController];
        }
        if (btn.tag == 2) {
            [weakSelf showSelectedItemViewController];
        }
        if (btn.tag == 3) {
            [weakSelf showCreateBankCardViewController];
        }
    };
    [self.view addSubview:self.groupButton];
    
    [self refreshData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemViewCell class]) bundle:nil] forCellReuseIdentifier:@"com.main.view.controller.search.item.cell"];
    
    //不能删除
    /*
    NSString *lastPwd = [WUGesturesUnlockViewController gesturesPassword];
    /// 如果没有密码 就创建密码
    TTLog(@"lastPwd == %@",lastPwd);
    if (lastPwd == nil || lastPwd.length == 0) {
        TTLog(@"create pwd");
        WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
        CreatePwdCompletion completion = ^{
            NSString *detail = @"";
            BOOL isTouchID = [Utils canUseTouchID];
            BOOL isFaceID = [Utils canUseFaceID];
            if (isTouchID) {
                detail = @"TouchID";
            }
            if (isFaceID) {
                detail = @"FaceID";
            }
            if (detail.length == 0) {
                return;
            }
            NSString *dd = [NSString stringWithFormat:@"下次会默认使用%@解锁。",detail];
            [Utils configmAlertWithTitle:@"提示" detail:dd callBack:^(NSInteger index) {}];
        };
        vc.completion = completion;
    } else {
        WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }
     */
}








/// 刷新数据
- (void)refreshData {
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    NSMutableArray *array = [[PPDataManager sharedInstance] getAllWebsite];
    self.dataArray = array.mutableCopy;
    [self.tableView reloadData];
    if (self.dataArray.count == 0) {
        [self showEmptyMessageView];
    } else {
        [self hiddenEmptyMessageView];
    }
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


/// 跳转到 createBankCard View Controller
- (void)showCreateBankCardViewController {
    InputCartViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputCartViewController class])];
    inputViewController.finishCallBack = ^{
        self.tabBarController.selectedIndex = 1;
    };
    [self presentViewController:inputViewController animated:YES completion:nil];
}


/// 添加
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



/// 空白页面显示
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudView.superview bringSubviewToFront:self.groupButton];
        });
    }
}

/// 隐藏空白按钮
- (void)hiddenEmptyMessageView {
    UIView *hudView = [self.view viewWithTag:999];
    if (hudView) {
        [hudView removeFromSuperview];
    }
}



@end
