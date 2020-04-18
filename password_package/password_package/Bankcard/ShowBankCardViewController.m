//
//  ShowBankCardViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "ShowBankCardViewController.h"
#import "PPBankCardModel.h"

@interface ShowBankCardViewController ()

/// 头部 图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/// 卡片上 cvv 码
@property (weak, nonatomic) IBOutlet UILabel *headerCvvCodeLabel;
/// 卡片上 过期时间
@property (weak, nonatomic) IBOutlet UILabel *headerExpireDate;
/// 卡片上 卡号
@property (weak, nonatomic) IBOutlet UILabel *headerAccountLabel;
/// 备注
@property (weak, nonatomic) IBOutlet UITextView *textView;
/// 类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
/// 过期时间
@property (weak, nonatomic) IBOutlet UILabel *expireDate;
/// cvv码
@property (weak, nonatomic) IBOutlet UILabel *cvvLabel;
/// pin 密码
@property (weak, nonatomic) IBOutlet UILabel *pinLabel;
/// 取现密码
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
/// 账号 label
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


@end

@implementation ShowBankCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    TTLog(@"model = %@",self.bankCardModel);
    
    self.tabBarController.tabBar.hidden = YES;
    self.accountLabel.text = self.bankCardModel.account;
    self.passwordLabel.text = self.bankCardModel.password;
    self.pinLabel.text = self.bankCardModel.pin;
    self.cvvLabel.text = self.bankCardModel.cvvCode;
    self.expireDate.text = self.bankCardModel.expireDate;
    if (self.bankCardModel.type == PP_DEPOSIT_CARD) {
        self.typeLabel.text = @"储蓄卡";
    } else if (self.bankCardModel.type == PP_CREDIT_CARD) {
        self.typeLabel.text = @"信用卡";
    }
    self.textView.text = self.bankCardModel.describe;
    self.headerExpireDate.text = self.bankCardModel.expireDate;
    self.headerAccountLabel.text = self.bankCardModel.account;
    self.headerCvvCodeLabel.text = self.bankCardModel.cvvCode;
    
}




@end
