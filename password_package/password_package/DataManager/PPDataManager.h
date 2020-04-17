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
/*
/// 获取所有的网站信息记录
/// @param completion 获取成功后的回调
- (void)getAllWebsiteWithCompletion:(LoadAllWebsiteCompletion)completion;
/// 删除一个网站信息
/// @param aId 自增键
- (void)deleteWebsiteWithId:(NSNumber *)aId
                 completion:(ExecuteSqlCompletion)completion;

/// 新增一个网站信息记录
/// @param model 数据模型
- (void)insertWebsiteWithModel:(PPWebsiteModel *)model
                    completion:(ExecuteSqlCompletion)completion;

/// 更新网站信息
/// @param aId 自增键
/// @param model 数据模型
- (void)updateWebsizeWithId:(NSNumber *)aId
                      model:(PPWebsiteModel *)model
                 completion:(ExecuteSqlCompletion)completion;
*/


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
/// @param completion 获取成功后的回调
- (void)getAllBackCardWithCompletion:(LoadAllBackCardCompletion)completion;
/// 删除一个银行卡信息
/// @param aId 自增键
- (void)deleteBackCardWithId:(NSNumber *)aId
                   completion:(ExecuteSqlCompletion)completion;
/// 新增一个银行卡信息记录
/// @param model 数据模型
- (void)insertBackCardWithModel:(PPBankCardModel *)model
                      completion:(ExecuteSqlCompletion)completion;
/// 更新银行卡信息
/// @param aId 自增键
/// @param model 数据模型
- (void)updateBackCardWithId:(NSNumber *)aId
                        model:(PPBankCardModel *)model
                   completion:(ExecuteSqlCompletion)completion;



@end

NS_ASSUME_NONNULL_END
