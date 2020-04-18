//
//  AppConfig.h
//  password_package
//
//  Created by Johnson on 2020/4/18.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PPTheme) {
    PP_THEME_DEFAULT,
};

NS_ASSUME_NONNULL_BEGIN

@interface AppConfig : NSObject



/// 是否开启震动反馈
@property (nonatomic,assign) BOOL isSharkFeedBack;
/// 主题颜色
@property (nonatomic,assign) PPTheme mainTheme;
/// 开启后 主题模式跟随系统外观
@property (nonatomic,assign) BOOL isAllowDarkModeTheme;
/// 是否开启系统锁屏 如果是指纹就开启指纹 如果是FaceID 就开启 faceID
@property (nonatomic,assign) BOOL userSystemLock;
/// pinCode
@property (nonatomic,assign) NSInteger pinCode;
/// 多长时间自动锁屏  默认是 立刻  10秒 30秒 1分钟 5分钟 10分钟
@property (nonatomic,assign) NSInteger autoLockDuration;
/// 多长时间清除 剪切板  10秒 30秒 1分钟 2分钟 5分钟 从不
@property (nonatomic,assign) NSInteger clearPasteboardDuration;


+ (AppConfig *)config;

+ (void)saveConfig:(AppConfig *)config;

@end

NS_ASSUME_NONNULL_END
