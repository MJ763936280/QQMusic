//
//  CALayer+PauseAnimate.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/21.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "CALayer+PauseAnimate.h"

@implementation CALayer (PauseAnimate)
-(void)pauseAnimate{
    CFTimeInterval pausedTime=[self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed=0.0;
    self.timeOffset=pausedTime;
}
-(void)resumeAnimate{
    CFTimeInterval pausedTime=[self timeOffset];
    self.speed=1.0;
    self.timeOffset=0.0;
    self.beginTime=0.0;
    CFTimeInterval timeSincePause=[self convertTime:CACurrentMediaTime() fromLayer:nil]-pausedTime;
    self.beginTime=timeSincePause;
}
@end
