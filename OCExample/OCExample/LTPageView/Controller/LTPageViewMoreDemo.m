//
//  LTPageViewMoreDemo.m
//  OCExample
//
//  Created by gaoliutong on 2021/11/20.
//  Copyright © 2021 LT. All rights reserved.
//

#import "LTPageViewMoreDemo.h"
#import "LTScrollView-Swift.h"
#import "LTPageViewTestOneVC.h"
#import "LTCustomTitleItemView.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]


@interface LTPageViewMoreDemo ()
@property(assign, nonatomic) EStyle style;
@end

@implementation LTPageViewMoreDemo

- (instancetype)initWithStyle:(EStyle)style {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_style) {
        case EStyleDefault:
            [self style4];
            break;
        case EStyleSetSyle:
            [self style2];
            break;
        case EStyleSetSyleOther:
            [self style3];
            break;
        case EStyleCustomStyle:
            [self style1];
            break;
    }
}

- (void)style1 {
    LTLayout *layout = [LTLayout new];
    layout.sliderHeight = 40.0;
    NSArray *titles = @[@"我是", @"默认", @"设置", @"点击我的", @"最上方", @"可以", @"切换其他", @"样式"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [viewControllers addObject:[LTPageViewTestOneVC new]];
    }];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat Y = statusBarH + 44.0;
    CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34 - 40) : self.view.bounds.size.height - Y - 40;
    LTPageView *pageView = [[LTPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H) currentViewController:self viewControllers:viewControllers titles:titles layout:layout];
    pageView.isClickScrollAnimation = YES;
    [pageView setDidSelectIndexBlock:^(LTPageView *pageView, NSInteger index) {
        NSLog(@"setDidSelectIndexBlock - %ld", index);
    }];
    [self.view addSubview:pageView];
}

- (void)style2 {
    LTLayout *layout = [LTLayout new];
    layout.bottomLineHeight = 4;
    layout.bottomLineCornerRadius = 2;
    layout.sliderHeight = 40.0;
    NSArray *titles = @[@"我可以", @"圆角滑块", @"改变标题view的高", @"改变标题颜色", @"标题选中颜色", @"标题字号", @"整个滑块的高", @"单个滑块的宽度", @"是否隐藏滑块", @"标题间隔", @"最左最右距离", @"是否放大标题", @"放大标题的倍率", @"是否开启颜色渐变", @"更多设置请查看LTLayout"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [viewControllers addObject:[LTPageViewTestOneVC new]];
    }];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat Y = statusBarH + 44.0;
    CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34 - 40) : self.view.bounds.size.height - Y - 40;
    LTPageView *pageView = [[LTPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H) currentViewController:self viewControllers:viewControllers titles:titles layout:layout];
    pageView.isClickScrollAnimation = YES;
    [pageView setDidSelectIndexBlock:^(LTPageView *pageView, NSInteger index) {
        NSLog(@"setDidSelectIndexBlock - %ld", index);
    }];
    [self.view addSubview:pageView];
}

- (void)style3 {
    NSArray *titles = @[@"我可以", @"居中", @"显示", @"哦"];
    LTLayout *layout = [LTLayout new];
    layout.sliderWidth = 80;
    layout.titleMargin = 10;
    // （屏幕宽度 - 标题总宽度 - 标题间距宽度） / 2 = 最左边以及最右边剩余
    CGFloat lrMargin = (self.view.bounds.size.width - titles.count * layout.sliderWidth + (titles.count - 1) * layout.titleMargin) * 0.5;
    layout.lrMargin = lrMargin;
    layout.isAverage = YES;
    NSMutableArray *viewControllers = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [viewControllers addObject:[LTPageViewTestOneVC new]];
    }];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat Y = statusBarH + 44.0;
    CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34 - 40) : self.view.bounds.size.height - Y - 40;
    LTPageView *pageView = [[LTPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H) currentViewController:self viewControllers:viewControllers titles:titles layout:layout];
    pageView.isClickScrollAnimation = YES;
    [pageView setDidSelectIndexBlock:^(LTPageView *pageView, NSInteger index) {
        NSLog(@"setDidSelectIndexBlock - %ld", index);
    }];
    [self.view addSubview:pageView];
}

- (void)style4 {
    NSArray *titles = @[@"添加背景图片", @"自定义badge", @"我是富文本", @"修改位置", @"更多样式"];
    LTLayout *layout = [LTLayout new];
    layout.titleMargin = 15;
    layout.lrMargin = 15;
    layout.titleFont = [UIFont systemFontOfSize:14];
    layout.isNeedScale = YES;
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [viewControllers addObject:[LTPageViewTestOneVC new]];
    }];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat Y = statusBarH + 44.0;
    CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34 - 40) : self.view.bounds.size.height - Y - 40;
    LTPageView *pageView = [[LTPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H) currentViewController:self viewControllers:viewControllers titles:titles layout:layout itemViewClass:[LTCustomTitleItemView class]];
    pageView.isClickScrollAnimation = YES;
    [pageView setDidSelectIndexBlock:^(LTPageView *pageView, NSInteger index) {
        NSLog(@"setDidSelectIndexBlock - %ld", index);
    }];
    [self.view addSubview:pageView];
}

@end
