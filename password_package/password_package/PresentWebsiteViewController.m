//
//  PresentWebsiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/11.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PresentWebsiteViewController.h"

@interface PresentWebsiteViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
