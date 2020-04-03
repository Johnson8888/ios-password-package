//
//  LoginViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/2.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL canUseFaceID = [Utils canUseFaceID];
    BOOL canUseTouchID = [Utils canUseTouchID];
    NSLog(@"canUseFaceID = %d canUseTouchID = %d",canUseFaceID,canUseTouchID);
}


@end
