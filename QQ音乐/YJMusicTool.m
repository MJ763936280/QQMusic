//
//  YJMusicTool.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/19.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJMusicTool.h"
#import "YJMusic.h"
#import "MJExtension.h"
@implementation YJMusicTool
static NSArray *_musics;
static YJMusic *_playingMusic;
+(void)initialize{
    _musics=[YJMusic objectArrayWithFilename:@"Musics.plist"];
    _playingMusic=_musics[1];
}
+(NSArray *)musics{
    return _musics;
}
+(YJMusic *)playingMusic{
    return _playingMusic;
}
+(void)setPlayingMusic:(YJMusic *)playingMusic{
    _playingMusic=playingMusic;
}
+(YJMusic *)nextMusic{
    //1.拿到当前播放歌曲下标值
    NSInteger currentIndex=[_musics indexOfObject:_playingMusic];
    //2.取出下一首
    NSInteger nextIndex=++currentIndex;
    if(nextIndex>=_musics.count){
        nextIndex=0;
    }
    YJMusic *nextMusic=_musics[nextIndex];
    return nextMusic;
}
+(YJMusic *)previousMusic{
    NSInteger currentIndex=[_musics indexOfObject:_playingMusic];
    NSInteger previousIndex=--currentIndex;
    if(previousIndex<=0){
        previousIndex=_musics.count-1;
    }
    YJMusic *previousMusic=_musics[previousIndex];
    return previousMusic;
}
@end
