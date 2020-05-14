//
//  SelectIconViewController.h
//  password_package
//
//  Created by Johnson on 2020/5/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveCallBack)(void);

@interface SelectIconViewController : UIViewController

/// 保存后的回调
@property (nonatomic,copy) SaveCallBack saveCallBack;

@end

NS_ASSUME_NONNULL_END
