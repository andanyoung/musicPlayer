//
//  TRMusicPlayer.h
//  Demo3_MyPlayer
//
//  Created by tarena on 15-6-16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TRMusicPlayer : NSObject
/**
 * 播放音乐
 * @param filename 音乐文件名
 * @return 播放是否成功
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename;

/**
 * 暂停播放
 * @param filename 音乐文件名
 */
+ (void)pauseMusic:(NSString *)filename;

/**
 * 停止播放
 * @param filename 音乐文件名
 */
+ (void)stopMusic:(NSString *)filename;

@end





