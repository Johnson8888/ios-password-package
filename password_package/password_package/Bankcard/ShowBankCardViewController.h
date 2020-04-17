//
//  ShowBankCardViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/17.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPBankCardModel;
NS_ASSUME_NONNULL_BEGIN

@interface ShowBankCardViewController : UITableViewController

@property (nonatomic,strong) PPBankCardModel *bankCardModel;

@end

NS_ASSUME_NONNULL_END
