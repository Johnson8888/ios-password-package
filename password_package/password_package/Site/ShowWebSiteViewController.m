//
//  ShowWebSiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "ShowWebSiteViewController.h"
#import "PPWebsiteModel.h"
#import "Utils.h"

@interface ShowWebSiteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (nonatomic,assign) NSInteger currentSelectedIndex;
@end

@implementation ShowWebSiteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"账号详情";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.currentSelectedIndex = -1;
    
    self.linkLabel.text = self.websiteModel.link;
    self.nameLabel.text = self.websiteModel.title;
    self.accountLabel.text = self.websiteModel.account;
    NSMutableString *place = [NSMutableString string];
    for (int i = 0; i < self.websiteModel.password.length; ++i) {
        place = [NSMutableString stringWithString:[place stringByAppendingString:@"•"]];
    }
    TTLog(@"place = %@",place);
    self.passwordLabel.text = place;
    self.textView.text = self.websiteModel.describe;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:BACK_BUTTON_IMAGE
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(pressedBackButton:)];
    backItem.tintColor = SYSTEM_COLOR;
    self.navigationItem.leftBarButtonItem = backItem;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self becomeFirstResponder]; //设置为第一响应者
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 4) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    BOOL isCopyOnly = YES;
    if (indexPath.row == 3) {
        isCopyOnly = NO;
    }
    self.currentSelectedIndex = indexPath.row;
    [self showMenuViewControllerWithCell:cell isCopyOnly:isCopyOnly];
}


/// 是否只显示 copy
- (void)showMenuViewControllerWithCell:(UITableViewCell *)cell isCopyOnly:(BOOL)isCopyOnly {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *items1 = [[UIMenuItem alloc] initWithTitle:@"复制"
                        action:@selector(copyAction)];
    NSArray *items = @[items1];
    if (isCopyOnly == NO) {
        UIMenuItem *items2 = [[UIMenuItem alloc] initWithTitle:@"显示"
                                 action:@selector(showAction)];
        [menu setTargetRect:CGRectMake(100, 300, 120, 20) inView:self.view];
        items = @[items1,items2];
    }
    menu.menuItems = items;
    menu.menuVisible = YES;
    [menu setTargetRect:cell.frame inView:self.view];
}



/// copy 方法
- (void)copyAction {
    if (self.currentSelectedIndex == -1) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.currentSelectedIndex == 0) {
        pasteboard.string = self.websiteModel.title;
    }
    if (self.currentSelectedIndex == 1) {
        pasteboard.string = self.websiteModel.link;
    }
    if (self.currentSelectedIndex == 2) {
        pasteboard.string = self.websiteModel.account;
    }
    if (self.currentSelectedIndex == 3) {
        pasteboard.string = self.websiteModel.password;
    }
    if (self.currentSelectedIndex == 4) {
        pasteboard.string = self.websiteModel.describe;
    }
    [Utils showPopWithText:@"复制成功!"];
}

///show 方法
- (void)showAction {
    self.passwordLabel.text = self.websiteModel.password;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)pressedBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
