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

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    LoginViewController *lViewController = [[LoginViewController alloc] initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
//    [self presentViewController:lViewController animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    TTLog(@"view did load");
}


- (IBAction)pressedAddBarButton:(UIBarButtonItem *)sender {
    
    NSArray *menuItems = @[
      [KxMenuItem menuItem:@"Share this"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Reload page"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"生成"
                     image:[UIImage imageNamed:@"home_icon"]
                    target:self
                    action:@selector(pressedCreatePasswordMenu:)]];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor redColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(self.view.bounds.size.width - 60, 20, 40, 30)
                 menuItems:menuItems];
}



- (void)pressedCreatePasswordMenu:(id)menu {
    CreatePasswordViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreatePasswordViewController class])];
    cViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:cViewController animated:YES completion:nil];
}

@end
