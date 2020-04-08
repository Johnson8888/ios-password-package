//
//  CreatePasswordViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/3.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BoardDismissCompletion)(NSString * _Nullable pwd,UIViewController *viewController);

NS_ASSUME_NONNULL_BEGIN

@interface CreatePasswordViewController : UITableViewController

@property (nonatomic,strong) NSString *buttonText;
@property (nonatomic,strong) NSString *alertText;

@property (nonatomic,copy) BoardDismissCompletion completion;

@end

NS_ASSUME_NONNULL_END
