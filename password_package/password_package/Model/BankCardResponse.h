//
//  BankCardResponse.h
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankCardResponse : JSONModel

@property (nonatomic,strong) NSString *cardType;
@property (nonatomic,strong) NSString *bank;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *stat;
@property (nonatomic,assign) BOOL validated;
@property (nonatomic,strong) NSArray *messages;

@end

NS_ASSUME_NONNULL_END
