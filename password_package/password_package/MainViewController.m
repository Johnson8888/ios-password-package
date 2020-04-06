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
#import "KxMenu.h"
#import "CreatePasswordViewController.h"
#import "CSYGroupButtonView.h"
#import <Masonry.h>

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    NSArray *arrayLeft = @[@"按钮1",@"按钮2",@"按钮3"];
    
    //相应数组
    CSYGroupButtonView *groupButton = [[CSYGroupButtonView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 85, self.view.bounds.size.height - 100 - 65, 65, 65) mainButtonTitle:@"添加" selectedTitle:@"添加" otherButtonsTitle:arrayLeft];
    groupButton.ButtonClickBlock = ^(UIButton *btn) {
        NSLog(@"%@ tag=%ld",btn.titleLabel.text,(long)btn.tag);
        if (btn.tag == 1) {
            [self showCreatePasswordViewController];
        }
    };
    [self.view addSubview:groupButton];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    TTLog(@"view did load");
}

- (void)showCreatePasswordViewController {
    CreatePasswordViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreatePasswordViewController class])];
    cViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:cViewController animated:YES completion:nil];
}

- (IBAction)pressedAddBarButton:(UIBarButtonItem *)sender {
    

}




@end
