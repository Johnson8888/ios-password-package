//
//  InputCartViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/8.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "InputCartViewController.h"
#import "PPBankCardModel.h"
#import "PPDataManager.h"

@interface InputCartViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cvvCodeLabel;

/// 用来显示 账号的 label
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *modeImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *pinTF;
@property (weak, nonatomic) IBOutlet UITextField *cvvTF;
@property (weak, nonatomic) IBOutlet UITextView *describe;
@property (weak, nonatomic) IBOutlet UITextField *expireDateTF;
@property (nonatomic,strong) PPBankCardModel *bankCardModel;

@end

@implementation InputCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=6221506020009066385&cardBinCheck=true";
    
    NSString *getCardImage = @"https://apimg.alipay.com/combo.png?d=cashier&t=ICBC";
    
    
    self.bankCardModel = [[PPBankCardModel alloc] init];
    
    /*银行卡分借记卡、准贷记卡、贷记卡三种，而银行卡一般都携带银联、Visa、Master、JCB等标志。一般以6开头的卡是银联卡，以4开头的卡是携带Visa标志的卡，以5开头的卡是携带Master的卡，以3开头的是携带JCB标志的卡。一个银行的的卡里面带有同一个标志的卡的前几位数字是一样的，譬如招商银行，带银联标志的卡以62258开头，带Visa的标志以4392开头，带Master标志的以5186开头，带JCB的以3568开头。另外一个银行的借记卡和贷记卡的卡号位数一般不一样， 譬如建设银行，借记卡以4367开头，是19位，而带Visa标志的贷记卡也以4367开头，但是是16位的。一般贷记卡的卡号位数都是16位，借记卡位数根据银行不同，是16位到19位不等。
     */
    
    
}

- (IBAction)pressedConfirmButton:(id)sender {
    if (self.accountTF.text.length == 0) {
        return;
    }
    if (self.passwordTF.text.length == 0) {
        return;
    }
    
    self.bankCardModel.frontImg = UIImagePNGRepresentation(self.frontImageView.image);
    self.bankCardModel.type = self.typeSegment.selectedSegmentIndex;
    self.bankCardModel.account = self.accountTF.text;
    self.bankCardModel.password = self.passwordTF.text;
    self.bankCardModel.expireDate = self.expireDateTF.text;
    self.bankCardModel.cvvCode = self.cvvTF.text;
    self.bankCardModel.pin = self.pinTF.text;
    self.bankCardModel.describe = self.describe.text;
    
    [[PPDataManager sharedInstance] insertBackCardWithModel:self.bankCardModel
                                                 completion:^(BOOL isSuccess) {
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:^{}];
        } else {
            TTLog(@"insert data error");
        }
    }];
    
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
                         reason:(UITextFieldDidEndEditingReason)reason  {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 16 - 19 位
    if (textField == self.accountTF) {
        TTLog(@"text == %@",textField.text);
            // 4位分隔银行卡卡号
        NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 20) {
            return NO;
        }
        [textField setText:newString];
        return NO;
    }
    return YES;
}


- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTF) {
        TTLog(@"text == %@",textField.text);
    }
    return YES;
}


- (void)addAction {
    /*
    NSString *takePhotoTitle = @"拍照";
    if (self.showTakeVideoBtnSwitch.isOn && self.showTakePhotoBtnSwitch.isOn) {
        takePhotoTitle = @"相机";
    } else if (self.showTakeVideoBtnSwitch.isOn) {
        takePhotoTitle = @"拍摄";
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    [alertVc addAction:takePhotoAction];
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }];
    [alertVc addAction:imagePickerAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (popover) {
        popover.sourceView = cell;
        popover.sourceRect = cell.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    NSLog(@"去相册选择");
    
    [self presentViewController:alertVc animated:YES completion:nil];

     */
}


@end
