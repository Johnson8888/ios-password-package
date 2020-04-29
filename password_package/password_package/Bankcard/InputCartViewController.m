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
#import <AFNetworking.h>
#import <ProgressHUD/ProgressHUD.h>
#import "BankCardResponse.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

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
    /// cert 4984513025445663
    // SPDB
    NSString *getCardImage = @"https://apimg.alipay.com/combo.png?d=cashier&t=ICBC";
    NSString *getCardImage1 = @"https://apimg.alipay.com/combo.png?d=cashier&t=SPDB";
    
    if (self.editModel) {
        
        self.accountLabel.text = self.editModel.account;
        self.dateLabel.text = self.editModel.expireDate;
        self.cvvCodeLabel.text = self.editModel.cvvCode;
        
        self.typeSegment.selectedSegmentIndex = self.editModel.type;
        self.expireDateTF.text = self.editModel.expireDate;
        self.accountTF.text = self.editModel.account;
        self.passwordTF.text = self.editModel.password;
        self.cvvTF.text = self.editModel.cvvCode;
        self.pinTF.text = self.editModel.pin;
        self.describe.text = self.editModel.describe;
        TTLog(@"编辑模式 model = %@",self.editModel);
        
    } else {
        self.bankCardModel = [[PPBankCardModel alloc] init];
        self.describe.placeholder = @"请输入备注(可选)";
        if (@available(iOS 13.0, *)) {
            self.describe.placeholderColor = [UIColor labelColor];
        } else {
            self.describe.placeholderColor = [UIColor darkTextColor];
        }
    }
}



- (IBAction)pressedConfirmButton:(id)sender {
    if (self.accountTF.text.length == 0) {
        [ProgressHUD showError:@"请输入银行卡号!"];
        return;
    }
    if (self.passwordTF.text.length == 0) {
        [ProgressHUD showError:@"请输入密码!"];
        return;
    }
    
    /// 编辑模式
    if (self.editModel) {
        
        self.editModel.type = self.typeSegment.selectedSegmentIndex;
        self.editModel.account = self.accountTF.text;
        self.editModel.password = self.passwordTF.text;
        self.editModel.cvvCode = self.cvvTF.text;
        self.editModel.pin = self.pinTF.text;
        self.editModel.describe = self.describe.text;
        
        BOOL editResult = [[PPDataManager sharedInstance] updateBackCardWithId:self.editModel.aId model:self.editModel];
        if (editResult) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.finishCallBack) {
                    self.finishCallBack();
                }
            }];
        } else {
            TTLog(@"edit error");
        }
        
    } else {
        
        self.bankCardModel.type = self.typeSegment.selectedSegmentIndex;
        self.bankCardModel.account = self.accountTF.text;
        self.bankCardModel.expireDate = self.expireDateTF.text;
        self.bankCardModel.password = self.passwordTF.text;
        self.bankCardModel.cvvCode = self.cvvTF.text;
        self.bankCardModel.pin = self.pinTF.text;
        self.bankCardModel.describe = self.describe.text;
        
        BOOL isSuccess = [[PPDataManager sharedInstance] insertBackCardWithModel:self.bankCardModel];
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.finishCallBack) {
                    self.finishCallBack();
                }
            }];
        } else {
            TTLog(@"insert data error");
        }
    }
    
}


- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}



- (void)textFieldDidEndEditing:(UITextField *)textField
                         reason:(UITextFieldDidEndEditingReason)reason  {
    TTLog(@"textFieldDidEndEditing with reason");
    
    if (textField == self.accountTF) {
        NSString *tempString = textField.text;
        NSString *cardNumber = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self getCardInfoWithBankNumber:cardNumber
                             completion:^(BankCardResponse *model, NSError *error) {
            if (error) {
                TTLog(@"get cad type error = %@",error);
                return;
            }
            
            TTLog(@"cardType = %@ bank = %@",model.cardType,model.bank);
            if (model.cardType.length == 0) {
                return;
            }
            
            if ([model.cardType isEqualToString:@"DC"]) {
                TTLog(@"ChuXu Card");
                self.typeSegment.selectedSegmentIndex = 0;
            }else if ([model.cardType isEqualToString:@"CC"]) {
                TTLog(@"Cer Card");
                self.typeSegment.selectedSegmentIndex = 1;
            }
        }];
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 16 - 19 位
    if (textField == self.accountTF) {
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
            self.accountLabel.text = textField.text;
            return NO;
        }
        [textField setText:newString];
        self.accountLabel.text = textField.text;
        return NO;
    }
    
    if (textField == self.expireDateTF) {
        NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 2)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 2) {
                newString = [newString stringByAppendingString:@"/"];
            }
            text = [text substringFromIndex:MIN(text.length, 2)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if ([newString stringByReplacingOccurrencesOfString:@"/" withString:@""].length >= 5) {
            self.dateLabel.text = textField.text;
            return NO;
        }
        [textField setText:newString];
        self.dateLabel.text = textField.text;
        return NO;
    }
    
    if (textField == self.cvvTF) {
        self.cvvCodeLabel.text = textField.text;
        if (self.cvvCodeLabel.text.length > 2) {
            return NO;
        }
    }
    return YES;
}


/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    TTLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    TTLog(@"textFieldShouldEndEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TTLog(@"textFieldDidEndEditing");
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    TTLog(@"textFieldDidChangeSelection");
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    TTLog(@"textFieldShouldClear");
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    TTLog(@"textFieldShouldReturn");
    return YES;
}
*/



- (void)getCardInfoWithBankNumber:(NSString *)number
                       completion:(void(^)(BankCardResponse *model,NSError *error))completion {
    
    NSString *baseURL = @"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardBinCheck=true&cardNo=";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",baseURL,number];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *createModelError;
        BankCardResponse *model = [[BankCardResponse alloc] initWithDictionary:responseObject error:&createModelError];
        if (createModelError) {
            completion(nil,createModelError);
        } else {
            completion(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"请求失败 不显示")
        completion(nil,error);
    }];
}



@end
