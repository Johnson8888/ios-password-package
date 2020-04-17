//
//  PresentBankCardViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/16.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPBankCardModel;

typedef void(^BankCardDeleteCallBack)(void);
typedef void(^ViewBankCardCallBack)(PPBankCardModel *cardModel);
typedef void(^EditBankCardCallBack)(PPBankCardModel *cardModel);

NS_ASSUME_NONNULL_BEGIN

@interface PresentBankCardViewController : UIViewController

@property (nonatomic,copy) BankCardDeleteCallBack deleteCallBack;
@property (nonatomic,copy) ViewBankCardCallBack viewBankCardCallBack;
@property (nonatomic,copy) EditBankCardCallBack editBankCardCallBack;
@property (nonatomic,strong) PPBankCardModel *bankCardModel;


@end

NS_ASSUME_NONNULL_END
