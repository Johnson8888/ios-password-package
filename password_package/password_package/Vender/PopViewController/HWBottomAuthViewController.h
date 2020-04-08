//
//  HWBottomAuthViewController.h
//  HWPopController_Example
//
//  Created by heath wang on 2019/5/23.
//  Copyright © 2019 heathwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AuthCompletion)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HWBottomAuthViewController : UIViewController

- (id)initWithText:(NSString *)text
        buttonText:(NSString *)buttonText
        completion:(AuthCompletion)completion;

@end

NS_ASSUME_NONNULL_END
