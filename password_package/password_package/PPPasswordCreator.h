//
//  PPPasswordCreator.h
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PPNumberType) {
    PPAllNumber,
    PPAllLetter,
    PPNumberAndLetter,
};

typedef NS_ENUM(NSUInteger, PPLetterType) {
    PPUpLetter,
    PPLowLetter,
    PPUpAndLowLetter,
};


@interface PPPasswordCreator : NSObject


/// 生成一个长度为 length 的密码
/// @param length 密码的长度
+ (NSString *)createPasswordWithLength:(NSInteger)length;

+ (NSString *)createPasswordWithLength:(NSInteger)legth
                            numberType:(PPNumberType)numberType
                            letterType:(PPLetterType)letterType
                      isOtherCharacter:(BOOL)isOtherCharacter;


@end

NS_ASSUME_NONNULL_END
