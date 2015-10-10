//
//  TRMusicCell.m
//  MusicPlayer
//
//  Created by tarena on 15/9/16.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import "TRMusicCell.h"
#import "TRMusic.h"
#import "UIImage+Circle.h"

@implementation TRMusicCell

- (void)awakeFromNib {
}

- (void)setMusic:(TRMusic *)music{
    _music = music;
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
    UIImage *image = [UIImage imageNamed:music.icon];
    image = [UIImage scaleToSize:image size:CGSizeMake(self.bounds.size.height - 10, self.bounds.size.height - 10)];
    self.imageView.image = [UIImage circleImageWithImage:image borderWidth:5 borderColor:[UIColor greenColor]];
}


@end
