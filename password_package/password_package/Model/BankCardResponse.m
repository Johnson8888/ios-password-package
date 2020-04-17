//
//  BankCardResponse.m
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "BankCardResponse.h"

@implementation BankCardResponse

//+(BOOL)propertyIsOptional:(NSString *)propertyName {
//    NSArray *namesArray = @[@"cardType",@"bank",@"key",@"stat",@"validated",@"messages"];
//    if ([namesArray.description containsString:propertyName]) {
//        return YES;
//    }
//    return NO;
//}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}



@end
