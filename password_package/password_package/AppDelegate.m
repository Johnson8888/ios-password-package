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
#import <LEETheme.h>
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
        
    
    [self configTheme];
    
    
    
    [UITabBar appearance].tintColor = SYSTEM_COLOR;
    NSString *currentTag = [LEETheme currentThemeTag];
    if (currentTag == nil || currentTag.length == 0) {
        currentTag = kThemeDefault;
    }
    UIColor *titleColor = [AppDelegate navigationTitleColorOfTheme:currentTag];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
    [[UINavigationBar appearance]setLargeTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];

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
    
    /// 保存第一次请求网络的状态
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_POST_NET_WORK] == NO) {
        [self getNetworRequestWithURL:@"https://www.baidu.com" completion:^(NSDictionary * _Nullable response, NSError * _Nullable error) {}];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_POST_NET_WORK];
        [[NSUserDefaults standardUserDefaults] synchronize];
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


/// Get 请求
/// @param url 请求地址
/// @param completion 请求完成后的回调
- (void)getNetworRequestWithURL:(NSString *)url
                     completion:(void(^)(NSDictionary *_Nullable response, NSError *_Nullable error))completion {
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    mutableRequest.timeoutInterval = 90.0f;
    [mutableRequest setHTTPMethod: @"GET"];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *parseError;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&parseError];
            if (parseError) {
                completion(nil,parseError);
                return;
            }
            completion(responseObject,nil);
        }else{
            completion(nil,error);
        }
    }];
    [dataTask resume];
}



#pragma mark - 设置主题

- (void)configTheme{
    
    NSString *dayJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_day" ofType:@"json"];
    
    NSString *nightJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_night" ofType:@"json"];
    
    NSString *dayJson = [NSString stringWithContentsOfFile:dayJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *nightJson = [NSString stringWithContentsOfFile:nightJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme defaultTheme:kThemeGreen];    
    [LEETheme addThemeConfigWithJson:dayJson Tag:kThemeDefault ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:nightJson Tag:kThemeGreen ResourcesPath:nil];
}



/// 由Theme返回NavigaionTitle的颜色
/// @param theme 主题描述
+ (UIColor *)navigationTitleColorOfTheme:(NSString *)theme {
    if ([theme isEqualToString:kThemeGreen]) {
        return LEEColorHex(kColorThemeGreen);
    }
    if ([theme isEqualToString:kThemeRed]) {
        return LEEColorHex(kColorThemeRed);
    }
    if ([theme isEqualToString:kThemeBlue]) {
        return LEEColorHex(kColorThemeBlue);
    }
    if ([theme isEqualToString:kThemePurple]) {
        return LEEColorHex(kColorThemePurple);
    }
    if ([theme isEqualToString:kThemeYellow]) {
        return LEEColorHex(kColorThemeYellow);
    }
    return SYSTEM_COLOR;
}


//     self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

+ (void)addAlphaView {
    UIWindow *mainWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIView *alphaView = [mainWindow viewWithTag:999];
    if (alphaView) {
        [alphaView removeFromSuperview];
    }
    if (alphaView == nil) {
        alphaView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [mainWindow addSubview:alphaView];
    }
}

+ (void)removeAlphaView {
    UIWindow *mainWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIView *alphaView = [mainWindow viewWithTag:999];
    if (alphaView) {
        [alphaView removeFromSuperview];
    }
}

@end
