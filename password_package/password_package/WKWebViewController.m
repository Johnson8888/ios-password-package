//
//  WKWebViewController.m
//  password_package
//
//  Created by Johnson on 2020/5/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <JGProgressHUD/JGProgressHUD.h>

@interface WKWebViewController ()<WKNavigationDelegate>


@property (nonatomic,strong) NSString *currentUrl;
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) JGProgressHUD *hud;

@end

@implementation WKWebViewController



- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.currentUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 45, 24, 24);
    [backButton addTarget:self action:@selector(pressedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, self.view.bounds.size.width - 80, 44.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = SYSTEM_COLOR;
    label.text = @"隐私协议";
    [self.view addSubview:label];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 84, self.view.bounds.size.width, self.view.bounds.size.height - 84.0f) configuration:config];
    self.wkWebView.navigationDelegate = self;

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]]];
    
    [self.view addSubview:self.wkWebView];
    
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.hud.textLabel.text = @"加载中...";
    [self.hud showInView:self.view];

}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.hud dismissAfterDelay:0.0];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.hud.textLabel.text = @"加载失败,请重试!";
    [self.hud dismissAfterDelay:0.0];
}


- (void)pressedBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
