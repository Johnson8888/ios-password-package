//
//  AppConfig.m
//  password_package
//
//  Created by Johnson on 2020/4/18.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "AppConfig.h"

#define saveFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"comppconfig.data"]


@interface AppConfig()

@end

@implementation AppConfig


+ (AppConfig *)config {
    AppConfig *lastConfig = (AppConfig *)[NSKeyedUnarchiver unarchiveObjectWithFile:saveFilePath];
    if (lastConfig == nil) {
        lastConfig = [[AppConfig alloc] init];
    }
    return lastConfig;
}

+ (void)saveConfig:(AppConfig *)config {
    [NSKeyedArchiver archiveRootObject:config toFile:saveFilePath];
}


- (id)init {
    /// 如果不存在 需要初始化
    self = [super init];
    if (self) {
        self.isSharkFeedBack = YES;
        /// 默认是不适用 系统锁定功能的
        self.userSystemLock = YES;
        self.isAllowDarkModeTheme = YES;
        self.mainTheme = PP_THEME_DEFAULT;
        self.autoLockDuration = 0;
        self.clearPasteboardDuration = 300;
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.isSharkFeedBack = [aDecoder decodeBoolForKey:@"isSharkFeedBack"];
        self.mainTheme = [aDecoder decodeIntegerForKey:@"mainTheme"];
        self.isAllowDarkModeTheme = [aDecoder decodeBoolForKey:@"isAllowDarkModeTheme"];
        self.autoLockDuration = [aDecoder decodeIntegerForKey:@"autoLockDuration"];
        self.clearPasteboardDuration = [aDecoder decodeIntegerForKey:@"clearPasteboardDuration"];
        self.userSystemLock = [aDecoder decodeBoolForKey:@"userSystemLock"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isSharkFeedBack forKey:@"isSharkFeedBack"];
    [aCoder encodeInteger:self.mainTheme forKey:@"mainTheme"];
    [aCoder encodeBool:self.isAllowDarkModeTheme forKey:@"isAllowDarkModeTheme"];
    [aCoder encodeInteger:self.autoLockDuration forKey:@"autoLockDuration"];
    [aCoder encodeInteger:self.clearPasteboardDuration forKey:@"clearPasteboardDuration"];
    [aCoder encodeBool:self.userSystemLock forKey:@"userSystemLock"];
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

@end
