//
//  CreatePasswordViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/3.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "CreatePasswordViewController.h"
#import "PPPasswordCreator.h"


@interface CreatePasswordViewController ()
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
@end

@implementation CreatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOtherCharacter = NO;
    self.lengthSlider.minimumValue = 6;
    self.lengthSlider.maximumValue = 32;

}

- (IBAction)lengthSliderAction:(UISlider *)slider {
    
    self.lengthLabel.text = [NSString stringWithFormat:@"%ld位数",(long)slider.value];
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
}
- (IBAction)length16SwitchAction:(UISwitch *)switchItem {
    BOOL isOn = switchItem.on;
    self.length8Switch.on = !isOn;
}


- (IBAction)allNumberSwitchAction:(UISwitch *)switchItmem {
    BOOL isOn = switchItmem.on;
    if (isOn) {
        self.allLetterSwitch.on = NO;
        self.numberAndLetterSwitch.on = NO;
        self.currentNumberType = PPAllNumber;
    } else {
        self.allLetterSwitch.on = YES;
        self.numberAndLetterSwitch.on = NO;
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
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
