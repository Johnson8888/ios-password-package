//
//  SearchItemViewCell.h
//  password_package
//
//  Created by Johnson on 2020/4/7.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPWebsiteModel;

NS_ASSUME_NONNULL_BEGIN

@interface SearchItemViewCell : UITableViewCell


@property (nonatomic,strong) PPWebsiteModel *dataModel;
/// 网站的名字
@property (nonatomic,strong) NSString *websiteName;
/// 获取域名
- (NSString *)getWebsite;
@end

NS_ASSUME_NONNULL_END
