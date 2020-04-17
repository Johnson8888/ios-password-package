//
//  InputWebsiteViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/8.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPWebsiteModel;

typedef void(^InputWebsiteDismissCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface InputWebsiteViewController : UIViewController
/// web size name
@property (nonatomic,strong) NSString *webSiteName;
/// 当前 websiteModel 如果存在的话 就是编辑模式
@property (nonatomic,strong) PPWebsiteModel *websiteModel;
/// InputWebsite Dismiss 回调
@property (nonatomic,copy) InputWebsiteDismissCallBack dismissCallBack;

@end

NS_ASSUME_NONNULL_END
