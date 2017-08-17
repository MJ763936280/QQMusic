//
//  YJPlayingViewController.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/19.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJPlayingViewController.h"
#import "Masonry.h"
#import "YJMusic.h"
#import "YJMusicTool.h"
#import "YJAudioTool.h"
#import "NSString+YJTimeExtension.h"
#import "CALayer+PauseAnimate.h"
#import "YJLrcView.h"
#import "YJLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>
@interface YJPlayingViewController () <UIScrollViewDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *albumView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet YJLrcLabel *lrcLabel;
//当前的播放器
@property (nonatomic,strong) AVAudioPlayer *currentPlayer;
//定时器
@property (nonatomic,strong) NSTimer *progressTimer;
@property (weak, nonatomic) IBOutlet YJLrcView *lrcView;

@property (weak, nonatomic) IBOutlet UIButton *playOrpauseBtn;
//实时时间
@property (nonatomic,strong) CADisplayLink *lrcTimer;
#pragma mark -slider的事件处理
- (IBAction)startSlide;
- (IBAction)slideVlaueChange;
- (IBAction)endSlide;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;
#pragma  mark -按钮事件处理
- (IBAction)playOrpause;
- (IBAction)previous;
- (IBAction)next;

@end

@implementation YJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.添加毛玻璃效果
    [self setupBlurView];
    //2.设置滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    //3.展示界面的信息
    [self startPlayingMusic];
    //4.设置lrcView的ContentSize
    self.lrcView.contentSize=CGSizeMake(self.view.bounds.size.width*2, 0);
    self.lrcView.lrcLabel=self.lrcLabel;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //3.设置iconView圆角
    self.iconView.layer.cornerRadius=self.iconView.bounds.size.width*0.5;
    self.iconView.layer.masksToBounds=YES;
    self.iconView.layer.borderWidth=8.0;
    self.iconView.layer.borderColor=[UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0].CGColor;
    
}
-(void)setupBlurView{
    UIToolbar *toolBar=[[UIToolbar alloc]init];
    [toolBar setBarStyle:UIBarStyleBlack];
    [self.albumView addSubview:toolBar];
    toolBar.translatesAutoresizingMaskIntoConstraints=NO;
    
#pragma mark--- 用代码实现约束
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.albumView.mas_top);
        make.bottom.mas_equalTo(self.albumView.mas_bottom);
        make.left.mas_equalTo(self.albumView.mas_left);
        make.right.mas_equalTo(self.albumView.mas_right);
    }];
    
}
#pragma mark -开始播放音乐
-(void)startPlayingMusic{
    //1.取出当前播放音乐
    YJMusic *playingMusic=[YJMusicTool playingMusic];
    //2.设置界面信息
    self.albumView.image=[UIImage imageNamed:playingMusic.icon];
    self.iconView.image=[UIImage imageNamed:playingMusic.icon];
    self.songLabel.text=playingMusic.name;
    self.singerLabel.text=playingMusic.singer;
    //3.开始播放歌曲
    AVAudioPlayer *player=[YJAudioTool playMusicWithName:playingMusic.filename];
    self.currentPlayer=player;
    self.currentPlayer.delegate=self;
    self.playOrpauseBtn.selected=self.currentPlayer.isPlaying;
    self.currentTimeLabel.text=[NSString stringWithTime:player.currentTime];
    self.totalTimeLabel.text=[NSString stringWithTime:player.duration];
    
    //设置歌词
    self.lrcView.lrcName=playingMusic.lrcname;
    self.lrcView.duration=_currentPlayer.duration;
    //4.开始播放动画IconView旋转
    [self startIconViewAnimate];
    //5.添加定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];
    
    
    //设置锁屏界面的信息
    [self setupLockScreenInfo];
}
-(void)startIconViewAnimate{
    //1.创建基本动画
    CABasicAnimation *rotateAnim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //2.设置动画基本属性
    rotateAnim.fromValue=@(0);
    rotateAnim.toValue=@(M_PI*2);
    rotateAnim.repeatCount=NSIntegerMax;
    rotateAnim.duration=40;
    //3.将动画参加到图层上
    [self.iconView.layer addAnimation:rotateAnim forKey:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -定时器操作
-(void)addProgressTimer{
    [self updateProgressInfo];
    self.progressTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
-(void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer=nil;
}

-(void)addLrcTimer{
    self.lrcTimer=[CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)removeLrcTimer{
    [self.lrcTimer invalidate];
    self.lrcTimer=nil;
}
#pragma  -mark 更新歌词
-(void)updateLrc{
    self.lrcView.currentTime=self.currentPlayer.currentTime;
}
#pragma mark-更新进度的界面
-(void)updateProgressInfo{
    //设置当前播放的时间
    self.currentTimeLabel.text=[NSString stringWithTime:self.currentPlayer.currentTime];
    //更新滑块的位置
    self.progressSlider.value=self.currentPlayer.currentTime/self.currentPlayer.duration;
}
#pragma mark -Slider的事件处理
- (IBAction)startSlide {
    [self removeProgressTimer];
}

- (IBAction)slideVlaueChange {
    //设置当前播放时间Label
    self.currentTimeLabel.text=[NSString stringWithTime:self.currentPlayer.duration*self.progressSlider.value];
}

- (IBAction)endSlide {
    //1.设置歌曲的播放事件
    self.currentPlayer.currentTime=self.currentPlayer.duration*self.progressSlider.value;
    //2.添加定时器
    [self addProgressTimer];
}

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    //1.获取点击的位置
    CGPoint point=[sender locationInView:sender.view];
    //2.获取点击位置比例
    CGFloat ratio=point.x/self.progressSlider.bounds.size.width;
    //3.改变滑块的位置
    self.progressSlider.value=ratio;
    //4.改变歌曲播放
    self.currentPlayer.currentTime=self.currentPlayer.duration*ratio;
    [self updateProgressInfo];
}
- (IBAction)playOrpause {
    self.playOrpauseBtn.selected=!self.playOrpauseBtn.selected;
    if(self.currentPlayer.isPlaying){
        [self.currentPlayer pause];
        [self removeProgressTimer];
        [self.iconView.layer pauseAnimate];
    }else{
        [self.currentPlayer play];
        [self addProgressTimer];
        [self.iconView.layer resumeAnimate];
    }
}

- (IBAction)previous {
    //1.停止当前歌曲
    YJMusic *music=[YJMusicTool playingMusic];
    [YJAudioTool stopMusicWithName:music.filename];
    //2.获取上一首歌曲
    YJMusic *previousMusic=[YJMusicTool previousMusic];
    //3.播放上一首
    [YJAudioTool playMusicWithName:previousMusic.filename];
    //4.界面更新
    [YJMusicTool setPlayingMusic:previousMusic];
    [self startPlayingMusic];
}

- (IBAction)next {
    //1.停止当前歌曲
    YJMusic *music=[YJMusicTool playingMusic];
    [YJAudioTool stopMusicWithName:music.filename];
    
    //2.获取下一首歌曲
    YJMusic *nextMusic=[YJMusicTool nextMusic];
    //3.播放下一首
    [YJAudioTool playMusicWithName:nextMusic.filename];
    //4.更新界面
    [YJMusicTool setPlayingMusic:nextMusic];
    [self startPlayingMusic];
}
#pragma mark -实现UIScrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //1.获取到滑动多少
    CGPoint point=scrollView.contentOffset;
    //2.计算滑动的比例
    CGFloat ratio=1-point.x/scrollView.bounds.size.width;
    //3.设置iconView和歌词Label的透明度
    self.iconView.alpha=ratio;
    self.lrcLabel.alpha=ratio;
}
#pragma mark- 设置锁屏界面的信息
-(void)setupLockScreenInfo{
    //1.获取当前正在播放的歌曲
    YJMusic *playingMusic=[YJMusicTool playingMusic];
    //2.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter=[MPNowPlayingInfoCenter defaultCenter];
    //2.设置显示的信息
    NSMutableDictionary *playingInfo=[NSMutableDictionary dictionary];
    [playingInfo setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfo setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    MPMediaItemArtwork *artWork=[[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:playingMusic.icon]];
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [playingInfo setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    playingInfoCenter.nowPlayingInfo=playingInfo;
    //3.让应用程序可以接受远程事件
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
}
//监听远程事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrpause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
        default:
            break;
    }
}
#pragma mark- currentPlayer的代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(flag){
        [self next];
    }
}
@end
