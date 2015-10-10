//
//  TRLrcView.h
//  MusicPlayer
//
//  Created by tarena on 15/9/17.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRLrcView : UIView
//歌词文件的文件名
@property (strong, nonatomic)NSString *lrcname;
//当前正在播放的时间点
@property (assign, nonatomic)NSTimeInterval currentTime;
@end
