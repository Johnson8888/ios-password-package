//
//  GFGroupButtonView.m
//  TestMap
//
//  Created by chenshyiuan on 2017/2/25.
//  Copyright © 2017年 chenshyiuan. All rights reserved.
//

#import "CSYGroupButtonView.h"


static const int fontSize = 10.0;
static const float CORNERRADIUS = 22.0f;

@interface CSYGroupButtonView() {
    NSMutableArray *otherButtons;
    CGRect rectFrame;
    UIImageView *myImageView;
}

@property (nonatomic,strong) NSArray *imagesArray;

@end

@implementation CSYGroupButtonView



-(instancetype)initWithFrame:(CGRect)frame
             mainButtonTitle:(NSString *)title
               selectedTitle:(NSString *)selectedTitle
           otherButtonsTitle:(NSArray<NSString *> *)subButtonsTitle_Array {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.imagesArray = @[@"create_password",@"site",@"bank"];
        rectFrame = frame;
        self.unSelectedTitle = title;   //没被选择的显示按钮
        self.selectedTitle = selectedTitle;  //被选择之后显示的按钮
        self.subButtonsTitle_Array = subButtonsTitle_Array;  //其他要显示的按钮的标题
        self.SpaceDistance = 10;  //设置间距
        [self layoutAddViewBy:self];
        
        UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        mainBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];\
        
        
        [mainBtn setImage:[[UIImage imageNamed:@"add_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                   forState:UIControlStateNormal];
        [mainBtn setTintColor:SYSTEM_COLOR];
        [mainBtn setBackgroundColor:[UIColor clearColor]];
        mainBtn.frame = self.bounds;
        mainBtn.tag = 0;
        mainBtn.layer.masksToBounds = YES;
        mainBtn.layer.cornerRadius = CORNERRADIUS;
        [mainBtn addTarget:self action:@selector(buttonClick:) forControlEvents:5];
        mainBtn.selected = NO;  //设置未被选择
        [self addSubview:mainBtn];
        self.mainButton = mainBtn;
    }
    return self;
}

#pragma -mark 按钮点击事件
-(void)buttonClick:(UIButton*)button {
        
    [self setAnimation];
    if (button.tag == 0) {
        NSString * string = button.selected == NO ? self.unSelectedTitle : self.selectedTitle;
        [button setTitle:string forState:UIControlStateNormal];
    } else {

        button.selected = YES;
        for (UIButton* btn in otherButtons) {
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    if (self.ButtonClickBlock) {
        self.ButtonClickBlock(button);
    }
}

#pragma -mark  设置动画
-(void)setAnimation {
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:10
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
        //如果已经被选择则收回 否则则移除
        self.mainButton.selected == YES ? [self back]:[self move];
    } completion:^(BOOL finished) {
        
    }];
    self.mainButton.selected = !self.mainButton.selected;
}
#pragma -mark 弹出
-(void)move {
    for (UIButton *btn in otherButtons) {
        btn.hidden = NO;
    }
    
    myImageView.alpha = 0;
    //调整视图大小，响应点击事件
    CGRect bounds = self.frame;
    //设置自身视图的view大小
    bounds.origin.y = bounds.origin.y - otherButtons.count * (CGRectGetHeight(self.frame) + self.SpaceDistance);
    
    bounds.size.height = (otherButtons.count+1) * CGRectGetHeight(self.mainButton.frame) + self.SpaceDistance * otherButtons.count;
    
    self.frame = bounds;
    
    //计算主按钮所在位置
    CGRect mainBtnBounds = self.mainButton.frame;
    mainBtnBounds.origin.y = self.mainButton.frame.origin.y + otherButtons.count * (CGRectGetHeight(self.mainButton.frame) + self.SpaceDistance);
    self.mainButton.frame = mainBtnBounds;
    
    //设置二级按钮响应事件
    for (int i = 0; i < otherButtons.count; i++) {
        //获得button
        UIButton *button = otherButtons[otherButtons.count - 1 - i];
        CGRect rect = button.frame;
        //计算此button的位置
        rect.origin.y = (i * (CGRectGetHeight(rect) + self.SpaceDistance));
        button.frame = rect;
    }
}

#pragma -mark 收起
-(void)back {
    myImageView.alpha = 1;
    for (int i = 0;  i< otherButtons.count; i++) {
        UIButton *button = otherButtons[i];
        CGRect mainButtonFrame = self.mainButton.bounds;
        CGRect endFrame = CGRectMake(mainButtonFrame.origin.x, mainButtonFrame.origin.y - mainButtonFrame.size.height, mainButtonFrame.size.width, mainButtonFrame.size.height);
        button.frame = endFrame;
        button.hidden = YES;
    }
    self.mainButton.frame = self.mainButton.bounds;
    self.frame = rectFrame;
}

-(void)layoutAddViewBy:(UIView*)view {
    otherButtons = [[NSMutableArray alloc] init];
    //根据需要的按钮数量
    for (int i = 0; i < self.subButtonsTitle_Array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;  //根据主按钮的形状
        
        [button setImage:[[UIImage imageNamed:self.imagesArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                         forState:UIControlStateNormal];
        button.tintColor = SYSTEM_COLOR;

        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = CORNERRADIUS;
        
        
        button.hidden = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        
        button.tag = 1 + i;  //设置tag
        [button setTitle:self.subButtonsTitle_Array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:5];  //设置点击事件
        [view addSubview:button];
        [otherButtons addObject:button];  //并添加到数据按钮中
    }
}




@end
