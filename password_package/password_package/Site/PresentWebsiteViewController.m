//
//  PresentWebsiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/11.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PresentWebsiteViewController.h"
#import <MMPopupView/MMPopupItem.h>
#import "SearchItemViewController.h"
#import "PPWebsiteModel.h"
#import "PPDataManager.h"
#import "Utils.h"
#import "AppConfig.h"

@interface PresentWebsiteViewController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconImageViews;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *launchViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;

@end

@implementation PresentWebsiteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.view.userInteractionEnabled = YES;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    self.nameLabel.text = [SearchItemViewController descriptionWithName:self.websiteModel.title];
    if (self.websiteModel.iconImg) {
        self.iconImageView.image = [UIImage imageWithData:self.websiteModel.iconImg];
    }
    
    for (UIImageView *imageView in self.iconImageViews) {
        imageView.lee_theme
        .LeeAddTintColor(kThemeDefault, SYSTEM_COLOR)
        .LeeAddTintColor(kThemeRed, LEEColorHex(kColorThemeRed))
        .LeeAddTintColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
        .LeeAddTintColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
        .LeeAddTintColor(kThemePurple, LEEColorHex(kColorThemePurple))
        .LeeAddTintColor(kThemeYellow, LEEColorHex(kColorThemeYellow));
    }
    
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:NO completion:^{}];
}


- (IBAction)pressedLaunchButton:(id)sender {
    
    TTLog(@"使用打开App的方式");
    NSString *jumpScheme = [self schemeOfTitle:self.websiteModel.title];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if (jumpScheme && jumpScheme.length > 0) {
        NSURL *openURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",jumpScheme]];
        if ([[UIApplication sharedApplication] canOpenURL:openURL]) {
            [[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:^(BOOL success) {
            }];
            return;
        }
    }
    
    if (self.websiteModel.link.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.websiteModel.link] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        TTLog(@"show alert");
    }
    
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
    inputView.textColor = [UIColor blackColor];
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
    if ([AppConfig config].isSharkFeedBack) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [feedBackGenertor impactOccurred];
    }
    
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




/// 将Title 转换我 scheme
- (NSString * _Nullable)schemeOfTitle:(NSString *)title {
    /*
    taobao,
       neteasemail,
       BaiduSSO,
       baiduyun,
       doubanradio,
       zhihu,
       "openapp.jdMobile",
       xiami,
       googlechrome,
       evernote,
       youdaonote,
       "cn.12306",
       dingtalk,
       alipay,
       weixin,
       mqq,
       weibo,
       brave,
       firefox,
       havecake,
       dolphin,
       "firefox-focus",
       googlechrome,
       "microsoft-edge-http",
       "opera-http",
       puffin,
       ucbrowser,
       "yandexbrowser-open-url",
       ddgLaunch,
       ddgQuickLink,
       alohabrowser,
       "touch-url",
       cakebrowser
    */
    
    //    NSArray *inCommonUseArray = @[@"Wechat",@"QQ",@"Taobao",@"Zhihu",@"Baidu",@"Weibo",@"163",@"Github",@"jingdong",@"Yinxiang",@"douban",@"12306",@"zhifubao"];

    if ([title isEqualToString:@"Wechat"]) {
        return @"weixin";
    }
    if ([title isEqualToString:@"QQ"]) {
        return @"mqq";
    }
    if ([title isEqualToString:@"Taobao"]) {
        return @"taobao";
    }
    if ([title isEqualToString:@"Zhihu"]) {
        return @"zhihu";
    }
    if ([title isEqualToString:@"Baidu"]) {
        return @"BaiduSSO";
    }
    if ([title isEqualToString:@"Weibo"]) {
        return @"weibo";
    }
    if ([title isEqualToString:@"163"]) {
        return @"neteasemail";
    }
    if ([title isEqualToString:@"jingdong"]) {
        return @"openApp.jdMobile";
    }
    if ([title isEqualToString:@"Yinxiang"]) {
        return @"evernote";
    }
    if ([title isEqualToString:@"douban"]) {
        return @"doubanradio";
    }
    if ([title isEqualToString:@"12306"]) {
        return @"cn.12306";
    }
    return nil;
}



@end
