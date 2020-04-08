//
//  ViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "MainViewController.h"
#import "PPPasswordCreator.h"
#import "LoginViewController.h"
#import "SearchItemViewController.h"
#import "CreatePasswordViewController.h"
#import "CSYGroupButtonView.h"
#import <Masonry.h>
#import <JHUD/JHUD.h>

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self showEmptyMessageView];
    
    
    NSArray *arrayLeft = @[@"按钮1",@"按钮2",@"按钮3"];
    //相应数组
    CSYGroupButtonView *groupButton = [[CSYGroupButtonView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 85, self.view.bounds.size.height - 100 - 65, 65, 65) mainButtonTitle:@"添加" selectedTitle:@"添加" otherButtonsTitle:arrayLeft];
    groupButton.ButtonClickBlock = ^(UIButton *btn) {
        NSLog(@"%@ tag=%ld",btn.titleLabel.text,(long)btn.tag);
        if (btn.tag == 1) {
            [self showCreatePasswordViewController];
        }
        if (btn.tag == 2) {
            [self showSelectedItemViewController];
        }
        
    };
    [self.view addSubview:groupButton];
    TTLog(@"view did load");
}


- (void)showSelectedItemViewController {
    SearchItemViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SearchItemViewController class])];
    sViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:sViewController animated:YES completion:nil];
}


- (void)showCreatePasswordViewController {
    CreatePasswordViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreatePasswordViewController class])];
    cViewController.alertText = @"复制成功!";
    cViewController.buttonText = @"复制";
    cViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:cViewController animated:YES completion:nil];
}

- (IBAction)pressedAddBarButton:(UIBarButtonItem *)sender {
    [self showSelectedItemViewController];
}


- (void)showEmptyMessageView {
    UIView *hudView = [self.view viewWithTag:999];
    if (hudView == nil) {
        JHUD *hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
        hudView.tag = 999;
        hudView.indicatorViewSize = CGSizeMake(138, 110);
        hudView.messageLabel.text = @"";
        hudView.customImage = [UIImage imageNamed:@"ic_empty_box"];
        [hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        hudView.refreshButton.hidden = YES;
    }
}


@end
