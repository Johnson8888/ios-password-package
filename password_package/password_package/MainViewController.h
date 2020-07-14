//
//  ViewController.h
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController


/// shortCutAction
@property (nonatomic,strong) NSString *shortCutActionName;

/// short cut jump with name
- (void)shortCutActionWithName:(NSString *)name;

@end

