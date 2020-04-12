//
//  PPWebsiteModel.m
//  password_package
//
//  Created by Johnson on 2020/4/2.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PPWebsiteModel.h"

@implementation PPWebsiteModel

//@property (nonatomic,strong) NSData *iconImg;
//@property (nonatomic,strong) NSString *title;
//@property (nonatomic,strong) NSString *link;
//@property (nonatomic,strong) NSString *describe;
//@property (nonatomic,assign) NSInteger cTime;


+(BOOL)propertyIsOptional:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"iconImg"] || [propertyName isEqualToString:@"title"] ||
        [propertyName isEqualToString:@"link"] || [propertyName isEqualToString:@"describe"] ||
        [propertyName isEqualToString:@"cTime"]) {
        return  YES;
    }
    return NO;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"aId":@"id",
        @"account":@"account",
        @"password":@"password",
        @"iconImg":@"iconImg",
        @"title":@"title",
        @"link":@"link",
        @"describe":@"describe",
        @"cTime":@"cTime"
    }];
}


@end
