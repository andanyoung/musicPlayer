//
//  TRMusicManager.m
//  MusicPlayer
//
//  Created by tarena on 15-6-16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRMusicManager.h"
#import "TRMusic.h"


//保存所有的歌曲
static NSArray *_musics = nil;//歌曲库
//当前正在播放的歌曲
static TRMusic *_playingMusic = nil;

@implementation TRMusicManager
//返回正在播放的音乐
+ (TRMusic *)playingMusic
{
    return _playingMusic;
}
//设置当前需要播放的音乐
+ (void)setPlayingMusic:(TRMusic *)playingMusic
{
    //如果设置的歌曲不在歌曲库中,无法播放,直接返回
    if(!playingMusic || ![_musics containsObject:playingMusic]){
        return;
    }
    _playingMusic = playingMusic;
}
//返回上一首歌曲
+ (TRMusic *)previousMusic
{
    NSInteger index = 0;
    if(_playingMusic){
        index = [_musics indexOfObject:_playingMusic];
        index--;
        if (index<0) {
            index = _musics.count - 1;
        }
    }
    return _musics[index];
}
//返回下一首歌曲
+ (TRMusic *)nextMusic
{
    NSInteger index = 0;
    if(_playingMusic){
        index = [_musics indexOfObject:_playingMusic];
        index++;
        if (index>=_musics.count) {
            index = 0;
        }
    }
    return _musics[index];
}


//读取plist文件,返回所有的歌曲
+ (NSArray *)musics
{
    if (!_musics) {
        _musics = [self musicsFromPlist:@"Musics.plist"];
    }
    return _musics;
}

+ (NSArray *)musicsFromPlist:(NSString *)plist
{
    NSURL *url = [[NSBundle mainBundle]URLForResource:plist withExtension:nil];
    NSArray *objs = [NSArray arrayWithContentsOfURL:url];
    NSMutableArray *musics = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in objs) {
        TRMusic *music = [[TRMusic alloc]init];
        [music setValuesForKeysWithDictionary:dict];
        [musics addObject:music];
    }
    return [musics copy];
}


@end





