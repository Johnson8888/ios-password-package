//
//  PPPasswordCreator.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PPPasswordCreator.h"
#import "CSYGroupButtonView.h"

@implementation PPPasswordCreator




/// 生成一个长度为 length 的密码
/// @param length 密码的长度
+ (NSString *)createPasswrodWithLength:(NSInteger)length {
    if (length == 0) {
        return @"";
    }
    NSMutableString *password = [NSMutableString string];
//    NSArray *stringArray = [self stringArray];
//    for (int i = 0; i < length; ++i) {
//        NSInteger count = stringArray.count;
//        NSInteger index = arc4random() % (count - 1);
//        NSString *str = stringArray[index];
//        [password appendString:str];
//    }
    return password;
}


+ (NSString *)createPasswordWithLength:(NSInteger)length
                            numberType:(PPNumberType)numberType
                            letterType:(PPLetterType)letterType
                      isOtherCharacter:(BOOL)isOtherCharacter {
    
    if (length == 0) {
        return @"";
    }
    NSMutableString *password = [NSMutableString string];
    for (int i = 0; i < length; ++i) {
        NSMutableArray *tempArray = [NSMutableArray array];
        if (isOtherCharacter) {
            [tempArray addObjectsFromArray:[self otherCharacter]];
        }
        if (numberType == PPAllNumber || numberType == PPNumberAndLetter) {
            [tempArray addObjectsFromArray:[self numberArray]];
        }
        if (numberType == PPAllLetter || numberType == PPNumberAndLetter) {
            if (letterType == PPUpLetter) {
                [tempArray addObjectsFromArray:[self upLetterArray]];
            }
            if (letterType == PPLowLetter) {
                [tempArray addObjectsFromArray:[self lowLetterArray]];
            }
            if (letterType == PPUpAndLowLetter) {
                [tempArray addObjectsFromArray:[self upLetterArray]];
                [tempArray addObjectsFromArray:[self lowLetterArray]];
            }
        }
        NSInteger count = tempArray.count;
        NSInteger index = arc4random() % (count - 1);
        NSString *str = tempArray[index];
        [password appendString:str];
    }
    return password;
}


+ (NSArray *)numberArray {
    return @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
}


+ (NSArray *)lowLetterArray {
    return @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
}


+ (NSArray *)upLetterArray  {
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

+ (NSArray *)otherCharacter {
    return @[@"!",@"#",@"$",@"%",@"&",@"'",@"+",@"*",@",",@"-",@".",@"/",@":",@";",@"<",@">",@"=",@"?",@"@",@"[",@"]",@"^",@"_",@"{",@"}",@"~"];
}

@end
