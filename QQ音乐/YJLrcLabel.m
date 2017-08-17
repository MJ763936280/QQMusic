//
//  YJLrcLabel.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/29.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJLrcLabel.h"

@implementation YJLrcLabel
-(void)setProgress:(CGFloat)progress{
    _progress=progress;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //1.设置需要画的区域
    CGRect fillRect=CGRectMake(0, 0, self.bounds.size.width*self.progress, self.bounds.size.height);
    //2.设置颜色
    [[UIColor greenColor]set];
    //3.添加区域
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
