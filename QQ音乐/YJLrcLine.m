//
//  YJLrcLine.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/24.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJLrcLine.h"

@implementation YJLrcLine
-(instancetype)initWithLrclineString:(NSString *)lrclineString{
    if(self=[super init]){
        NSArray *lrcArray=[lrclineString componentsSeparatedByString:@"]"];
        //截取歌词
        self.text=lrcArray[1];
        //截取时间
        NSString *timeString=lrcArray[0];
        self.time=[self timeStringWithString:[timeString substringFromIndex:1]];
    }
    return self;
}
+(instancetype)lrcLineWithLrclineString:(NSString *)lrclineString{
    return [[self alloc]initWithLrclineString:lrclineString];
}
#pragma  mark-私有方法
-(NSTimeInterval)timeStringWithString:(NSString *)timeString{
    NSInteger min=[[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec=[[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger haomiao=[[timeString componentsSeparatedByString:@"."][1] integerValue];
    return min*60+sec+haomiao*0.01;
}
@end
