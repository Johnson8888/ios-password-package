//
//  SelectCell.h
//  password_package
//
//  Created by Johnson on 2020/4/21.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^CellDidSelected)(NSInteger value);

@interface SelectCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dataDictionary;

//@property (nonatomic,copy) CellDidSelected selectedCallBack;

/// 点击选择 并返回 选择的数值
- (NSInteger)selectAction;
/// 取消选择 方法
- (void)unSelectAction;
@end

NS_ASSUME_NONNULL_END
