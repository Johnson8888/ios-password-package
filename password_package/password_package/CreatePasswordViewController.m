//
//  CreatePasswordViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/3.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "CreatePasswordViewController.h"
#import "PPPasswordCreator.h"
#import "HWBottomAuthViewController.h"
#import "HWTopBarViewController.h"
#import <HWPop.h>
#import <Masonry.h>


@interface CreatePasswordViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;
@property (weak, nonatomic) IBOutlet UISwitch *length8Switch;
@property (weak, nonatomic) IBOutlet UISwitch *length16Switch;
@property (weak, nonatomic) IBOutlet UISwitch *allNumberSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *allLetterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *numberAndLetterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *upLetterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowLetterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *upAndLetterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *otherCharacterSwitch;
@property (nonatomic,assign) PPNumberType currentNumberType;
@property (nonatomic,assign) PPLetterType currentLetterType;
@property (nonatomic,assign) BOOL isOtherCharacter;
@property (nonatomic,strong) NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation CreatePasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray *switchArray = @[self.length8Switch,self.length16Switch,self.allNumberSwitch,self.allLetterSwitch,self.numberAndLetterSwitch,self.upLetterSwitch,self.lowLetterSwitch,self.upAndLetterSwitch,self.otherCharacterSwitch];
    
    for (UISwitch *sw in switchArray) {
        sw.lee_theme
        .LeeAddOnTintColor(kThemeDefault, SYSTEM_COLOR)
        .LeeAddOnTintColor(kThemeRed, LEEColorHex(kColorThemeRed))
        .LeeAddOnTintColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
        .LeeAddOnTintColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
        .LeeAddOnTintColor(kThemePurple, LEEColorHex(kColorThemePurple))
        .LeeAddOnTintColor(kThemeYellow, LEEColorHex(kColorThemeYellow));
    }
    
    
    self.titleLabel.lee_theme
    .LeeAddTextColor(kThemeDefault, SYSTEM_COLOR)
    .LeeAddTextColor(kThemeRed, LEEColorHex(kColorThemeRed))
    .LeeAddTextColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
    .LeeAddTextColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
    .LeeAddTextColor(kThemePurple, LEEColorHex(kColorThemePurple))
    .LeeAddTextColor(kThemeYellow, LEEColorHex(kColorThemeYellow));
    
    [self.closeButton setImage:[[UIImage imageNamed:@"btn_close_circle_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
               forState:UIControlStateNormal];
    
    self.closeButton.lee_theme
    .LeeAddTintColor(kThemeDefault, SYSTEM_COLOR)
    .LeeAddTintColor(kThemeRed, LEEColorHex(kColorThemeRed))
    .LeeAddTintColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
    .LeeAddTintColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
    .LeeAddTintColor(kThemePurple, LEEColorHex(kColorThemePurple))
    .LeeAddTintColor(kThemeYellow, LEEColorHex(kColorThemeYellow));
    
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = 20.0f;
    
    
    self.confirmButton.lee_theme
    .LeeAddButtonTitleColor(kThemeDefault, SYSTEM_COLOR,UIControlStateNormal)
    .LeeAddButtonTitleColor(kThemeRed, LEEColorHex(kColorThemeRed),UIControlStateNormal)
    .LeeAddButtonTitleColor(kThemeBlue, LEEColorHex(kColorThemeBlue),UIControlStateNormal)
    .LeeAddButtonTitleColor(kThemeGreen, LEEColorHex(kColorThemeGreen),UIControlStateNormal)
    .LeeAddButtonTitleColor(kThemePurple, LEEColorHex(kColorThemePurple),UIControlStateNormal)
    .LeeAddButtonTitleColor(kThemeYellow, LEEColorHex(kColorThemeYellow),UIControlStateNormal);
    
    
    
    self.lengthSlider.lee_theme
    .LeeAddSelectorAndColor(kThemeDefault, @selector(setThumbTintColor:), SYSTEM_COLOR)
    .LeeAddSelectorAndColor(kThemeRed, @selector(setThumbTintColor:), LEEColorHex(kColorThemeRed))
    .LeeAddSelectorAndColor(kThemeBlue, @selector(setThumbTintColor:), LEEColorHex(kColorThemeBlue))
    .LeeAddSelectorAndColor(kThemeGreen, @selector(setThumbTintColor:), LEEColorHex(kColorThemeGreen))
    .LeeAddSelectorAndColor(kThemePurple, @selector(setThumbTintColor:), LEEColorHex(kColorThemePurple))
    .LeeAddSelectorAndColor(kThemeYellow, @selector(setThumbTintColor:), LEEColorHex(kColorThemeYellow));
    
    
    self.lengthSlider.lee_theme
    .LeeAddSelectorAndColor(kThemeDefault, @selector(setMinimumTrackTintColor:), SYSTEM_COLOR)
    .LeeAddSelectorAndColor(kThemeRed, @selector(setMinimumTrackTintColor:), LEEColorHex(kColorThemeRed))
    .LeeAddSelectorAndColor(kThemeBlue, @selector(setMinimumTrackTintColor:), LEEColorHex(kColorThemeBlue))
    .LeeAddSelectorAndColor(kThemeGreen, @selector(setMinimumTrackTintColor:), LEEColorHex(kColorThemeGreen))
    .LeeAddSelectorAndColor(kThemePurple, @selector(setMinimumTrackTintColor:), LEEColorHex(kColorThemePurple))
    .LeeAddSelectorAndColor(kThemeYellow, @selector(setMinimumTrackTintColor:), LEEColorHex(kColorThemeYellow));
    
    
    
    
    self.isOtherCharacter = NO;
    self.lengthSlider.minimumValue = 6;
    self.lengthSlider.maximumValue = 32;
    self.currentLetterType = PPUpAndLowLetter;
    self.currentNumberType = PPNumberAndLetter;
    self.lengthSlider.value = 8;
    self.titleArray = @[@"长度",@"字母组合",@"大小写",@"特殊字符"];
    
    
    if (@available(iOS 12.0, *)) {
        BOOL isDark = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
        if (isDark) {
            if (@available(iOS 13.0, *)) {
                self.confirmButton.backgroundColor = TEXT_COLOR;
            }
        }
    }
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)lengthSliderAction:(UISlider *)slider {
    
    self.lengthLabel.text = [NSString stringWithFormat:@"%ld位",(long)slider.value];
    if ((NSInteger)slider.value == 8) {
        self.length8Switch.on = YES;
    } else {
        self.length8Switch.on = NO;
    }
    if ((NSInteger)slider.value == 16) {
        self.length16Switch.on = YES;
    }else {
        self.length16Switch.on = NO;
    }
}

- (IBAction)length8SwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    self.length16Switch.on = !isOn;
    if (isOn) {
        self.lengthSlider.value = 8;
    } else {
        self.lengthSlider.value = 16;
    }
    self.lengthLabel.text = [NSString stringWithFormat:@"%ld位",(long)self.lengthSlider.value];
}

- (IBAction)length16SwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    self.length8Switch.on = !isOn;
    if (isOn) {
        self.lengthSlider.value = 16;
    } else {
        self.lengthSlider.value = 8;
    }
    self.lengthLabel.text = [NSString stringWithFormat:@"%ld位",(long)self.lengthSlider.value];
}


- (IBAction)allNumberSwitchAction:(UISwitch *)switchItmem {
    BOOL isOn = switchItmem.on;
    if (isOn) {
        self.allLetterSwitch.on = NO;
        self.numberAndLetterSwitch.on = NO;
        self.upLetterSwitch.on = NO;
        self.lowLetterSwitch.on = NO;
        self.upAndLetterSwitch.on = NO;
        self.currentNumberType = PPAllNumber;
    } else {
        self.allLetterSwitch.on = YES;
        self.numberAndLetterSwitch.on = NO;
        self.upLetterSwitch.on = YES;
        self.lowLetterSwitch.on = NO;
        self.upAndLetterSwitch.on = NO;
        self.currentNumberType = PPAllLetter;
    }
}

- (IBAction)allLetterSwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    if (isOn) {
        self.allNumberSwitch.on = NO;
        self.numberAndLetterSwitch.on = NO;
        self.currentNumberType = PPAllLetter;
    } else {
        self.allNumberSwitch.on = YES;
        self.numberAndLetterSwitch.on = NO;
        self.currentNumberType = PPAllNumber;
    }
}

- (IBAction)numberAndLetterSwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    if (isOn) {
        self.allLetterSwitch.on = NO;
        self.allNumberSwitch.on = NO;
        self.currentNumberType = PPNumberAndLetter;
    } else {
        self.allLetterSwitch.on = YES;
        self.allNumberSwitch.on = NO;
        self.currentNumberType = PPAllLetter;
    }
}


- (IBAction)upLetterSwtichAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    if (isOn) {
        self.lowLetterSwitch.on = NO;
        self.upAndLetterSwitch.on = NO;
        self.currentLetterType = PPUpLetter;
    }else {
        self.lowLetterSwitch.on = YES;
        self.upAndLetterSwitch.on = NO;
        self.currentLetterType = PPLowLetter;
    }
}

- (IBAction)lowLetterSwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    if (isOn) {
        self.upLetterSwitch.on = NO;
        self.upAndLetterSwitch.on = NO;
        self.currentLetterType = PPLowLetter;
    }else {
        self.upLetterSwitch.on = YES;
        self.upAndLetterSwitch.on = NO;
        self.currentLetterType = PPUpLetter;
    }
}

- (IBAction)upAndLowLetterSwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    if (isOn) {
        self.lowLetterSwitch.on = NO;
        self.upLetterSwitch.on = NO;
        self.currentLetterType = PPUpAndLowLetter;
    }else {
        self.lowLetterSwitch.on = YES;
        self.upLetterSwitch.on = NO;
        self.currentLetterType = PPLowLetter;
    }
}

- (IBAction)otherCharacterSwitchAction:(UISwitch *)switchItem {
    self.isOtherCharacter = switchItem.isOn;
}


- (IBAction)pressedCreateButton:(UISwitch *)switchItem {
    NSInteger currentLength = (NSInteger)self.lengthSlider.value;
    NSString *password = [PPPasswordCreator createPasswordWithLength:currentLength
                                                          numberType:self.currentNumberType
                                                          letterType:self.currentLetterType
                                                    isOtherCharacter:self.isOtherCharacter];
    TTLog(@"password == %@",password);
    
    HWBottomAuthViewController *bottomAuthVC = [[HWBottomAuthViewController alloc]
                                                initWithText:password
                                                buttonText:self.buttonText
                                                completion:^{
        if (self.alertText.length != 0) {
            [self showCopySuccess];
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = password;
        
        if (self.completion) {
            self.completion(password,self);
        }
    }];
    
    HWPopController *popController = [[HWPopController alloc] initWithViewController:bottomAuthVC];
    popController.popPosition = HWPopPositionBottom;
    popController.popType = HWPopTypeBounceInFromBottom;
    popController.dismissType = HWDismissTypeSlideOutToBottom;
    popController.shouldDismissOnBackgroundTouch = NO;
    [popController presentInViewController:self];
    
}


-(void)showCopySuccess {
    HWTopBarViewController *topBarVC = [[HWTopBarViewController alloc] initWithText:self.alertText];
    HWPopController *popController = [[HWPopController alloc] initWithViewController:topBarVC];
    popController.backgroundAlpha = 0;
    popController.popPosition = HWPopPositionTop;
    popController.popType = HWPopTypeBounceInFromTop;
    popController.dismissType = HWDismissTypeSlideOutToTop;
    [popController presentInViewController:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0f;
    }
    return 20.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArray[section];
}


@end
