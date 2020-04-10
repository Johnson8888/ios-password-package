//
//  BankCardViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "BankCardViewController.h"
#import "InputCartViewController.h"

@interface BankCardViewController ()

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)pressedAddButton:(id)sender {
    InputCartViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputCartViewController class])];
    [self presentViewController:inputViewController animated:YES completion:nil];
}



@end
