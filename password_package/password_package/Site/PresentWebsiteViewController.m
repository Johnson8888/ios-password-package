//
//  PresentWebsiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/11.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PresentWebsiteViewController.h"
#import <MMPopupView/MMPopupItem.h>
#import "PPWebsiteModel.h"
#import "PPDataManager.h"
#import "Utils.h"


@interface PresentWebsiteViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *launchViewHeightConstraints;

@end

@implementation PresentWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.view.userInteractionEnabled = YES;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    self.nameLabel.text = self.websiteModel.title;
    if (self.websiteModel.iconImg) {
        self.iconImageView.image = [UIImage imageWithData:self.websiteModel.iconImg];
    }
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)pressedLaunchButton:(id)sender {
    TTLog(@"使用打开App的方式");
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.websiteModel.link.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.websiteModel.link] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        TTLog(@"show alert");
    }
    TTLog(@"launch");
}


- (IBAction)pressedCopyUserName:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.websiteModel.account;
    [self dismissViewControllerAnimated:NO completion:^{
        [Utils showPopWithText:@"复制用户名成功!"];
    }];
    TTLog(@"copy user name");
}

- (IBAction)pressedCopyPwdButton:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.websiteModel.password;
    [self dismissViewControllerAnimated:NO completion:^{
        [Utils showPopWithText:@"复制密码成功!"];
    }];
    TTLog(@"copy pwd");
}


- (IBAction)pressedViewButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.viewCallBack) {
        self.viewCallBack(self.websiteModel);
    }
    TTLog(@"view");
}

- (IBAction)pressedEditButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.editCallBack) {
        self.editCallBack(self.websiteModel);
    }
    TTLog(@"edit");
}

- (IBAction)pressedShowPwdButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"提示" detail:@"当前的密码是:" placeholder:@"" handler:^(NSString *text) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.websiteModel.password;
        [Utils showPopWithText:@"复制密码成功!"];
    }];
    UITextField *inputView = [alertView performSelector:@selector(inputView)];
    inputView.enabled = NO;
    inputView.text = self.websiteModel.password;
    UIView *buttonView = [alertView performSelector:@selector(buttonView)];
    for (UIButton *subView in buttonView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            if (btn.tag == 0) {
                [btn setTitle:@"确定" forState:UIControlStateNormal];
            }
            if (btn.tag == 1) {
                [btn setTitle:@"复制" forState:UIControlStateNormal];
            }
        }
    }
    alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    alertView.attachedView = [UIApplication sharedApplication].keyWindow;
    [alertView show];
    TTLog(@"show pwd");
}

- (IBAction)pressedShareButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.shareCallBack) {
        self.shareCallBack(self.websiteModel);
    }
    TTLog(@"share ");
}


- (IBAction)pressedDeleteButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [Utils alertWithTitle:@"提示" detail:@"删除后不能恢复！确定要删除吗？" callBack:^(NSInteger index) {
        if (index == 1) {
            TTLog(@"确定删除");
            BOOL result = [[PPDataManager sharedInstance] deleteWebsiteWithId:self.websiteModel.aId];
            if (result) {
                if (self.deleteCallBack) {
                    self.deleteCallBack();
                }
            } else {
                TTLog(@"delete pwd error");
            }
        }
    }];
    
    TTLog(@"delete");
}



/// 处理点击空白区域 让页面消失
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.bgView]) {
        return NO;
    }
    return YES;
}




@end
