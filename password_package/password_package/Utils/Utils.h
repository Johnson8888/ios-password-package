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

/// 给出Alert提示 用于给用户下载购买过的视频
/// @param title Title
/// @param detail 详细描述
/// @param callBack 点击后的回调
+ (void)alertWithTitle:(NSString *)title
                detail:(NSString *)detail
              callBack:(MMPopupItemHandler)callBack;

@end

NS_ASSUME_NONNULL_END
