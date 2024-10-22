//
//  SetAutoLockViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/21.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveAutoLockCallBack)(void);

@interface SetAutoLockViewController : UIViewController
@property (nonatomic,copy) SaveAutoLockCallBack saveCallBack;
@end

NS_ASSUME_NONNULL_END
