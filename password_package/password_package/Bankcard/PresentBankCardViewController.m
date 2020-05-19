//
//  PresentBankCardViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/16.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PresentBankCardViewController.h"
#import "PPBankCardModel.h"
#import "PPDataManager.h"
#import <SDWebImage.h>
#import "AppDelegate.h"
#import <Masonry.h>
#import "AppConfig.h"
#import "Utils.h"

@interface PresentBankCardViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tmpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconImageViews;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageVeiw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraints;

@end

@implementation PresentBankCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    for (UIImageView *imageView in self.iconImageViews) {
        imageView.lee_theme
        .LeeAddTintColor(kThemeDefault, SYSTEM_COLOR)
        .LeeAddTintColor(kThemeRed, LEEColorHex(kColorThemeRed))
        .LeeAddTintColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
        .LeeAddTintColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
        .LeeAddTintColor(kThemePurple, LEEColorHex(kColorThemePurple))
        .LeeAddTintColor(kThemeYellow, LEEColorHex(kColorThemeYellow));
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.view.userInteractionEnabled = YES;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    [self.logoImageVeiw sd_setImageWithURL:[NSURL URLWithString:self.bankCardModel.logoImageUrl]];
        
}

- (IBAction)pressedEditButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
    if (self.editBankCardCallBack) {
        self.editBankCardCallBack(self.bankCardModel);
    }
}

- (IBAction)pressedViewButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
    if (self.viewBankCardCallBack) {
        self.viewBankCardCallBack(self.bankCardModel);
    }
}

- (IBAction)pressedDeleteButton:(id)sender {
    
    if ([AppConfig config].isSharkFeedBack) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [Utils alertWithTitle:@"提示" detail:@"删除后不能恢复！确定要删除吗？" callBack:^(NSInteger index) {
        if (index == 1) {
            TTLog(@"确定删除");
            BOOL result = [[PPDataManager sharedInstance] deleteBackCardWithId:self.bankCardModel.aId];
            if (result) {
                if (self.deleteCallBack) {
                    self.deleteCallBack();
                }
            } else {
                TTLog(@"delete pwd error");
            }
        }
    }];
}


/// 点击回收功能
- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:NO completion:^{
        
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



/// 显示当前PlayerView 页面
- (void)show {
//    return;
    
//    [UIView animateWithDuration:5.25 animations:^{
//        self.bottomConstraint.constant = 0.0f;
//        [self.bgView layoutIfNeeded];
//    }];
    
  
//    TTLog(@"default.constant = %f",self.bottomConstraint.constant);
//    [UIView animateWithDuration:10.0f
//                     animations:^{
        
//        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(100);
//            make.center.mas_equalTo(self.view);
//        }];
        
//        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(100);
//            make.center.mas_equalTo(self.view);
//        }];
        
//        self.bottomConstraint.constant = -100.0f;
//        [self.bgView layoutIfNeeded];
//        [self.tmpView layoutIfNeeded];
//        [self.bgView.superview layoutIfNeeded];
//
//    } completion:^(BOOL finished) {
//        TTLog(@"finished");
//    }];
    
}

@end
