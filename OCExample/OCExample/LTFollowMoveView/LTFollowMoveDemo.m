//
//  LTFollowMoveDemo.m
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

#import "LTFollowMoveDemo.h"
#import "LTFollowMoveTestView.h"
#import "LTScrollView-Swift.h"

@interface LTFollowMoveDemo ()
@property(strong, nonatomic) UIButton *jumpButton;
@property(strong, nonatomic) LTFollowMoveTestView *testView;
@end

@implementation LTFollowMoveDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.jumpButton];
}

- (void)jumpButtonClick {
    LTFollowMoveView *moveView = [[LTFollowMoveView alloc] initWithFrame:UIScreen.mainScreen.bounds contentView:self.testView];
    [moveView setShowFinishedHandle:^{
        NSLog(@"setShowFinishedHandle");
    }];
    [moveView showInView:self.view];
}

- (LTFollowMoveTestView *)testView {
    if (!_testView) {
        _testView = [[LTFollowMoveTestView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kReturnHeight)];
    }
    return _testView;
}

- (UIButton *)jumpButton {
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpButton.frame = CGRectMake(0, kReturnHeight, self.view.frame.size.width, 50);
        [_jumpButton setTitle:@"点击弹出" forState:UIControlStateNormal];
        _jumpButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_jumpButton addTarget:self action:@selector(jumpButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _jumpButton.backgroundColor = [UIColor redColor];
    }
    return _jumpButton;
}

@end
