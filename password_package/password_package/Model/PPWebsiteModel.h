//
//  PPWebsiteModel.h
//  password_package
//
//  Created by Johnson on 2020/4/2.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPWebsiteModel : JSONModel

//iconImg blob ,cardImg blob ,title varchar ,account varchar , password varchar ,link varchar ,describe varchar , tag varchar ,ctime integer


@property (nonatomic,strong) NSData *iconImg;
@property (nonatomic,strong) NSDate *cardImg;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *describe;
// 时间戳
@property (nonatomic,assign) NSInteger cTime;

@end

NS_ASSUME_NONNULL_END
