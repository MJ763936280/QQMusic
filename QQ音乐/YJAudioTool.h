//
//  YJAudioTool.h
//  QQ音乐
//
//  Created by 包宇津 on 16/6/17.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface YJAudioTool : NSObject
+(void)playSoundWithName:(NSString *)soundName;
+(AVAudioPlayer *)playMusicWithName:(NSString *)musicName;
+(void)pauseMusicWithName:(NSString *)musicName;
+(void)stopMusicWithName:(NSString *)musicName;
@end
