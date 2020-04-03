//
//  Utils.h
//  password_package
//
//  Created by Johnson on 2020/4/2.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject



/// 判断 TouchID 是否可用
+ (BOOL)canUseTouchID;
/// 判断 FaceID 是否可用
+ (BOOL)canUseFaceID;

@end

NS_ASSUME_NONNULL_END
