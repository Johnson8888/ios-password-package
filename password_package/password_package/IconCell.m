//
//  IconCell.m
//  password_package
//
//  Created by Johnson on 2020/5/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "IconCell.h"

@implementation IconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 18.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
