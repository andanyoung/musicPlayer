//
//  TRLrcView.m
//  MusicPlayer
//
//  Created by tarena on 15/9/17.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import "TRLrcView.h"
#import "TRLrcLine.h"

@interface TRLrcView () <UITableViewDataSource>
//用于显示歌词
@property (nonatomic, strong)UITableView *tableView;
//保存歌词的数组，每一行歌词是一个数组中的元素
@property (nonatomic, strong)NSMutableArray *lrcLines;

@property (nonatomic)int currentIndex;

@end

@implementation TRLrcView

//歌词文件
- (void)setLrcname:(NSString *)lrcname{
    
    _lrcname = lrcname;
    //解析歌词文件，分解成一个个的可望的航行对象（TRLrclines）。保存到数组中
    NSURL *url = [[NSBundle mainBundle]URLForResource:lrcname withExtension:nil];
    // 将文件内容全部读入到字符串lrcString 中
    NSString *lrcString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    // 使用\n 分解字符串成每一行的字符串数组
    NSArray *lrcs = [lrcString componentsSeparatedByString:@"\n"];
    
    NSLog(@"歌词%@",lrcs);
    
    NSMutableArray *lrcLines = [NSMutableArray array];
    // 遍历数组
    for (NSString *line in lrcs) {
        //1. 创建一个歌词行对象
        TRLrcLine *lrcLine = [TRLrcLine new];
        //2. 将歌词行对象放入数组保存
       
        [lrcLines addObject:lrcLine];
        //3. 给歌词行对象的time和words属性赋值
        if (![line hasPrefix:@"["])continue;
        if ([line hasPrefix:@"[ti:"] || [line hasPrefix:@"[ar:"] ||[line hasPrefix:@"[t_time:"] ||[line hasPrefix:@"[al:"] ){
            NSString *word = [[line componentsSeparatedByString:@":"]lastObject];
            lrcLine.words = [word substringToIndex: word.length-2 ];
            NSLog(@"word:%@",word);
        }else{
            NSArray *arry = [line componentsSeparatedByString:@"]"];
            lrcLine.words = [arry lastObject];
            lrcLine.time = [[arry firstObject]substringFromIndex:1];
        }
        
    }
    
    self.lrcLines = lrcLines;
    //5. 重新加载TableView
    [self.tableView reloadData];
    
}

/** 滚动歌词*/
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;
    //滚动TableView

    //当前歌曲的播放时间和歌词中的播放时间对比
    //1. 播放歌曲的时间转成字符串
    int min = currentTime / 60;//分
    int sec = (int)currentTime % 60;//秒
    int msec = (currentTime - (int)currentTime) * 100;//毫秒
    NSString *currentTimerStr = [NSString stringWithFormat:@"%02d:%02d.%02d",min,sec,msec];
    for (int idx = 0; idx < self.lrcLines.count -1; idx++) {
        //歌词中的一行
        TRLrcLine *lrcLine = self.lrcLines[idx];
        //歌词中的这一行
        NSString *lineTime = lrcLine.time;
        //歌词中的下一行
        NSString *nextLineTime = ((TRLrcLine *)self.lrcLines[idx + 1]).time;
        //判断这一行是否是正在播放的那一行
        //当前时间要在 这一行和下一行之间
        
        NSLog(@"currentIndex:%d",self.currentIndex);
        if ([currentTimerStr compare:lineTime] != NSOrderedAscending &&
            [currentTimerStr compare:nextLineTime] == NSOrderedAscending  && self.currentIndex != idx) {
            
            //正在播放的歌词找到啦
            NSLog(@"正在播放:%@,%@", lrcLine.time, lrcLine.words);
            
            //找到正在播放的歌词
            if (idx>0) {
                //将上一行恢复颜色
                NSIndexPath *path = [NSIndexPath indexPathForRow:idx-1 inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
                cell.textLabel.textColor = [UIColor greenColor];
            }

            NSIndexPath *currentPath = [NSIndexPath indexPathForRow:idx inSection:0];
            UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:currentPath];
            currentCell.textLabel.textColor = [UIColor redColor];
            
            [self.tableView scrollToRowAtIndexPath:currentPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.currentIndex = idx;
            return;
        }
    }
}

#pragma mark - 初始化方法
//用手动创建视图对象是调用此方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

//使用故事板或xib创建视图对象是调用此方法
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializer];
    }
    return self;
}

//从Storyboard中恢复视图时调用
//- (void)awakeFromNib
//{
//
//}

- (void)initializer{
    //创建歌词库数组
    self.lrcLines = [[NSMutableArray alloc]init];
    //创建显示歌词的TableView
    self.tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    //设置tableView的外观
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置数据源
    self.tableView.dataSource = self;
    //显示TableView
    [self addSubview:self.tableView];
    //注册Cell类,以备从队列中dequeue出
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LrcCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcLines.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LrcCell"];
    TRLrcLine *lrcLine = self.lrcLines[indexPath.row];
    cell.textLabel.text = lrcLine.words;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor greenColor];
    
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height * 0.5, 0, self.tableView.frame.size.height * 0.5, 0);
}

@end
