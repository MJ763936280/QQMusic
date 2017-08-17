//
//  YJAudioTool.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/17.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJAudioTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation YJAudioTool
static NSMutableDictionary *_soundDict;
static NSMutableDictionary *_musicDict;
+(void)initialize{
    _soundDict=[NSMutableDictionary dictionary];
    _musicDict=[NSMutableDictionary dictionary];
}
+(AVAudioPlayer *)playMusicWithName:(NSString *)musicName{
    //1.判断传入的字符串是否为空
    assert(musicName);
    AVAudioPlayer *player=_musicDict[musicName];
    if(player==nil){
        NSURL *url=[[NSBundle mainBundle]URLForResource:musicName withExtension:nil];
        player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        [_musicDict setObject:player forKey:musicName];
    }
    [player prepareToPlay];
    [player play];
    return player;
}
+(void)pauseMusicWithName:(NSString *)musicName{
    assert(musicName);
    AVAudioPlayer *player=_musicDict[musicName];
    if(player&&player.isPlaying){
        [player pause];
    }
}
+(void)stopMusicWithName:(NSString *)musicName{
    assert(musicName);
    AVAudioPlayer *player=_musicDict[musicName];
    if(player){
        [player stop];
        [_musicDict removeObjectForKey:musicName];
        player=nil;
    }
}
+(void)playSoundWithName:(NSString *)soundName{
    SystemSoundID soundID=[_soundDict[soundName] unsignedIntValue];
    if(soundID==0){
        CFURLRef url=(__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:soundName withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &soundID);
        [_soundDict setObject:@(soundID) forKey:soundName];
    }
    AudioServicesPlaySystemSound(soundID);
}
@end
