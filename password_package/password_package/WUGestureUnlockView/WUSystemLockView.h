//
//  WUSystemLockView.h
//  password_package
//
//  Created by Johnson on 2020/4/24.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapSystemUnlockCallBack)(void);

@interface WUSystemLockView : UIView

@property (nonatomic,copy) TapSystemUnlockCallBack callBack;

@end

NS_ASSUME_NONNULL_END
