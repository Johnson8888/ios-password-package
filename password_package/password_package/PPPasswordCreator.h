//
//  PPPasswordCreator.h
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPPasswordCreator : NSObject


/// 生成一个长度为 length 的密码
/// @param length 密码的长度
+ (NSString *)createPasswrodWithLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
