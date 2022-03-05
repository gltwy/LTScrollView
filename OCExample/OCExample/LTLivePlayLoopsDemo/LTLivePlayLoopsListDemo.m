//
//  LTLivePlayLoopsListDemo.m
//  OCExample
//
//  Created by gaoliutong on 2022/3/5.
//  Copyright © 2022 LT. All rights reserved.
//
//  如有疑问，请搜索并关注微信公众号"技术大咖社"并留言即可
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

#import "LTLivePlayLoopsListDemo.h"
#import "LTScrollView-Swift.h"
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)

@interface LTLivePlayLoopsListDemo ()<LTLivePlayLoopsListDelegate, LTLivePlayLoopsListDataSource>
@property(strong, nonatomic) LTLivePlayLoopsListView *playListView;
@property(strong, nonatomic) UIButton *contentView;
@property(strong, nonatomic) NSArray *dataSource;
@end

@implementation LTLivePlayLoopsListDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.playListView];

    self.dataSource = @[@"1", @"2", @"3", @"4", @"5"];
    
    self.playListView.currentIndex = 2;
    [self.playListView reloadData];
    
    /**
     self.playListView.currentIndex = 2;
     [self.playListView reloadData];
     等价
     [self.playListView reloadData];
     [self.playListView scrollToIndex:2];
     */
}

- (void)prefetchWithLivePlayView:(LTLivePlayLoopsListView *)livePlayView inView:(UIView *)inView index:(NSInteger)index {
    NSLog(@"预加载 - %@", self.dataSource[index]);
    UILabel *contentLabel = (UILabel *)inView;
    contentLabel.text = [NSString stringWithFormat:@"第%@个item(此处可放置预览视图)", self.dataSource[index]];
    contentLabel.font = [UIFont systemFontOfSize:24];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.backgroundColor = [UIColor greenColor];
}

- (void)didSelectWithLivePlayView:(LTLivePlayLoopsListView *)livePlayView inView:(UIView *)inView index:(NSInteger)index {
    NSLog(@"当前加载 - %@", self.dataSource[index]);
    [inView addSubview:self.contentView];
}

- (NSInteger)numberofItemsWithLivePlayView:(LTLivePlayLoopsListView *)livePlayView {
    return self.dataSource.count;
}

- (LTLivePlayLoopsListView *)playListView {
    if (!_playListView) {
        CGFloat Y = kIPhoneX ? 64 + 24.0 : 64.0;
        CGFloat H = self.view.bounds.size.height - Y;
        _playListView = [[LTLivePlayLoopsListView alloc] initWithFrame:CGRectMake(0, Y, self.view.bounds.size.width, H) content:[UILabel class]];
        _playListView.delegate = self;
        _playListView.dataSource = self;
        /** 是否开启支持无限轮播 默认YES*/
        _playListView.isCanLoops = YES;
    }
    return _playListView;
}

- (UIButton *)contentView {
    if (!_contentView) {
        _contentView = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentView.frame = CGRectMake(0, 0, self.playListView.frame.size.width, self.playListView.frame.size.height);
        [_contentView setTitle:@"播放器播放视频流..." forState:UIControlStateNormal];
        _contentView.titleLabel.font = [UIFont systemFontOfSize:20];
        [_contentView setBackgroundImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    }
    return _contentView;
}

@end
