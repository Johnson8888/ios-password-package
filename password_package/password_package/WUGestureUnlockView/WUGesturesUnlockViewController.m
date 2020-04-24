//
//  WUGestureUnlockViewController.m
//  WUGesturesToUnlock
//
//  Created by wuqh on 16/4/1.
//  Copyright © 2016年 wuqh. All rights reserved.
//

#import "WUGesturesUnlockViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WUGesturesUnlockIndicator.h"
#import "WUGesturesUnlockView.h"
#import "WUSystemLockView.h"
#import "AppConfig.h"
#import <Masonry.h>
#import "Utils.h"

#define GesturesPassword @"gesturespassword"

#define kUnlockTryCount 5

@interface WUGesturesUnlockViewController ()<WUGesturesUnlockViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet WUGesturesUnlockView *gesturesUnlockView;
@property (weak, nonatomic) IBOutlet WUGesturesUnlockIndicator *gesturesUnlockIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
 //重新绘制按钮
@property (weak, nonatomic) IBOutlet UIButton *otherAcountLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetGesturesPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *resetGesturesPasswordButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIconImageView;

//约束：
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatoerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headIconTopConstraint;


@property (nonatomic) WUUnlockType unlockType;

//要创建的手势密码
@property (nonatomic, copy) NSString *lastGesturePassword;

@property (nonatomic,strong) WUSystemLockView *systemLockView;

@end

@implementation WUGesturesUnlockViewController

#pragma mark - 类方法

+ (void)deleteGesturesPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addGesturesPassword:(NSString *)gesturesPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)gesturesPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:GesturesPassword];
}

#pragma mark - inint
- (instancetype)initWithUnlockType:(WUUnlockType)unlockType {
    if (self = [super init]) {
        _unlockType = unlockType;
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.gesturesUnlockView.delegate = self;
    self.resetGesturesPasswordButton.hidden = YES;
    switch (_unlockType) {
        case WUUnlockTypeCreatePwd: {
            self.gesturesUnlockIndicator.hidden = NO;
            self.otherAcountLoginButton.hidden = YES;
            self.forgetGesturesPasswordButton.hidden = YES;
            self.nameLabel.hidden = YES;
            self.headIconImageView.hidden = YES;
        }
            break;
        case WUUnlockTypeValidatePwd: {
            self.gesturesUnlockIndicator.hidden = YES;
            
        }
            break;
        default:
            break;
    }
    
    [self udpateConstraints];
    
    BOOL isUseSystemLock = [AppConfig config].userSystemLock;
    if (isUseSystemLock && _unlockType == WUUnlockTypeValidatePwd) {
        self.systemLockView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WUSystemLockView class]) owner:self options:nil].firstObject;
        [self.view addSubview:self.systemLockView];
        __weak __block WUGesturesUnlockViewController *weakself = self;
        self.systemLockView.callBack = ^{
            BOOL isTouchID = [Utils canUseTouchID];
            BOOL isFaceID = [Utils canUseFaceID];
            if (isTouchID) {
                [weakself verifyTouchID];
            }
            if (isFaceID) {
                [weakself verifyFaceID];
            }
        };
        [self.systemLockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        BOOL isTouchID = [Utils canUseTouchID];
        BOOL isFaceID = [Utils canUseFaceID];
        if (isTouchID) {
            [weakself verifyTouchID];
        }
        if (isFaceID) {
            [weakself verifyFaceID];
        }
    }
    
}




#pragma mark - private
//创建手势密码
- (void)createGesturesPassword:(NSMutableString *)gesturesPassword {
    
    if (self.lastGesturePassword.length == 0) {
        
        if (gesturesPassword.length <4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入";
            [self shakeAnimationForView:self.statusLabel];
            return;
        }
        
        if (self.resetGesturesPasswordButton.hidden == YES) {
            self.resetGesturesPasswordButton.hidden = NO;
        }
        
        self.lastGesturePassword = gesturesPassword;
        [self.gesturesUnlockIndicator setGesturesPassword:gesturesPassword];
        self.statusLabel.text = @"请再次绘制手势密码";
        return;
    }
    
    if ([self.lastGesturePassword isEqualToString:gesturesPassword]) {//绘制成功
        
        [self dismissViewControllerAnimated:YES completion:^{
            //保存手势密码
            [WUGesturesUnlockViewController addGesturesPassword:gesturesPassword];
        }];
        
    }else {
        self.statusLabel.text = @"与上一次绘制不一致，请重新绘制";
        [self shakeAnimationForView:self.statusLabel];
    }
}

//验证手势密码
- (void)validateGesturesPassword:(NSMutableString *)gesturesPassword {
    
    static NSInteger errorCount = kUnlockTryCount;

    if ([gesturesPassword isEqualToString:[WUGesturesUnlockViewController gesturesPassword]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            errorCount = kUnlockTryCount;
        }];
    }else {
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
            [Utils alertWithTitle:@"手势密码已失效"
                           detail:@"请重新登陆"
                         callBack:^(NSInteger index) {
                if (index == 0) {}
            }];
            errorCount = kUnlockTryCount;
            return;
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        [self shakeAnimationForView:self.statusLabel];
    }
}

//抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

//更新约束，进行适配
- (void)udpateConstraints {
    if (Screen_Height == 480) {// 适配4寸屏幕
        self.headIconTopConstraint.constant = 30;
        self.indicatoerTopConstraint.constant = 64;
    }
}

#pragma mark - Action
//点击其他账号登陆按钮
- (IBAction)otherAccountLogin:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}
//点击重新绘制按钮
- (IBAction)resetGesturePassword:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    self.lastGesturePassword = nil;
    self.statusLabel.text = @"请绘制手势密码";
    self.resetGesturesPasswordButton.hidden = YES;
    [self.gesturesUnlockIndicator setGesturesPassword:@""];
}
//点击忘记手势密码按钮
- (IBAction)forgetGesturesPassword:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - WUGesturesUnlockViewDelegate
- (void)gesturesUnlockView:(WUGesturesUnlockView *)unlockView drawRectFinished:(NSMutableString *)gesturePassword {
    
    switch (_unlockType) {
        case WUUnlockTypeCreatePwd://创建手势密码
        {
            [self createGesturesPassword:gesturePassword];
        }
            break;
        case WUUnlockTypeValidatePwd://校验手势密码
        {
            [self validateGesturesPassword:gesturePassword];
        }
            break;
        default:
            break;
    }
}





/// 验证脸部识别
- (void)verifyFaceID {
    LAContext *context = [[LAContext alloc] init];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
            localizedReason:@"FaceID解锁"
                      reply:^(BOOL success, NSError * _Nullable error) {
        //注意iOS 11.3之后需要配置Info.plist权限才可以通过Face ID验证哦!不然只能输密码啦...
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{}];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                TTLog(@"FaceID verify error");
            });
        }
    }];
}

/// 验证指纹识别
- (void)verifyTouchID {
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"手势解锁";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"TouchID解锁"
                      reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"TouchID 验证成功");
                [self dismissViewControllerAnimated:YES completion:^{}];
            });
        }else if(error){
            
            switch (error.code) {
                case LAErrorAuthenticationFailed:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 验证失败");
                    });
                    break;
                }
                case LAErrorUserCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被用户手动取消");
                    });
                }
                    break;
                case LAErrorUserFallback:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"用户不使用TouchID,选择手势解锁");
                    });
                }
                    break;
                case LAErrorSystemCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                    });
                }
                    break;
                case LAErrorPasscodeNotSet:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                    });
                }
                    break;
                case LAErrorBiometryNotEnrolled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                    });
                }
                    break;
                case LAErrorBiometryNotAvailable:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无效");
                    });
                }
                    break;
                case LAErrorBiometryLockout:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self touchIdIsLocked];
                        NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                    });
                }
                    break;
                case LAErrorAppCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                    });
                }
                    break;
                case LAErrorInvalidContext:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                    });
                }
                    break;
                default:
                    break;
            }
        }
    }];
}


- (void)touchIdIsLocked {
    LAContext *context = [[LAContext alloc] init];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证密码" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"验证成功");
            // 把本地标识改为NO，表示指纹解锁解除锁定
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"touchIdIsLocked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            NSLog(@"验证失败");
        }
    }];
}

@end
