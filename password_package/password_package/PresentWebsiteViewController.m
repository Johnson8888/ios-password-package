//
//  PresentWebsiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/11.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PresentWebsiteViewController.h"
#import "HWTopBarViewController.h"
#import "PPWebsiteModel.h"
#import "PPDataManager.h"
#import <HWPop.h>
#import "Utils.h"

@interface PresentWebsiteViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PresentWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    NSLog(@"self.view = %@",self.view);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.view.userInteractionEnabled = YES;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/// 处理点击空白区域 让页面消失
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.bgView]) {
        return NO;
    }
    return YES;
}

- (IBAction)pressedLaunchButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    TTLog(@"launch");
}
- (IBAction)pressedCopyUserName:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self showPopWithText:@"复制用户名成功!"];
    }];
    TTLog(@"copy user name");
}
- (IBAction)pressedCopyPwdButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self showPopWithText:@"复制密码成功!"];
    }];
    TTLog(@"copy pwd");
}
- (IBAction)pressedViewButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    TTLog(@"view");
}
- (IBAction)pressedEditButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    TTLog(@"edit");
}
- (IBAction)pressedShowPwdButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    TTLog(@"show pwd");
}
- (IBAction)pressedShareButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    TTLog(@"share ");
}
- (IBAction)pressedDeleteButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [Utils alertWithTitle:@"提示" detail:@"删除后不能恢复！确定要删除吗？" callBack:^(NSInteger index) {
        if (index == 0) {
            TTLog(@"确定删除");
            [[PPDataManager sharedInstance] deleteWebsiteWithId:self.websiteModel.aId
                                                     completion:^(BOOL isSuccess) {
                if (isSuccess) {
                    if (self.deleteCallBack) {
                        self.deleteCallBack();
                    }
                } else {
                    TTLog(@"delete pwd error");
                }
            }];
        }
    }];
    
    TTLog(@"delete");
}



/// 显示提示框
/// @param text 提示文字
- (void)showPopWithText:(NSString *)text {
    HWTopBarViewController *topBarVC = [[HWTopBarViewController alloc] initWithText:text];
    HWPopController *popController = [[HWPopController alloc] initWithViewController:topBarVC];
    popController.backgroundAlpha = 0;
    popController.popPosition = HWPopPositionTop;
    popController.popType = HWPopTypeBounceInFromTop;
    popController.dismissType = HWDismissTypeSlideOutToTop;
    [popController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
