//
//  GFGroupButtonView.h
//  TestMap
//
//  Created by chenshyiuan on 2017/2/25.
//  Copyright © 2017年 chenshyiuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonClickBlock)(UIButton*button);

@interface CSYGroupButtonView : UIView

@property(strong ,nonatomic)UIButton* mainButton;
@property(strong,nonatomic)NSString *unSelectedTitle;
@property(strong,nonatomic)NSString *selectedTitle;
@property(strong,nonatomic)NSArray<NSString*> *subButtonsTitle_Array;
@property(assign,nonatomic)CGFloat SpaceDistance;
//@property(strong,nonatomic)

@property(copy,nonatomic)buttonClickBlock ButtonClickBlock;

-(instancetype)initWithFrame:(CGRect)frame mainButtonTitle:(NSString*)title selectedTitle:(NSString*)selectedTitle otherButtonsTitle:(NSArray<NSString*>*)subButtonsTitle_Array;

@end

