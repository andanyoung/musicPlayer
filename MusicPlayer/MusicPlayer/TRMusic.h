//
//  TRMusic.h
//  MusicPlayer
//
//  Created by tarena on 15/9/16.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMusic : NSObject
/** 歌曲名 */
@property (nonatomic, strong)NSString *name;
/** 歌曲文件名 */
@property (nonatomic, strong)NSString *filename;
/** 歌词文件名 */
@property (nonatomic, strong)NSString *lrcname;
/** 歌手 */
@property (nonatomic, strong)NSString *singer;
/** 歌手图片 */
@property (nonatomic, strong)NSString *singerIcon;
/** 歌曲图标 */
@property (nonatomic, strong)NSString *icon;
@end
