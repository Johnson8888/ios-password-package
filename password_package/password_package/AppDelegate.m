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
#import <AppCenter/AppCenter.h>
#import <iCloudDocumentSync/iCloud.h>
#import <AppCenterCrashes/AppCenterCrashes.h>
#import <AppCenterAnalytics/AppCenterAnalytics.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()
/// 用来遮挡的 View
@property (nonatomic,strong) CoverView *coverView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    TTLog(@"timeStamp = %ld lastTimeStamp = %ld duration = %ld",(long)timeStamp,(long)lastTimeStamp,(long)duration);
    
    
    

//    删除密码
//    [ZLGestureLockViewController deleteGesturesPassword];
    
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
        [self presentLoginViewController];
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


- (void)presentLoginViewController {
    TTLog(@"need present login view controller");
    
}



- (CoverView *)coverView {
    if (_coverView == nil) {
        _coverView = [[CoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    _coverView.backgroundColor = [UIColor whiteColor];
    _coverView.alpha = 0.9;
    return _coverView;
}




#pragma mark - UISceneSession lifecycle
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
////     Called when the user discards a scene session.
////     If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
////     Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
