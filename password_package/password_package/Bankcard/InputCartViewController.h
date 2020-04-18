//
//  InputCartViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/8.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPBankCardModel;

typedef void(^FinishCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface InputCartViewController : UIViewController

@property (nonatomic,strong) PPBankCardModel *editModel;
@property (nonatomic,copy) FinishCallBack finishCallBack;
@end

NS_ASSUME_NONNULL_END
