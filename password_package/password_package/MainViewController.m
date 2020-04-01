//
//  ViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *loginFilePath = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"json"];
    NSData *loginData = [NSData dataWithContentsOfFile:loginFilePath];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:loginData options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        TTLog(@"dict = %@",dict);
    }
}


@end
