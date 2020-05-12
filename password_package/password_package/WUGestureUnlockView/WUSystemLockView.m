//
//  WUSystemLockView.m
//  password_package
//
//  Created by Johnson on 2020/4/24.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "WUSystemLockView.h"
#import "Utils.h"
#import "AppConfig.h"

@interface WUSystemLockView()
@property (weak, nonatomic) IBOutlet UIButton *systemUnlockButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation WUSystemLockView


- (void)awakeFromNib {
    
    [super awakeFromNib];
    NSString *displayName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@已锁定",displayName];
    BOOL isTouchID = [Utils canUseTouchID];
    BOOL isFaceID = [Utils canUseFaceID];
    
    if (isTouchID) {
        [self.systemUnlockButton setTitle:@"使用TouchID解锁" forState:UIControlStateNormal];
    }
    if (isFaceID) {
        [self.systemUnlockButton setTitle:@"使用FaceID解锁" forState:UIControlStateNormal];
    }
    
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 50.0f;
    
    self.logoImageView.backgroundColor = SYSTEM_COLOR;
    NSString *iconFileName = [AppConfig config].iconFileName;
    if (iconFileName != nil || iconFileName.length == 0) {
        self.logoImageView.image = [UIImage imageNamed:@"default_icon_file"];
    }else {
        self.logoImageView.image = [UIImage imageNamed:iconFileName];
    }
    
}


- (IBAction)pressedSystemLockButton:(id)sender {
    if (self.callBack) {
        self.callBack();
    }
}

- (IBAction)pressedGestureUnlockButton:(id)sender {
    [self removeFromSuperview];
}

@end
