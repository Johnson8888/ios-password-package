//
//  CoverView.m
//  password_package
//
//  Created by Johnson on 2020/4/21.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *bundleDisplayName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
        NSString *context = [NSString stringWithFormat:@"%@全力保护你的信息安全",bundleDisplayName];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
        if (@available(iOS 13.0, *)) {
            titleLabel.textColor = [UIColor labelColor];
        } else {
            titleLabel.textColor = [UIColor darkGrayColor];
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (@available(iOS 13.0, *)) {
            titleLabel.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            titleLabel.backgroundColor = [UIColor whiteColor];
        }
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.text = context;
        [self addSubview:titleLabel];
    }
    return self;
}

@end
