//
//  SwitchCell.m
//  password_package
//
//  Created by Johnson on 2020/4/24.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()

@end

@implementation SwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)switchAction:(id)sender {
    if (self.switchCallBack) {
        self.switchCallBack(self.switchMenu.isOn);
    }
}

@end
