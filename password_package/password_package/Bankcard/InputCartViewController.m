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
#import "BankCardResponse.h"

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
    
    
//    [self.accountTF addTarget:self action:@selector(textFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
//    [self.expireDateTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
//    [self.cvvTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.bankCardModel = [[PPBankCardModel alloc] init];
    
    /*银行卡分借记卡、准贷记卡、贷记卡三种，而银行卡一般都携带银联、Visa、Master、JCB等标志。一般以6开头的卡是银联卡，以4开头的卡是携带Visa标志的卡，以5开头的卡是携带Master的卡，以3开头的是携带JCB标志的卡。一个银行的的卡里面带有同一个标志的卡的前几位数字是一样的，譬如招商银行，带银联标志的卡以62258开头，带Visa的标志以4392开头，带Master标志的以5186开头，带JCB的以3568开头。另外一个银行的借记卡和贷记卡的卡号位数一般不一样， 譬如建设银行，借记卡以4367开头，是19位，而带Visa标志的贷记卡也以4367开头，但是是16位的。一般贷记卡的卡号位数都是16位，借记卡位数根据银行不同，是16位到19位不等。
     */
    
    /*
    [self getCardInfoWithBankNumber:@"6221506020009066385" completion:^(BankCardResponse *model, NSError *error) {
        if (error) {
            TTLog(@"get cad type error");
        }else {
            TTLog(@"cardType = %@ bank = %@",model.cardType,model.bank);
            if (model.cardType.length > 0) {
                if ([model.cardType isEqualToString:@"DC"]) {
                    TTLog(@"储蓄卡")
                    self.typeSegment.selectedSegmentIndex = 0;
                }else if ([model.cardType isEqualToString:@"CC"]) {
                    TTLog(@"信用卡");
                    self.typeSegment.selectedSegmentIndex = 1;
                }
            }
        }
    }];
    */
}


- (IBAction)pressedConfirmButton:(id)sender {
    
    if (self.accountTF.text.length == 0) {
        return;
    }
    if (self.passwordTF.text.length == 0) {
        return;
    }
    
    self.bankCardModel.type = self.typeSegment.selectedSegmentIndex;
    self.bankCardModel.account = self.accountTF.text;
    self.bankCardModel.password = self.passwordTF.text;
    self.bankCardModel.cvvCode = self.cvvTF.text;
    self.bankCardModel.pin = self.pinTF.text;
    self.bankCardModel.describe = self.describe.text;
    
    BOOL isSuccess = [[PPDataManager sharedInstance] insertBackCardWithModel:self.bankCardModel];
    if (isSuccess) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        TTLog(@"insert data error");
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
