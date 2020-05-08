//
//  BankCardViewCell.m
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "BankCardViewCell.h"
#import "PPBankCardModel.h"
#import <SDWebImage.h>

@interface BankCardViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BankCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDataModel:(PPBankCardModel *)dataModel {
    _dataModel = dataModel;
    self.nameLabel.text = dataModel.account;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.logoImageUrl]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
