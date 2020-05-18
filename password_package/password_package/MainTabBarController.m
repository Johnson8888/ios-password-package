//
//  MainTabBarController.m
//  password_package
//
//  Created by Johnson on 2020/4/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "MainTabBarController.h"
#import <LEETheme.h>

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
    
    
//    NSArray *viewControllers = self.viewControllers;
//    for (UINavigationController *nav in viewControllers) {
//        TTLog(@"tabar == %@",nav.tabBarItem);
//        UITabBarItem *tabBarItem = nav.tabBarItem;
//        UITabBar *bar;
//        
//        tabBarItem.lee_theme
//        .LeeAddTintColor(kThemeDefault, SYSTEM_COLOR)
//        .LeeAddTintColor(kThemeGreen, [UIColor greenColor])
//        .LeeConfigTintColor(@"ident7");
//    }
    
    
//    self.nameLabel.lee_theme
//    .LeeAddTextColor(kThemeDefault, [UIColor whiteColor])
//    .LeeAddTextColor(kThemeGreen, [UIColor greenColor])
//    .LeeConfigTextColor(@"ident7");
        
    
}



@end


















