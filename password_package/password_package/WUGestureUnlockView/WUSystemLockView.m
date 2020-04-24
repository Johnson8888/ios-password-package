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

@end

@implementation WUSystemLockView


- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *displayName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ is locked.",displayName];
    BOOL isTouchID = [Utils canUseTouchID];
    BOOL isFaceID = [Utils canUseFaceID];
    
    if (isTouchID) {
        [self.systemUnlockButton setTitle:@"Use TouchID" forState:UIControlStateNormal];
    }
    if (isFaceID) {
        [self.systemUnlockButton setTitle:@"Use FaceID" forState:UIControlStateNormal];
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
