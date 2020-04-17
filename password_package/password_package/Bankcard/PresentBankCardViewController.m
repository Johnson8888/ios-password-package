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
#import "Utils.h"

@interface PresentBankCardViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PresentBankCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // view
    // edit
    // delete
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.view.userInteractionEnabled = YES;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
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
    [self dismissViewControllerAnimated:YES completion:^{}];
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
