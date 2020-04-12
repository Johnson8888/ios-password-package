//
//  BankCardViewCell.h
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPBankCardModel;
NS_ASSUME_NONNULL_BEGIN

@interface BankCardViewCell : UITableViewCell
@property (nonatomic,strong) PPBankCardModel *dataModel;
@end

NS_ASSUME_NONNULL_END
