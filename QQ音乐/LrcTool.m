//
//  LrcTool.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/24.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "LrcTool.h"
#import "YJLrcLine.h"
@implementation LrcTool
+(NSArray *)lrcToolWithLrcName:(NSString *)lrcName{
    //1.拿到歌词文件的路径
    NSString *lrcPath=[[NSBundle mainBundle]pathForResource:lrcName ofType:nil];
    //2.读取歌词
    NSString *lrcString=[NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    //3.拿到歌词的数组
    NSArray *lrcArray=[lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray=[NSMutableArray array];
    //4.遍历每一句歌词,转换成模型
    for(NSString *lrcLineString in lrcArray){
        //拿到每一句歌词
        //过滤不需要的歌词的行
        if([lrcLineString hasPrefix:@"[ti:"]||[lrcLineString hasPrefix:@"[ar:"]||[lrcLineString hasPrefix:@"[al:"]||![lrcLineString hasPrefix:@"["]){
            continue;
        }
        //将歌词转成模型
        YJLrcLine *lrcLine=[YJLrcLine lrcLineWithLrclineString:lrcLineString];
        [tempArray addObject:lrcLine];
    }
    for(YJLrcLine *line in tempArray){
        NSLog(@"text:%@ time:%.2f",line.text,line.time);
    }
    return tempArray;
}
@end
