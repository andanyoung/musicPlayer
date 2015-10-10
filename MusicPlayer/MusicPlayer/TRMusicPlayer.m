//
//  TRMusicPlayer.m
//  Demo3_MyPlayer
//
//  Created by tarena on 15-6-16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRMusicPlayer.h"

@import AVFoundation;
#import "TRMusicManager.h"
//播放器池
static NSMutableDictionary *_musicPlayers;

@interface TRMusicPlayer ()

@end
@implementation TRMusicPlayer
//当类被加载内存中执行
+ (void)initialize
{
    _musicPlayers = [[NSMutableDictionary alloc]init];
}


+ (AVAudioPlayer *)playMusic:(NSString *)filename
{
    if (!filename) return nil;
    //1. 从字典中取出播放器
    AVAudioPlayer *player = _musicPlayers[filename];
    if (player == nil) {
        //2. 取不到则创建播放器
        NSURL *url = [[NSBundle mainBundle]URLForResource:filename withExtension:@"mp3"];
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        //3. 缓冲
        if(![player prepareToPlay]) return nil;
        //4. 放入字典中
        _musicPlayers[filename] = player;
    }
    //5. 播放
    if (![player isPlaying]) {
       [player play];
    }
    return player;
}

+ (void)pauseMusic:(NSString *)filename
{
    if (!filename) {
        return;
    }
    AVAudioPlayer *player = _musicPlayers[filename];
    if (player) {
        [player pause];
    }
}

+ (void)stopMusic:(NSString *)filename
{
    if (!filename) return;
    AVAudioPlayer *player = _musicPlayers[filename];
    if (player) {
        [player stop];
        //将停止播放的播放器从缓冲区中删除(此时播放对象会被销毁)
        [_musicPlayers removeObjectForKey:filename];
    }
}

@end




