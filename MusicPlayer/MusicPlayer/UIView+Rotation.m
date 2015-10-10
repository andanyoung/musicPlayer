//
//  UIImage+Rotation.m
//  MusicPlayer
//
//  Created by tarena on 15-6-18.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIView+Rotation.h"

@implementation UIView (Rotation)
- (void)rotate:(NSTimeInterval)duration
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = 2147483647;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:rotationAnimation forKey:@"UIViewRotation"];
}

//停止旋转动画
- (void)stopRotation
{
    [self.layer removeAnimationForKey:@"UIViewRotation"];
}


@end
