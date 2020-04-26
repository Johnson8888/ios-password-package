//
//  SwitchCell.h
//  password_package
//
//  Created by Johnson on 2020/4/24.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchActionCallBack)(BOOL isOn);

NS_ASSUME_NONNULL_BEGIN

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchMenu;

@property (nonatomic,copy) SwitchActionCallBack switchCallBack;
@end

NS_ASSUME_NONNULL_END
