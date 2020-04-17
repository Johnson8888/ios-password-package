//
//  PPBankCardModel.h
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSUInteger, PPBankCardType) {
    PP_DEPOSIT_CARD = 1,
    PP_CREDIT_CARD,
};

NS_ASSUME_NONNULL_BEGIN

@interface PPBankCardModel : JSONModel
/*
id 自增键           int
type 类型           1 是信用卡 2是储蓄卡
frontImg 正面图片     blob
backImg 反面图片     blob
expireDate 到期时间  text
account 账号        text
password 密码       text
cvvCode  cvv码      text
pin   pin码         text
describe 描述       text
ctime 时间戳        integer
*/

@property (nonatomic,strong) NSNumber *aId;

@property (nonatomic,strong) NSData *frontImg;
@property (nonatomic,strong) NSData *backImg;


@property (nonatomic,assign) PPBankCardType type;
@property (nonatomic,strong) NSString *expireDate;
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *cvvCode;
@property (nonatomic,strong) NSString *pin;
@property (nonatomic,strong) NSString *describe;

@property (nonatomic,assign) NSInteger cTime;

@end

NS_ASSUME_NONNULL_END
