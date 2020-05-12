//
//  Utils.m
//  password_package
//
//  Created by Johnson on 2020/4/2.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "Utils.h"
#import <HWPop.h>
#import "AppConfig.h"
#import <sys/utsname.h>
#import "HWTopBarViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation Utils


/// 清理剪切板
/// @param targetString 如果剪切板string与targetString相等就清理
+ (void)clearPasteboardWithTargetString:(NSString *)targetString {
    NSInteger clearPasteboardDuration = [AppConfig config].clearPasteboardDuration;
    if (clearPasteboardDuration == 0) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(clearPasteboardDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *currentString = [UIPasteboard generalPasteboard].string;
        if ([currentString isEqualToString:targetString]) {
            [UIPasteboard generalPasteboard].string = @"";
        }
    });
}


+ (BOOL)canUseFaceID {
    if (@available(iOS 11.0, *)) {
        // will fail if user denies `canEvaluatePolicy:error:`
        LAContext *context = [[LAContext alloc] init];
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            return (context.biometryType == LABiometryTypeFaceID);
        }
    }
    return NO;
}

+ (BOOL)canUseTouchID {
    if (@available(iOS 11.0, *)) {
        // will fail if user denies `canEvaluatePolicy:error:`
        LAContext *context = [[LAContext alloc] init];
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            return (context.biometryType == LABiometryTypeTouchID);
        }
    }
    return NO;
}


/// 显示提示框
/// @param text 提示文字
+ (void)showPopWithText:(NSString *)text {
    HWTopBarViewController *topBarVC = [[HWTopBarViewController alloc] initWithText:text];
    HWPopController *popController = [[HWPopController alloc] initWithViewController:topBarVC];
    popController.backgroundAlpha = 0;
    popController.popPosition = HWPopPositionTop;
    popController.popType = HWPopTypeBounceInFromTop;
    popController.dismissType = HWDismissTypeSlideOutToTop;
    popController.shouldDismissOnBackgroundTouch = NO;
    [popController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

/// 给出Alert提示 用于给用户下载购买过的视频
/// @param title Title
/// @param detail 详细描述
/// @param callBack 点击后的回调
+ (void)alertWithTitle:(NSString *)title
                detail:(NSString *)detail
              callBack:(MMPopupItemHandler)callBack {
    NSArray *items =@[MMItemMake(@"取消", MMItemTypeNormal, callBack),
                      MMItemMake(@"确定", MMItemTypeHighlight, callBack)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title
                                 detail:detail
                                  items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    alertView.attachedView = [UIApplication sharedApplication].keyWindow;
    [alertView show];
}


/// 给出Alert提示
/// @param title Title
/// @param detail 详细描述
/// @param callBack 点击后的回调
+ (void)configmAlertWithTitle:(NSString *)title
                       detail:(NSString *)detail
                     callBack:(MMPopupItemHandler)callBack {
    NSArray *items =@[MMItemMake(@"确定", MMItemTypeHighlight, callBack)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title
                                 detail:detail
                                  items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    alertView.attachedView = [UIApplication sharedApplication].keyWindow;
    [alertView show];
}


/// 卡号格式化输出
/// @param string 被格式化的字符串
+ (NSString *)groupedString:(NSString *)string {
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    // 根据长度计算分组的个数
    NSInteger groupCount = (NSInteger)ceilf((CGFloat)str.length /4);
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*4 + 4 > str.length) {
            [components addObject:[str substringFromIndex:i*4]];
        } else {
            NSString * secureStr = [str substringWithRange:NSMakeRange(i*4, 4)];
            secureStr = [secureStr stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"****"];
            [components addObject:secureStr];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}



/// 判断是否支持震动反馈
+(BOOL)isSupportTapFeedBack {
    NSInteger value = [[[UIDevice currentDevice] valueForKey:@"_feedbackSupportLevel"] intValue];
    if (value == 2) {
        return YES;
    }    
    return NO;
}


+ (NSString *)getCurrentDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

@end
