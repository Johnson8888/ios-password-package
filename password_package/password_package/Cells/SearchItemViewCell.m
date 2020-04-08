//
//  SearchItemViewCell.m
//  password_package
//
//  Created by Johnson on 2020/4/7.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SearchItemViewCell.h"


@interface SearchItemViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;


@end

@implementation SearchItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setWebsiteName:(NSString *)websiteName {
    
    _websiteName = websiteName;
    
    NSString *namePath = [NSString stringWithFormat:@"/website/%@@2x.png",websiteName];
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:namePath];
        
    self.iconImageView.image = [UIImage imageWithContentsOfFile:filePath];
    
    if ([websiteName containsString:@"."] == NO) {
        self.nameLabel.text = websiteName;
        websiteName = [NSString stringWithFormat:@"%@.com",websiteName];
        self.websiteLabel.text = websiteName;
    } else {
        self.websiteLabel.text = websiteName;
        websiteName = [websiteName componentsSeparatedByString:@"."].firstObject;
        self.nameLabel.text = websiteName;
    }
}
- (NSString *)getWebsite {
    return self.websiteLabel.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
