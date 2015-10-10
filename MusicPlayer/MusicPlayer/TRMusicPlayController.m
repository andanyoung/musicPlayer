//
//  TRMusicPlayController.m
//  MusicPlayer
//
//  Created by tarena on 15/9/16.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import "TRMusicPlayController.h"
#import "TRMusic.h"
#import "TRMusicManager.h"
#import "UIImage+Circle.h"
#import "UIView+Rotation.h"
#import "TRMusicPlayer.h"
#import "TRLrcView.h"

#define ROTATIONSPEED 10

@interface TRMusicPlayController () <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UISlider *playingProgressView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *singerImageView;

@property (weak, nonatomic) IBOutlet  TRLrcView *lrcView;
//
//
//
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
//
////当前正在播放的音乐
@property (strong, nonatomic)TRMusic *playingMusic;
////当前的播放器
@property (strong, nonatomic)AVAudioPlayer *player;
////歌词更新计时器
@property (strong, nonatomic)CADisplayLink *lrcTimer;
@end

@implementation TRMusicPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lrcView.hidden = YES;

}



- (UIVisualEffectView *)blurEffectView{
    if (!_blurEffectView) {
        UIBlurEffect *effect = [UIBlurEffect  effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    }
     _blurEffectView.frame = self.view.frame;
    return _blurEffectView;
}
- (void)show{
    
    
    //1. 拿Window对象
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //2. 将此VC中的View添加到Window对象中
    self.view.frame = window.bounds;
    //3. 设置背景和前景图片
    [self setBackAndSingerImage];
    //4. 加入到window视图中
    [window addSubview:self.view];
    //5. 在self.view的上面铺层毛玻璃(毛琉璃是个视图)
    [self.view insertSubview:self.blurEffectView atIndex:1];
    //6. 用动画的方式将View显示出来
    CGRect endFrame = self.view.frame;
    CGRect startFrame = endFrame;
    startFrame.origin.y = startFrame.size.height;
    self.view.frame = startFrame;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.frame = endFrame;
        //7. 让歌手图片旋转
        [self.singerImageView rotate:6];
        //8. 开始播放音乐
        [self startPlayMusic];
    }];
    
}



//开始播放音乐
- (void)startPlayMusic{
    //1. 如果要播放的歌正在播放，则直接返回
    if ([TRMusicManager playingMusic] == self.playingMusic) {
        return;
    }
    //2. 停止当前正在播放的音乐
    if (self.playingMusic) {
        [TRMusicPlayer stopMusic:self.playingMusic.name];
    }
    //3. 获取新的要播放的音乐
    self.playingMusic = [TRMusicManager playingMusic];
    //4. 播放音乐,将播放这首歌的播放器保存起来
     //self.player = [TRMusicPlayer playMusic:self.playingMusic.name];
    [self playingButtonTap:nil];
    //5. 转换播放按钮
    self.playButton.selected = YES;
    
    //6. 启动计时器控制播放进度条和时间标签的变化
    [self startPlayingTimer];
    
    if (!self.lrcView.hidden) {
        self.lrcView.lrcname = [TRMusicManager playingMusic].lrcname;
    }
    
    
}

#pragma mark - progess timer
//启动计时器
- (void)startPlayingTimer
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

//计时器每秒调用的方法
- (void)updateTimer:(NSTimer *)timer
{
    //1. 更新播放进度条
    //歌曲的总时间
    NSTimeInterval duration = self.player.duration;
    //当前的播放时间
    NSTimeInterval currentTime = self.player.currentTime;
    self.playingProgressView.value = currentTime * 1.0 / duration;
    //2. 更新播放当前时间标签
    self.rightTimeLabel.text = [self stringByTime:duration];
    self.leftTimeLabel.text = [self stringByTime:currentTime];
}

//将秒转换成xx:xx的时间字符串
- (NSString *)stringByTime:(NSTimeInterval)time
{
    int min = time / 60;
    int sec = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}

#pragma mark - 按钮事件
/**
 * 播放 /暂停 //播放按钮事件方法
 */
- (IBAction)playingButtonTap:(UIButton *)sender {
    
    if ([self.player isPlaying]) {
        sender.selected = NO;
        //当前按钮的状态时暂停
        [TRMusicPlayer pauseMusic:self.playingMusic.name];
        [self.singerImageView stopRotation];
        [self endLrcTimer];
    }else {
        self.player = [TRMusicPlayer playMusic:self.playingMusic.name];
        self.player.delegate = self;
        [self.singerImageView rotate:ROTATIONSPEED];
        sender.selected = YES;
        [self startLrcTimer];
    }
}

- (IBAction)nextButtonTap:(UIButton *)sender {
    //设置当前要播放的歌曲的下一首歌
    [TRMusicManager setPlayingMusic:[TRMusicManager nextMusic]];

    //重新设置背景和歌手图片
    [self setBackAndSingerImage];
    //开始播放
    [self startPlayMusic];
}

- (IBAction)preButtonTap:(UIButton *)sender {
    //设置当前要播放的歌曲的上一首歌
    [TRMusicManager setPlayingMusic:[TRMusicManager previousMusic]];
    
    //重新设置背景和歌手图片
    [self setBackAndSingerImage];
    //开始播放
    [self startPlayMusic];
}

/** 返回播放列表 */
- (IBAction)back:(UIButton *)sender {
    CGRect startFrame = self.view.frame;
    CGRect endFrame = startFrame;
    endFrame.origin.y = endFrame.size.height;
    self.view.frame = startFrame;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.frame = endFrame;
        [self.view removeFromSuperview];
    }];

}

#pragma mark - 滚动歌词
/** 显示歌词 */
- (IBAction)lrcButtonTap:(UIButton *)sender {
    if (self.lrcView.hidden) {
        //隐藏singer
        self.singerImageView.hidden = YES;
        //停止动画播放
        [self.singerImageView stopRotation];
        self.lrcView.hidden = NO;
        TRMusic *music = [TRMusicManager playingMusic];
        //设置歌词
        self.lrcView.lrcname = music.lrcname;
        [self startLrcTimer];
        
        self.blurEffectView.hidden = YES;
    }else {
        //隐藏singer
        self.singerImageView.hidden = NO;
        //停止动画播放
        [self.singerImageView rotate:ROTATIONSPEED];
        self.lrcView.hidden = YES;
        
        [self endLrcTimer];
        self.blurEffectView.hidden = NO;
        
    }
    
}

//开启歌词更新计时器
- (void)startLrcTimer
{
    //如果没有播放或歌词视图没有显示,不要启动歌词更新计时器
    if(self.player.playing == NO || self.lrcView.hidden){
        return;
    }
    //先结束,确保同一时间只有一个计时器在工作
    [self endLrcTimer];
    //创建计时器
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    //加入事件循环队列
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

//结束歌词更新计时器
- (void)endLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

- (void) updateLrc{
    self.lrcView.currentTime = self.player.currentTime;
}

//设置播放器的背景和前景图片
- (void)setBackAndSingerImage{
    //1.获取当前正在播放的歌曲
    TRMusic *music = [TRMusicManager playingMusic];
    //2.从歌曲对象中获取背景和前背景图片名
    NSString *backImageName = @"eason.jpg";
    NSString *singerImageName = @"eason.jpg";
    if (music) {
        backImageName = singerImageName = music.icon;
    }
    
    //设置背景
    self.backgroundImageView.image = [UIImage imageNamed:backImageName];
    //4.设置前景
    UIImage *image = [UIImage imageNamed:singerImageName];
    image = [UIImage scaleToSize:image size:self.singerImageView.frame.size];
    self.singerImageView.image = [UIImage circleImageWithImage:image borderWidth:5 borderColor:[UIColor grayColor]];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.blurEffectView.frame = self.view.frame;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self nextButtonTap:nil];
   
    [self startLrcTimer];
    
}

- (IBAction)changeValue:(UISlider *)sender {
    self.player.currentTime = sender.value * self.player.duration;
}

@end
