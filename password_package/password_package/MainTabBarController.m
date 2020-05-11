//
//  MainTabBarController.m
//  password_package
//
//  Created by Johnson on 2020/4/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (@available(iOS 13, *)) {
        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
        appearance.backgroundImage = [UIImage new];
        appearance.backgroundColor = [UIColor clearColor];
        appearance.shadowImage = [UIImage new];
        appearance.shadowColor = [UIColor clearColor];
        self.tabBar.standardAppearance = appearance;
    } else {
        self.tabBar.backgroundImage = [UIImage new];
        self.tabBar.shadowImage = [UIImage new];
    }

    
}



@end


















