//
//  PresentWebsiteViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/11.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DeleteWebsiteItemCallBack)(void);
typedef void(^ViewWebsiteItemCallBack)(void);
@class PPWebsiteModel;

NS_ASSUME_NONNULL_BEGIN

@interface PresentWebsiteViewController : UIViewController

@property (nonatomic,copy) DeleteWebsiteItemCallBack deleteCallBack;
@property (nonatomic,copy) ViewWebsiteItemCallBack viewCallBack;
@property (nonatomic,strong) PPWebsiteModel *websiteModel;

@end

NS_ASSUME_NONNULL_END
