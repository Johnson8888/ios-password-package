//
//  SearchItemViewCell.h
//  password_package
//
//  Created by Johnson on 2020/4/7.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchItemViewCell : UITableViewCell


/// 网站的名字
@property (nonatomic,strong) NSString *websiteName;
/// 获取域名
- (NSString *)getWebsite;
@end

NS_ASSUME_NONNULL_END
