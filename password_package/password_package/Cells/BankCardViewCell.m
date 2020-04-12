//
//  BankCardViewCell.m
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "BankCardViewCell.h"
#import "PPBankCardModel.h"

@implementation BankCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDataModel:(PPBankCardModel *)dataModel {
    _dataModel = dataModel;
    self.textLabel.text = dataModel.account;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
