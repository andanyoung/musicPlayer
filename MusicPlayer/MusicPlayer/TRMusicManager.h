//
//  TRMusicManager.h
//  MusicPlayer
//
//  Created by tarena on 15-6-16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMusic.h"

@interface TRMusicManager : NSObject
//返回所有要播放的音乐
+ (NSArray *)musics;
//返回正在播放的音乐
+ (TRMusic *)playingMusic;
//设置当前需要播放的音乐
+ (void)setPlayingMusic:(TRMusic *)playingMusic;
//返回上一首歌曲
+ (TRMusic *)previousMusic;
//返回下一首歌曲
+ (TRMusic *)nextMusic;

@end
