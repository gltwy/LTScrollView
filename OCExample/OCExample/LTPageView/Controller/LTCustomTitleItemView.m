//
//  LTCustomTitleItemView.m
//  OCExample
//
//  Created by gaoliutong on 2022/3/11.
//  Copyright © 2022 LT. All rights reserved.
//

#import "LTCustomTitleItemView.h"
#import "LTScrollView-Swift.h"

/**
 实现步骤：
 1. 指定itemViewClass:
 LTPageView *pageView = [[LTPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H) currentViewController:self viewControllers:viewControllers titles:titles layout:layout itemViewClass:[LTCustomTitleItemView class]];
 
 2. 指定的itemViewClass需要遵守LTPageTitleItemType协议
 
 3. 实现指定的协议方法即可
 */

@interface LTCustomTitleItemView()
@property(strong, nonatomic) UIImageView *backgroundImageView;
@property(strong, nonatomic) UIView *badgeView;
@end

@implementation LTCustomTitleItemView
@synthesize glt_index = _glt_index;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self insertSubview:self.backgroundImageView atIndex:0];
        [self addSubview:self.badgeView];
    }
    return self;
}

- (void)glt_setSelected:(BOOL)isSelected {
    
    /// 修改背景颜色使用示例
    if (_glt_index % 2 == 0) {
        self.backgroundColor = isSelected ? [UIColor orangeColor] : [UIColor blueColor];
    }else {
        self.backgroundColor = isSelected ? [UIColor greenColor] : [UIColor yellowColor];
    }
    
    /// 设置背景图使用示例
    _backgroundImageView.hidden = _glt_index != 0;
    
    ///选中1的时候隐藏使用示例
    _badgeView.hidden = _glt_index != 1 || isSelected;
    
    /// 设置富文本使用示例
    if (_glt_index == 2) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(1, 1)];
        self.titleLabel.attributedText = attr;
    }
    
    ///设置标题偏移使用示例
    if (_glt_index == 3) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -10, 0);
    }
}

- (void)glt_layoutSubviews {
    self.backgroundImageView.frame = self.bounds;
    self.badgeView.frame = CGRectMake(self.frame.size.width - 15, 5, 10, 10);
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.image = [UIImage imageNamed:@"test"];
    }
    return _backgroundImageView;
}

- (UIView *)badgeView {
    if (!_badgeView) {
        _badgeView = [UIView new];
        _badgeView.backgroundColor = [UIColor redColor];
    }
    return _badgeView;
}

- (void)dealloc {
    NSLog(@"LTCustomTitleItemView - dealloc");
}

@end
