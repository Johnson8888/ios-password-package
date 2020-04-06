//
//  GFGroupButtonView.m
//  TestMap
//
//  Created by chenshyiuan on 2017/2/25.
//  Copyright © 2017年 chenshyiuan. All rights reserved.
//

#import "CSYGroupButtonView.h"


static const int fontSize = 10.0;

@interface CSYGroupButtonView()
{
    NSMutableArray *otherButtons;
    CGRect rectFrame;
    UIImageView *myImageView;
}


@end

@implementation CSYGroupButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame mainButtonTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle otherButtonsTitle:(NSArray<NSString *> *)subButtonsTitle_Array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        rectFrame = frame;
        //        self.backgroundColor = [UIColor redColor];
        
        self.unSelectedTitle = title;   //没被选择的显示按钮
        self.selectedTitle = selectedTitle;  //被选择之后显示的按钮
        self.subButtonsTitle_Array = subButtonsTitle_Array;  //其他要显示的按钮的标题
        self.SpaceDistance = 0;  //设置间距
        [self layoutAddViewBy:self];
        
        UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [mainBtn setBackgroundColor:[UIColor blackColor]];
        [mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mainBtn setBackgroundColor:[UIColor whiteColor]];
        mainBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];

        mainBtn.frame = self.bounds;
        mainBtn.tag = 0;
        //        [mainBtn setBackgroundImage:[UIImage imageNamed:imag] forState:0];
        [mainBtn setTitle:title forState:UIControlStateNormal];  //设置标题
        
        //        mainBtn.layer.cornerRadius = CGRectGetWidth(frame)/2;
        //        self.layer.cornerRadius = CGRectGetWidth(frame)/2;
        //        self.clipsToBounds = YES;
        [mainBtn addTarget:self action:@selector(buttonClick:) forControlEvents:5];
        
        
        [mainBtn.layer setBorderWidth:1.0];  //设置边框大小
        [mainBtn.layer setBorderColor:[UIColor blackColor].CGColor];  //设置边框颜色
        
        
        mainBtn.selected = NO;  //设置未被选择
        [self addSubview:mainBtn];
        self.mainButton = mainBtn;
    }
    return self;
}

#pragma -mark 按钮点击事件
-(void)buttonClick:(UIButton*)button
{
    [self setAnimation];
    if (button.tag == 0) {
        NSString * string = button.selected == NO ? self.unSelectedTitle : self.selectedTitle;
        //        [button setBackgroundImage:[UIImage imageNamed:string] forState:0];
        [button setTitle:string forState:UIControlStateNormal];
    } else {
        
        for (UIButton* btn in otherButtons)
        {
            btn.selected = NO;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        
        button.selected = YES;
//        [button setBackgroundColor:[UIColor orangeColor]];
        for (UIButton* btn in otherButtons)
        {
            if(btn.selected == YES)
               [btn setBackgroundColor:[UIColor orangeColor]];
        }
    }
    
    
    
    if (self.ButtonClickBlock) {
        self.ButtonClickBlock(button);
    }
    
    
}

#pragma -mark  设置动画
-(void)setAnimation
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        //如果已经被选择则收回 否则则移除
        self.mainButton.selected == YES ? [self back]:[self move];
    } completion:^(BOOL finished) {
        
    }];
    self.mainButton.selected = !self.mainButton.selected;
}
#pragma -mark 弹出
-(void)move
{
 
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
    for (int i = 0; i < otherButtons.count; i++)
    {
        //获得button
        UIButton *button = otherButtons[otherButtons.count - 1 - i];
        CGRect rect = button.frame;
        //计算此button的位置
        rect.origin.y = (i * (CGRectGetHeight(rect) + self.SpaceDistance));
        button.frame = rect;
    }
    
}
#pragma -mark 收起
-(void)back
{
    myImageView.alpha = 1;
    
    for (int i = 0;  i< otherButtons.count; i++) {
        UIButton *button = otherButtons[i];
        button.frame = self.mainButton.bounds;
    }
    self.mainButton.frame = self.mainButton.bounds;
    self.frame = rectFrame;
}

-(void)layoutAddViewBy:(UIView*)view
{
    otherButtons = [[NSMutableArray alloc] init];
    //根据需要的按钮数量
    for (int i = 0; i < self.subButtonsTitle_Array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;  //根据主按钮的形状
//        [button setBackgroundColor:[UIColor blackColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.layer setBorderWidth:1.0];  //设置边框大小
        [button.layer setBorderColor:[UIColor blackColor].CGColor];  //设置边框颜色
//        [button setBackgroundImage:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.tag = 1 + i;  //设置tag
        [button setTitle:self.subButtonsTitle_Array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:5];  //设置点击事件
        [view addSubview:button];
        [otherButtons addObject:button];  //并添加到数据按钮中
    }
}




@end
