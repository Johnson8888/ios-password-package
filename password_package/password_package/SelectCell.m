//
//  SelectCell.m
//  password_package
//
//  Created by Johnson on 2020/4/21.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SelectCell.h"

@interface SelectCell() 
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end


@implementation SelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary {
    _dataDictionary = dataDictionary;
    if ([dataDictionary objectForKey:@"title"]) {
        self.nameLabel.text = dataDictionary[@"title"];
    }
    if ([dataDictionary objectForKey:@"selected"] &&
        [[dataDictionary objectForKey:@"selected"] boolValue]) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
}

- (IBAction)pressedSelectedButton:(id)sender {
    BOOL isSelected = self.selectButton.isSelected;
    /// 已经选中了
    if (isSelected) {
        return;
    }
}


/// 点击选择 并返回 选择的数值
- (NSInteger)selectAction {
    self.selectButton.selected = YES;
    NSInteger value = [self.dataDictionary[@"value"] intValue];
    return value;
}

/// 取消选择 方法
- (void)unSelectAction {
    self.selectButton.selected = NO;
    TTLog(@"selectButton.isSelected = %d",self.selectButton.isSelected);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
