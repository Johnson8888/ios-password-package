//
//  PresentWebsiteViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/11.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PPWebsiteModel;

typedef void(^DeleteWebsiteItemCallBack)(void);
typedef void(^ViewWebsiteItemCallBack)(PPWebsiteModel *model);
typedef void(^EditWebsiteItemCallBack)(PPWebsiteModel *model);
typedef void(^ShareWebsiteItemCallBack)(PPWebsiteModel *model);
NS_ASSUME_NONNULL_BEGIN

@interface PresentWebsiteViewController : UIViewController

@property (nonatomic,copy) DeleteWebsiteItemCallBack deleteCallBack;
@property (nonatomic,copy) ViewWebsiteItemCallBack viewCallBack;
@property (nonatomic,copy) EditWebsiteItemCallBack editCallBack;
@property (nonatomic,copy) ShareWebsiteItemCallBack shareCallBack;

@property (nonatomic,strong) PPWebsiteModel *websiteModel;

@end

NS_ASSUME_NONNULL_END
