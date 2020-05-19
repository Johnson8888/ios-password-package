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
    self.switchMenu.lee_theme
    .LeeAddOnTintColor(kThemeDefault, SYSTEM_COLOR)
    .LeeAddOnTintColor(kThemeRed, LEEColorHex(kColorThemeRed))
    .LeeAddOnTintColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
    .LeeAddOnTintColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
    .LeeAddOnTintColor(kThemePurple, LEEColorHex(kColorThemePurple))
    .LeeAddOnTintColor(kThemeYellow, LEEColorHex(kColorThemeYellow));

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
