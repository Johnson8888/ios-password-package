//
//  SelectThemeViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/26.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectThemeCallBack)(void);

@interface SelectThemeViewController : UIViewController

@property (nonatomic,copy)SelectThemeCallBack selectThemeCallBack;

@end

NS_ASSUME_NONNULL_END
