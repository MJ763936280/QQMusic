//
//  YJLrcView.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/21.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJLrcView.h"
#import "Masonry.h"
#import "LrcTool.h"
#import "YJLrcLine.h"
#import "YJLrcCell.h"
#import "YJLrcLabel.h"
#import "YJMusic.h"
#import "YJMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>

#import "YJTableView.h"
@interface YJLrcView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *lrcList;
@end
@implementation YJLrcView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self setupTableView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        [self setupTableView];
    }
    return self;
}
-(void)setupTableView{
    UITableView *tableView=[[UITableView alloc]init];
    tableView.backgroundView=nil;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=35;
    [self addSubview:tableView];
//    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.translatesAutoresizingMaskIntoConstraints=NO;
    tableView.dataSource=self;
    tableView.delegate=self;
    self.tableView=tableView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
    }];
    //设置tableView多出的滚动区域
    self.tableView.contentInset=UIEdgeInsetsMake(self.bounds.size.height*0.5, 0, self.bounds.size.height*0.5, 0);
    
}
#pragma mark -数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.创建Cell
    YJLrcCell *cell=[YJLrcCell lrcCellWithTableView:tableView];
    if(self.currentIndex==indexPath.row){
        cell.lrcLabel.font=[UIFont systemFontOfSize:20];
    }else{
        cell.lrcLabel.font=[UIFont systemFontOfSize:14.0];
        cell.lrcLabel.progress=0;
    }
    //2.给cell设置数据
    //2.1取出数据
    YJLrcLine *lrcLine=self.lrcList[indexPath.row];
    //2.2给cell设置数据
    cell.lrcLabel.text=lrcLine.text;
    return cell;
}
#pragma mark -重写setLrcName方法
-(void)setLrcName:(NSString *)lrcName{
    self.currentIndex=0;
    //1.保存歌词名称
    _lrcName=[lrcName copy];
    //2.解析歌词
    self.lrcList=[LrcTool lrcToolWithLrcName:lrcName];
    //3.刷新表格
    [self.tableView reloadData];
}
-(void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime=currentTime;
    //用当前时间和歌词进行匹配
    NSInteger count=self.lrcList.count;
    for(int i=0;i<count;i++){
        //1.拿到i位置的歌词
        YJLrcLine *currentLrcLine=self.lrcList[i];
        //2.拿到下一句的歌词
        NSInteger nextLrcIndex=i+1;
        YJLrcLine *nextLrcLine=nil;
        if(nextLrcIndex<count){
            nextLrcLine=self.lrcList[nextLrcIndex];
        }
        //3.用当前的时间和i位置的歌词进行比较，并且和下一句进行比较。如果大于等于i位置的时间，并且小于下一句歌词的时间，那么显示当前的歌词
        if(self.currentIndex!=i && currentTime>=currentLrcLine.time && currentTime<nextLrcLine.time){
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath=[NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            //显示对应的歌词
            
            self.currentIndex=i;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.lrcLabel.text=currentLrcLine.text;
            //生成锁屏界面的图片
            [self generateLockImage];
            
        }
        //根据进度，显示label画多少
        if(self.currentIndex==i){
            //拿到i位置的cell
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            YJLrcCell *cell=(YJLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            //更新label的进度
            CGFloat progress=(currentTime-currentLrcLine.time)/(nextLrcLine.time-currentLrcLine.time);
            cell.lrcLabel.progress=progress;
            self.lrcLabel.progress=progress;
        }
    }
}
-(void)generateLockImage{
    //1.拿到当前歌曲的图片
    YJMusic *playingMusic=[YJMusicTool playingMusic];
    UIImage *currentImage=[UIImage imageNamed:playingMusic.icon];
    /*
     2.拿到三句歌词
     */
    //2.1拿到当前歌词
    YJLrcLine *currentLrc=self.lrcList[self.currentIndex];
    //2.2拿到上一句歌词
    YJLrcLine *previousLrc=nil;
    NSInteger previousIndex=self.currentIndex-1;
    if(previousIndex>=0){
        previousLrc=self.lrcList[previousIndex];
    }
    //2.3拿到下一句歌词
    YJLrcLine *nextLrc=nil;
    NSInteger nextIndex=self.currentIndex+1;
    if(nextIndex<self.lrcList){
        nextLrc=self.lrcList[nextIndex];
    }
    //3.生成水印图片
    UIGraphicsBeginImageContext(currentImage.size);
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    CGFloat titleH=35;
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];
    style.alignment=NSTextAlignmentCenter;
    NSDictionary *attributes1=@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                NSParagraphStyleAttributeName:style
                                };
    [previousLrc.text drawInRect:CGRectMake(0, currentImage.size.height-titleH*3, currentImage.size.width, titleH)withAttributes:attributes1];
    [nextLrc.text drawInRect:CGRectMake(0, currentImage.size.height-titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    NSDictionary *attributes2=@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSParagraphStyleAttributeName:style
                                };
    [currentLrc.text drawInRect:CGRectMake(0, currentImage.size.height-2*titleH, currentImage.size.width, titleH) withAttributes:attributes2];
    //4.生成图片
    UIImage *lockImage=UIGraphicsGetImageFromCurrentImageContext();
    [self setupLockScreenInfoWithLockImage:lockImage];
    
}
#pragma mark- 设置锁屏界面的信息
-(void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage{
    //1.获取当前正在播放的歌曲
    YJMusic *playingMusic=[YJMusicTool playingMusic];
    //2.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter=[MPNowPlayingInfoCenter defaultCenter];
    //2.设置显示的信息
    NSMutableDictionary *playingInfo=[NSMutableDictionary dictionary];
    [playingInfo setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfo setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    MPMediaItemArtwork *artWork=[[MPMediaItemArtwork alloc]initWithImage:lockImage];
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [playingInfo setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [playingInfo setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    playingInfoCenter.nowPlayingInfo=playingInfo;
    //3.让应用程序可以接受远程事件
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
}

@end
