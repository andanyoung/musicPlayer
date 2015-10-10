//
//  UIImage+Rotation.h
//  MusicPlayer
//
//  Created by tarena on 15-6-18.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rotation)
//让当前视图顺时针不断旋转
- (void)rotate:(NSTimeInterval)duration;
//停止旋转动画
- (void)stopRotation;

@end
