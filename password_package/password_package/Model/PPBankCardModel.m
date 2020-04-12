//
//  PPBankCardModel.m
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PPBankCardModel.h"

@implementation PPBankCardModel


+(BOOL)propertyIsOptional:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"frontImg"] || [propertyName isEqualToString:@"backImg"] ||
        [propertyName isEqualToString:@"expireDate"] || [propertyName isEqualToString:@"cvvCode"] ||
        [propertyName isEqualToString:@"pin"] || [propertyName isEqualToString:@"describe"] ||
        [propertyName isEqualToString:@"cTime"]) {
        return  YES;
    }
    return NO;
}



+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"aId":@"id",
        @"type":@"type",
        @"frontImg":@"frontImg",
        @"backImg":@"backImg",
        @"expireDate":@"expireDate",
        @"account":@"account",
        @"password":@"password",
        @"cvvCode":@"cvvCode",
        @"pin":@"pin",
        @"describe":@"describe",
        @"cTime":@"ctime"
    }];
}


@end
