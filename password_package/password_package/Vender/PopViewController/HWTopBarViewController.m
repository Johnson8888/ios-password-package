//
//  HWTopBarViewController.m
//  HWPopController_Example
//
//  Created by heath wang on 2019/5/23.
//  Copyright © 2019 heathwang. All rights reserved.
//

#import <HWPopController/HWPop.h>
#import "HWTopBarViewController.h"
#import <Masonry/Masonry.h>

@interface HWTopBarViewController ()

@property (nonatomic,strong) NSString *text;
@end

@implementation HWTopBarViewController

- (id)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentSizeInPop = CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 64);
    self.view.backgroundColor = [UIColor colorWithRed:0.397 green:0.859 blue:0.066 alpha:1.00];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismiss)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UILabel *label = [UILabel new];
    label.text = self.text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];

    [self.view addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];
    [self performSelector:@selector(didTapToDismiss) withObject:nil afterDelay:0.75];
}

- (void)didTapToDismiss {
    [self.popController dismiss];
}



@end
