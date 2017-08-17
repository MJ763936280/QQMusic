//
//  YJLrcView.h
//  QQ音乐
//
//  Created by 包宇津 on 16/6/21.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJLrcLabel;
@interface YJLrcView : UIScrollView
@property (nonatomic,copy) NSString *lrcName;
/**
 *  当前播放的时间
 */
@property (nonatomic,assign) NSTimeInterval currentTime;
/**
 *  当前播放歌词的下标值
 */
@property (nonatomic,assign) NSInteger currentIndex;

//外面歌词的label
@property (nonatomic,weak) YJLrcLabel *lrcLabel;
@property (nonatomic,assign) NSTimeInterval duration;
@end
