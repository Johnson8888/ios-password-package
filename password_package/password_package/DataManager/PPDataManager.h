//
//  PPDataManager.h
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPWebsiteModel;
@class PPBankCardModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoadAllWebsiteCompletion)(NSMutableArray <PPWebsiteModel *>* array,NSError * _Nullable error);

typedef void(^LoadAllBackCardCompletion)(NSMutableArray <PPBankCardModel *>* array,NSError * _Nullable error);

typedef void(^ExecuteSqlCompletion)(BOOL isSuccess);

@interface PPDataManager : NSObject

+ (instancetype)sharedInstance;


/// 获取当前数据库二进制数据
+ (NSData *)getDBFileData;
/// 恢复数据到本地数据库
+ (NSError * _Nullable)retrieveToDBWithData:(NSData *)data;
/// 重新打开数据库
- (void)reOpenDB;
/// 获取所有的网站信息记录
- (NSMutableArray <PPWebsiteModel *>*)getAllWebsite;
/// 删除一个网站信息
/// @param aId 自增键
- (BOOL)deleteWebsiteWithId:(NSNumber *)aId;
/// 新增一个网站信息记录
/// @param model 数据模型
- (BOOL)insertWebsiteWithModel:(PPWebsiteModel *)model;
/// 更新网站信息
/// @param aId 自增键
/// @param model 数据模型
- (BOOL)updateWebsizeWithId:(NSNumber *)aId model:(PPWebsiteModel *)model;




/// 获取所有的银行卡信息记录
- (NSMutableArray <PPBankCardModel *>*)getAllBackCard;

/// 删除一个银行卡信息
/// @param aId 自增键
- (BOOL)deleteBackCardWithId:(NSNumber *)aId;

/// 新增一个银行卡信息记录
/// @param model 数据模型
- (BOOL)insertBackCardWithModel:(PPBankCardModel *)model;

/// 更新银行卡信息
/// @param aId 自增键
/// @param model 数据模型
- (BOOL)updateBackCardWithId:(NSNumber *)aId
                        model:(PPBankCardModel *)model;



@end

NS_ASSUME_NONNULL_END
