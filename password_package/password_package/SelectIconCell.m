//
//  SelectIconCell.m
//  password_package
//
//  Created by Johnson on 2020/5/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SelectIconCell.h"

@implementation SelectIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 23.5f;
    
    [self.selectButton setImage:[[UIImage imageNamed:@"select_check"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                       forState:UIControlStateNormal];
    self.selectButton.tintColor = SYSTEM_COLOR;
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary {
    _dataDictionary = dataDictionary;
    self.iconImageView.image = [UIImage imageNamed:dataDictionary[@"fileName"]];
    BOOL isSelect = [dataDictionary[@"isSelect"] boolValue];
    if (isSelect) {
        self.selectButton.hidden = NO;
    }else {
        self.selectButton.hidden = YES;
    }
}


- (IBAction)pressedSelectButton:(id)sender {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
