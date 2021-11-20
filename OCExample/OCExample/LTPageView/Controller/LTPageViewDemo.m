//
//  LTPageViewDemo.m
//  OCExample
//
//  Created by 高刘通 on 2018/4/19.
//  Copyright © 2018年 LT. All rights reserved.
//
//  如有疑问，请搜索并关注微信公众号"技术大咖社"并留言即可
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

#import "LTPageViewDemo.h"
#import "LTScrollView-Swift.h"
#import "LTPageViewTestOneVC.h"
#import "LTPageViewMoreDemo.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface LTPageViewDemo ()
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTPageView *pageView;
@end

@implementation LTPageViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
}

-(void)setupSubViews {
    [self.view addSubview:self.pageView];
    
    [self.pageView setDidSelectIndexBlock:^(LTPageView * _Nonnull pageView, NSInteger index) {
        NSLog(@"%ld", index);
    }];
}

-(LTPageView *)pageView {
    if (!_pageView) {
        CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat Y = statusBarH + 44.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        _pageView = [[LTPageView alloc] initWithFrame:CGRectMake(0, Y, self.view.bounds.size.width, H) currentViewController:self viewControllers:self.viewControllers titles:self.titles layout:self.layout];
    }
    return _pageView;
}

-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.sliderWidth = 40;
        _layout.titleMargin = 20.0;
        _layout.lrMargin = 20;
    }
    return _layout;
}


- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"默认", @"系统样式1", @"系统样式2", @"自定义标题样式"];
    }
    return _titles;
}


-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        LTPageViewMoreDemo *testVC = [[LTPageViewMoreDemo alloc] initWithStyle:index];
        [testVCS addObject:testVC];
    }];
    return testVCS.copy;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
