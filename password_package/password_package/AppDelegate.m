//
//  AppDelegate.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import "CoverView.h"
#import "AppConfig.h"
#import "MainViewController.h"
#import <AppCenter/AppCenter.h>
#import <iCloudDocumentSync/iCloud.h>
#import "WUGesturesUnlockViewController.h"
#import <AppCenterCrashes/AppCenterCrashes.h>
#import <AppCenterAnalytics/AppCenterAnalytics.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()
/// 用来遮挡的 View
@property (nonatomic,strong) CoverView *coverView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    [UITabBar appearance].tintColor = SYSTEM_COLOR;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:SYSTEM_COLOR}];
    
    [iCloud sharedCloud].verboseLogging = YES;
    [[iCloud sharedCloud] setupiCloudDocumentSyncWithUbiquityContainer:ICLOUD_CONTAINER_BUNDLE_IDENTIFER];
    
    [MSAppCenter start:@"0209845f-0d7d-4a95-9841-e58fdcb72c52"
          withServices:@[[MSAnalytics class],[MSCrashes class]]];
    
    [IQKeyboardManager sharedManager];
    
    NSInteger duration = [AppConfig config].autoLockDuration;
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSInteger lastTimeStamp = [[NSUserDefaults standardUserDefaults] integerForKey:PP_ENTER_BACKGROUND_TIME_KEY];
    if (lastTimeStamp != 0 && timeStamp - lastTimeStamp >= duration) {
        [self presentLoginViewController];
    }
    
    if ([launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey]) {
        UIApplicationShortcutItem *currentShortItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
        if (currentShortItem.type.length == 0) {
            return YES;
        }
        UITabBarController *rootViewController = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navigationController = rootViewController.viewControllers.firstObject;
        MainViewController *mainViewController = navigationController.viewControllers.firstObject;
        mainViewController.shortCutActionName = currentShortItem.type;
    }
    
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (self.coverView.superview) {
        [self.coverView removeFromSuperview];
    }
    NSInteger duration = [AppConfig config].autoLockDuration;
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSInteger lastTimeStamp = [[NSUserDefaults standardUserDefaults] integerForKey:PP_ENTER_BACKGROUND_TIME_KEY];
    if (lastTimeStamp != 0 && timeStamp - lastTimeStamp >= duration) {
//        [self presentLoginViewController];
    }
    TTLog(@"will enter foreground");
}



// 在AppDelete实现该方法
- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.coverView.superview) {
        [self.coverView removeFromSuperview];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setInteger:timeStamp forKey:PP_ENTER_BACKGROUND_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TTLog(@"did enter background");
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    UITabBarController *rootViewController = (UITabBarController *)self.window.rootViewController;
    if (rootViewController.selectedIndex != 0) {
        rootViewController.selectedIndex = 0;
    }
    UINavigationController *navigationController = rootViewController.viewControllers.firstObject;
    if ([navigationController.topViewController isKindOfClass:[MainViewController class]] == NO) {
        [navigationController popToRootViewControllerAnimated:NO];
    }
    if (navigationController.presentedViewController != nil) {
        [navigationController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    if (navigationController.viewControllers.firstObject.presentingViewController != nil) {
        [navigationController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    MainViewController *mainViewController = navigationController.viewControllers.firstObject;
    [mainViewController shortCutActionWithName:shortcutItem.type];
}



- (void)presentLoginViewController {
    TTLog(@"need present login view controller");
    NSString *lastPwd = [WUGesturesUnlockViewController gesturesPassword];
    if (lastPwd.length > 0) {
        WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    }
    
}



- (CoverView *)coverView {
    if (_coverView == nil) {
        _coverView = [[CoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    if (@available(iOS 13.0, *)) {
        _coverView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    _coverView.alpha = 0.9;
    return _coverView;
}




@end
