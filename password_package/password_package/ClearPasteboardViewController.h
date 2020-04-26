//
//  ClearPasteboardViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/20.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClearPasteboardCallBack)(void);

@interface ClearPasteboardViewController : UIViewController

@property (nonatomic,copy) ClearPasteboardCallBack clearCallBack;
@end

NS_ASSUME_NONNULL_END
