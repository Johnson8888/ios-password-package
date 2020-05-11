//
//  ShowBankCardViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "ShowBankCardViewController.h"
#import "PPBankCardModel.h"
#import <SDWebImage.h>
#import "Utils.h"

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
/// 当前选中的cell

@property (nonatomic,assign) NSInteger currentSelectedIndex;

@end

@implementation ShowBankCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.currentSelectedIndex = -1;
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 83, 24)];
    [titleView sd_setImageWithURL:[NSURL URLWithString:self.bankCardModel.logoImageUrl]];
    self.navigationItem.titleView = titleView;
    TTLog(@"model = %@",self.bankCardModel);
    
    self.tabBarController.tabBar.hidden = YES;
    self.accountLabel.text = self.bankCardModel.account;
        
    self.passwordLabel.text = [self getDotStingWithString:self.bankCardModel.password];
    self.pinLabel.text = [self getDotStingWithString:self.bankCardModel.pin];
    self.cvvLabel.text = [self getDotStingWithString:self.bankCardModel.cvvCode];
    
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        [self becomeFirstResponder]; //设置为第一响应者
        self.currentSelectedIndex = indexPath.row;
        [self showMenuViewControllerWithCell:[tableView cellForRowAtIndexPath:indexPath]];
    }
}







/// 是否只显示 copy
- (void)showMenuViewControllerWithCell:(UITableViewCell *)cell {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *items1 = [[UIMenuItem alloc] initWithTitle:@"复制"
                        action:@selector(copyAction)];
    NSArray *items = @[items1];
    UIMenuItem *items2 = [[UIMenuItem alloc] initWithTitle:@"显示"
                             action:@selector(showAction)];
    [menu setTargetRect:CGRectMake(100, 300, 120, 20) inView:self.view];
    items = @[items1,items2];

    menu.menuItems = items;
    menu.menuVisible = YES;
    [menu setTargetRect:cell.frame inView:self.view];
}



- (void)copyAction {
    if (self.currentSelectedIndex == -1) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.currentSelectedIndex == 1) {
        pasteboard.string = self.bankCardModel.password;
    }
    if (self.currentSelectedIndex == 2) {
        pasteboard.string = self.bankCardModel.pin;
    }
    if (self.currentSelectedIndex == 3) {
        pasteboard.string = self.bankCardModel.cvvCode;
    }
    [Utils showPopWithText:@"复制成功!"];
}


- (void)showAction {
    if (self.currentSelectedIndex == -1) {
        return;
    }
    if (self.currentSelectedIndex == 1) {
        self.passwordLabel.text = self.bankCardModel.password;
    }
    if (self.currentSelectedIndex == 2) {
        self.pinLabel.text = self.bankCardModel.pin;
    }
    if (self.currentSelectedIndex == 3) {
        self.cvvLabel.text = self.bankCardModel.cvvCode;
    }
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (NSString *)getDotStingWithString:(NSString *)string {
    NSMutableString *place = [NSMutableString string];
    for (int i = 0; i < string.length; ++i) {
        place = [NSMutableString stringWithString:[place stringByAppendingString:@"•"]];
    }
    if (place.length == 0) {
        return @"";
    }
    return place;
}


@end
