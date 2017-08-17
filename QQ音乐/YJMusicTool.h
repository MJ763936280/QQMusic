//
//  YJMusicTool.h
//  QQ音乐
//
//  Created by 包宇津 on 16/6/19.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJMusic.h"
@interface YJMusicTool : NSObject
+(NSArray *)musics;
+(YJMusic *)playingMusic;
+(void)setPlayingMusic:(YJMusic *)playingMusic;
+(YJMusic *)nextMusic;
+(YJMusic *)previousMusic;
@end
