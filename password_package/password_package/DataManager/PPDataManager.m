//
//  PPDataManager.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "PPDataManager.h"
#import "FMDB.h"
#import "PPWebsiteModel.h"
#import "PPBankCardModel.h"


/// 网站登录账号和密码
#define TABLE_ITEM_NAME  @"website"


#define TABLE_CARD_NAME  @"bankcard"




/// 新增创建聊天记录数据表


/*
 id 自增键           int
 iconImg 图片路径     blob
 title 名称          varchar
 account 账号        varchar
 password 密码       varchar
 link 链接地址        varchar
 describe 描述       varchar
 ctime 时间戳         integer
 */
 
#define SQL_CREATE_MESSAGE [NSString stringWithFormat:@"create table if not exists %@(id INTEGER PRIMARY KEY AUTOINCREMENT,iconImg text ,title text ,account text , password text ,link text ,describe text ,ctime integer)",TABLE_ITEM_NAME]

/*
id 自增键           int
type 类型           1 是信用卡 2是储蓄卡
frontImg 正面图片     blob
expireDate 到期时间  text
account 账号        text
password 密码       text
cvvCode  cvv码      text
pin   pin码         text
describe 描述       text
logoImageUrl       text
ctime 时间戳        integer
*/

#define SQL_CREATE_BANKCARD [NSString stringWithFormat:@"create table if not exists %@(id INTEGER PRIMARY KEY AUTOINCREMENT,frontImg blob, type integer, expireDate text, account text , password text ,cvvCode text, pin text ,describe text ,logoImageUrl text,ctime integer)",TABLE_CARD_NAME]


@interface PPDataManager()
@property (nonatomic,strong) FMDatabase *dataBase;
@property (nonatomic,strong) FMDatabaseQueue *dataBaseQueue;


@end

@implementation PPDataManager


+ (void)load {
    [self sharedInstance];
}

+ (instancetype)sharedInstance {
    static PPDataManager* dataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [[PPDataManager alloc] init];
    });
    return dataBase;
}

/// 获取当前数据库二进制数据
+ (NSData *)getDBFileData {
    NSString *filePath = [self dbFilePath];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}


/// 恢复数据到本地数据库
+ (NSError * _Nullable)retrieveToDBWithData:(NSData *)data {
    NSString *filePath = [self dbFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *removeError;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&removeError];
        if (removeError) {
            return removeError;
        }
    }
    BOOL result = [data writeToFile:filePath atomically:YES];
    if (result == NO) {
        return [NSError errorWithDomain:@"password_package" code:100 userInfo:@{NSLocalizedDescriptionKey:@"写入文件失败"}];
    }
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self openDB];
    }
    return self;
}

/// 重新打开数据库
- (void)reOpenDB {
    [self openDB];
}

/// 打开数据库
- (void)openDB {
    if (self.dataBase) {
        [self.dataBase close];
        self.dataBase = nil;
    }
    self.dataBase.logsErrors = YES;
    NSString *dbPath = [PPDataManager dbFilePath];
    TTLog(@"dbPath == %@",dbPath);
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if ([self.dataBase open] == NO) {
        TTLog(@"打开数据库失败！！");
    } else {
        //创建
        [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
            if (![self.dataBase tableExists:TABLE_ITEM_NAME]) {
                [self createTable:SQL_CREATE_MESSAGE];
            }
            if (![self.dataBase tableExists:TABLE_CARD_NAME]) {
                [self createTable:SQL_CREATE_BANKCARD];
            }
        }];
    }
}


/// 获取所有的网站信息记录
- (NSMutableArray <PPWebsiteModel *>*)getAllWebsite {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    @synchronized (self.dataBase) {
        if ([self.dataBase tableExists:TABLE_ITEM_NAME]) {
            [self.dataBase setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ",TABLE_ITEM_NAME];
            FMResultSet* result = [self.dataBase executeQuery:sqlString];
            id item = nil;
            while ([result next]) {
                TTLog(@"result = %@",result);
                item = [self websiteFromResult:result];
                if (item != nil) {
                    [array addObject:item];
                }
            }
        }
    }
    return array;
}
/// 删除一个网站信息
/// @param aId 自增键
- (BOOL)deleteWebsiteWithId:(NSNumber *)aId {
    @synchronized (self.dataBase) {
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",TABLE_ITEM_NAME];
        BOOL result = [self.dataBase executeUpdate:sql,aId];
        return result;
    }
}
/// 新增一个网站信息记录
/// @param model 数据模型
- (BOOL)insertWebsiteWithModel:(PPWebsiteModel *)model {
    @synchronized (self.dataBase) {
        NSInteger integerTime = (NSInteger)[[NSDate date] timeIntervalSince1970];
        NSNumber *cTime = [NSNumber numberWithInteger:integerTime];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (title,iconImg,account,password,link,describe,ctime) VALUES (?,?,?,?,?,?,?)",TABLE_ITEM_NAME];
        BOOL success = [self.dataBase executeUpdate:sql,model.title,model.iconImg,model.account,model.password,model.link,model.describe,cTime];
        if (success == NO) {
            TTLog(@"sql error = %@",self.dataBase.lastErrorMessage);
        }
        return success;
    }
}

/// 更新网站信息
/// @param aId 自增键
/// @param model 数据模型
- (BOOL)updateWebsizeWithId:(NSNumber *)aId model:(PPWebsiteModel *)model {
    @synchronized (self.dataBase) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET title = ?, iconImg = ?, account = ?,password = ?,link = ?,describe = ? WHERE id = ?",TABLE_ITEM_NAME];
        BOOL result = [self.dataBase executeUpdate:sql,model.title,model.iconImg,model.account,model.password,model.link,model.describe,model.aId];
        return result;
    }
}



/// 将 数据库查询的数据封装成 model 目前默认返回Dictionary
- (id)websiteFromResult:(FMResultSet*)resultSet {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = [NSNumber numberWithInt:[resultSet intForColumn:@"id"]];
    dic[@"account"] = [resultSet stringForColumn:@"account"];
    dic[@"password"] = [resultSet stringForColumn:@"password"];
    dic[@"title"] = [resultSet stringForColumn:@"title"];
    dic[@"link"] = [resultSet stringForColumn:@"link"];
    dic[@"describe"] = [resultSet stringForColumn:@"describe"];
    dic[@"cTime"] = [NSNumber numberWithInt:[resultSet intForColumn:@"cTime"]];
    NSError *error;
    PPWebsiteModel *model = [[PPWebsiteModel alloc] initWithDictionary:dic error:&error];
    if (model) {
        model.iconImg = [resultSet dataForColumn:@"iconImg"];;
    }
    if (error) {
        TTLog(@"create model error = %@",error);
        return nil;
    }
    return model;
}




/// 获取所有的银行卡信息记录
- (NSMutableArray <PPBankCardModel *>*)getAllBackCard {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    @synchronized (self.dataBase) {
        if ([self.dataBase tableExists:TABLE_CARD_NAME]) {
            [self.dataBase setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ",TABLE_CARD_NAME];
            FMResultSet* result = [self.dataBase executeQuery:sqlString];
            id item = nil;
            while ([result next]) {
                TTLog(@"result = %@",result);
                item = [self backcardFromResult:result];
                if (item != nil) {
                    [array addObject:item];
                }
            }
        }
    }
    return array;
}
/// 删除一个银行卡信息
/// @param aId 自增键
- (BOOL)deleteBackCardWithId:(NSNumber *)aId {
    @synchronized (self.dataBase) {
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",TABLE_CARD_NAME];
        BOOL result = [self.dataBase executeUpdate:sql,aId];
        return result;
    }
}

/// 新增一个银行卡信息记录
/// @param model 数据模型
- (BOOL)insertBackCardWithModel:(PPBankCardModel *)model {
    @synchronized (self.dataBase) {
        NSInteger integerTime = (NSInteger)[[NSDate date] timeIntervalSince1970];
        NSNumber *cTime = [NSNumber numberWithInteger:integerTime];
        NSNumber *type = [NSNumber numberWithInteger:model.type];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (frontImg,type,expireDate,account,password,cvvCode,pin,describe,logoImageUrl,ctime) VALUES (?,?,?,?,?,?,?,?,?,?)",TABLE_CARD_NAME];
        BOOL success = [self.dataBase executeUpdate:sql,model.frontImg,type,model.expireDate,model.account,model.password,model.cvvCode,model.pin,model.describe,model.logoImageUrl,cTime];
        if (success == NO) {
            TTLog(@"sql error = %@",self.dataBase.lastErrorMessage);
        }
        return success;
    }
}

/// 更新银行卡信息
/// @param aId 自增键
/// @param model 数据模型
- (BOOL)updateBackCardWithId:(NSNumber *)aId
                        model:(PPBankCardModel *)model {
    @synchronized (self.dataBase) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET frontImg = ?, type = ?, expireDate = ?,account = ?,password = ?,cvvCode = ?, pin = ?, describe = ?,logoImageUrl = ? WHERE id = ?",TABLE_CARD_NAME];
        NSNumber *type = [NSNumber numberWithInteger:model.type];
        BOOL result = [self.dataBase executeUpdate:sql,model.frontImg,type,model.expireDate,model.account,model.password,model.cvvCode,model.pin,model.describe,model.logoImageUrl,model.aId];
        return result;
    }
}

/// 将 数据库查询的数据封装成 model 目前默认返回Dictionary
- (id)backcardFromResult:(FMResultSet*)resultSet {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = [NSNumber numberWithInt:[resultSet intForColumn:@"id"]];
    dic[@"type"] = [NSNumber numberWithInt:[resultSet intForColumn:@"type"]];
    dic[@"account"] = [resultSet stringForColumn:@"account"];
    dic[@"password"] = [resultSet stringForColumn:@"password"];
    dic[@"expireDate"] = [resultSet stringForColumn:@"expireDate"];
    dic[@"cvvCode"] = [resultSet stringForColumn:@"cvvCode"];
    dic[@"pin"] = [resultSet stringForColumn:@"pin"];
    dic[@"logoImageUrl"] = [resultSet stringForColumn:@"logoImageUrl"];
    dic[@"describe"] = [resultSet stringForColumn:@"describe"];
    dic[@"cTime"] = [NSNumber numberWithInt:[resultSet intForColumn:@"ctime"]];
    NSError *error;
    PPBankCardModel *model = [[PPBankCardModel alloc] initWithDictionary:dic error:&error];
    if (model) {
        model.frontImg = [resultSet dataForColumn:@"frontImg"];
    }
    if (error) {
        TTLog(@"create model error = %@",error);
        return nil;
    }
    return model;
}



/// 创建表
-(BOOL)createTable:(NSString *)sql {
    BOOL result = NO;
    [self.dataBase setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"%@",sql];
    result = [self.dataBase executeUpdate:tempSql];
    return result;
}


/// 清空某个数据表
-(BOOL)clearTable:(NSString *)tableName {
    BOOL result = NO;
    [self.dataBase setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    result = [self.dataBase executeUpdate:tempSql];
    return result;
}


/// 数据库文件的路径
+(NSString *)dbFilePath {
    NSString *directorPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    //改用户的db是否存在，若不存在则创建相应的DB目录
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:directorPath isDirectory:&isDirector];
    if (!(isExiting && isDirector)) {
        BOOL createDirection = [fileManager createDirectoryAtPath:directorPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection) {
            TTLog(@"创建DB目录失败");
        }
    }
    NSString *dbPath = [directorPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DB_FILE_NAME]];
    return dbPath;
}

@end
