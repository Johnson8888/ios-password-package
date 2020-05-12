//
//  Utils.h
//  password_package
//
//  Created by Johnson on 2020/4/2.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMPopupView/MMPopupView.h>
#import <MMPopupView/MMAlertView.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject



/// 判断 TouchID 是否可用
+ (BOOL)canUseTouchID;
/// 判断 FaceID 是否可用
+ (BOOL)canUseFaceID;

/// 给出Alert提示 
/// @param title Title
/// @param detail 详细描述
/// @param callBack 点击后的回调
+ (void)alertWithTitle:(NSString *)title
                detail:(NSString *)detail
              callBack:(MMPopupItemHandler)callBack;


/// 给出Alert提示
/// @param title Title
/// @param detail 详细描述
/// @param callBack 点击后的回调
+ (void)configmAlertWithTitle:(NSString *)title
                       detail:(NSString *)detail
                     callBack:(MMPopupItemHandler)callBack;


//// 显示Pop View
+ (void)showPopWithText:(NSString *)text;


/// 卡号格式化输出
/// @param string 被格式化的字符串
+ (NSString *)groupedString:(NSString *)string;

/// 判断是否支持震动反馈
+(BOOL)isSupportTapFeedBack;

/// 清理剪切板
/// @param targetString 如果剪切板string与targetString相等就清理
+ (void)clearPasteboardWithTargetString:(NSString *)targetString;

@end

NS_ASSUME_NONNULL_END
