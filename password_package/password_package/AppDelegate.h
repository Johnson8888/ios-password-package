//
//  AppDelegate.h
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) UIWindow *window;



/// 由Theme返回NavigaionTitle的颜色
/// @param theme 主题描述
+ (UIColor *)navigationTitleColorOfTheme:(NSString *)theme;


+ (void)addAlphaView;

+ (void)removeAlphaView;

@end

