//
//  CALayer+PauseAnimate.h
//  QQ音乐
//
//  Created by 包宇津 on 16/6/21.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PauseAnimate)
//暂停动画
-(void)pauseAnimate;
//恢复动画
-(void)resumeAnimate;
@end
