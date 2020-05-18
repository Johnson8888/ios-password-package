//
//  SearchItemViewCell.m
//  password_package
//
//  Created by Johnson on 2020/4/7.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SearchItemViewCell.h"
#import "PPWebsiteModel.h"
#import "HWBottomAuthViewController.h"
#import "HWTopBarViewController.h"
#import "SearchItemViewController.h"
#import <HWPop.h>
#import <LEETheme/LEETheme.h>


@interface SearchItemViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;


@end

@implementation SearchItemViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    self.nameLabel.lee_theme
//    .LeeAddTextColor(kThemeDefault, [UIColor whiteColor])
//    .LeeAddTextColor(kThemeGreen, [UIColor greenColor]);
    
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


//- (void)setDescriptionName:(NSString *)descriptionName {
//    _descriptionName = descriptionName;
//    self.nameLabel.text = descriptionName;
//}


- (void)setDataModel:(PPWebsiteModel *)dataModel {
    _dataModel = dataModel;
    self.iconImageView.image = [UIImage imageWithData:dataModel.iconImg];
//    self.nameLabel.text = dataModel.title;
    self.nameLabel.text = [SearchItemViewController descriptionWithName:dataModel.title];
    self.websiteLabel.text = dataModel.account;
    self.pasteButton.hidden = NO;
}

- (NSString *)getWebsite {
    return self.websiteLabel.text;
}

- (IBAction)pressedCopyButton:(id)sender {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    HWTopBarViewController *topBarVC = [[HWTopBarViewController alloc] initWithText:@"复制密码成功!"];
    HWPopController *popController = [[HWPopController alloc] initWithViewController:topBarVC];
    popController.backgroundAlpha = 0;
    popController.popPosition = HWPopPositionTop;
    popController.popType = HWPopTypeBounceInFromTop;
    popController.dismissType = HWDismissTypeSlideOutToTop;
    [popController presentInViewController:rootViewController];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
