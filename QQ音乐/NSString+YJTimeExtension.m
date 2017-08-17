//
//  NSString+YJTimeExtension.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/20.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "NSString+YJTimeExtension.h"

@implementation NSString (YJTimeExtension)
+(NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger min=time/60;
    NSInteger sec=(NSInteger)time%60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}
@end
