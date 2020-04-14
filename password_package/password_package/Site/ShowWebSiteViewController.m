//
//  ShowWebSiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "ShowWebSiteViewController.h"
#import "PPWebsiteModel.h"

@interface ShowWebSiteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation ShowWebSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.linkLabel.text = self.websiteModel.link;
    self.nameLabel.text = self.websiteModel.title;
    self.accountLabel.text = self.websiteModel.account;
    NSMutableString *place = [NSMutableString string];
    for (int i = 0; i < self.websiteModel.password.length; ++i) {
        place = [NSMutableString stringWithString:[place stringByAppendingString:@"•"]];
    }
    self.passwordLabel.text = place;
    self.textView.text = self.websiteModel.describe;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self becomeFirstResponder]; //设置为第一响应者
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL isCopyOnly = YES;
    if (indexPath.row == 3) {
        isCopyOnly = NO;
    }
    [self showMenuViewControllerWithCell:cell isCopyOnly:isCopyOnly];
}


/// 是否只显示 copy
- (void)showMenuViewControllerWithCell:(UITableViewCell *)cell isCopyOnly:(BOOL)isCopyOnly{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *items1 = [[UIMenuItem alloc] initWithTitle:@"复制"
                        action:@selector(copyAction)];
    NSArray *items = @[items1];
    if (isCopyOnly) {
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
    
}

///show 方法
- (void)showAction {
    
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
