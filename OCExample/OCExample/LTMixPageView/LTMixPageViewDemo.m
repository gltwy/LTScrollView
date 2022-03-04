//
//  LTMixPageViewDemo.m
//  OCExample
//
//  Created by gaoliutong on 2022/3/4.
//  Copyright © 2022 LT. All rights reserved.
//

#import "LTMixPageViewDemo.h"
#import "LTScrollView-Swift.h"
#import "LTPageViewTestOneVC.h"
#import "LTPageViewMoreDemo.h"
#import "LTMixPageSimpleDemo.h"
#import "LTPageViewDemo.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface LTMixPageViewDemo ()
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTPageView *pageView;
@end

@implementation LTMixPageViewDemo

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
        _titles = @[@"上下左右", @"自定义", @"注意设置", @"isSimpeMix", @"否则无效"];
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
        if (index == 3) {
            LTPageViewDemo *testVC = [[LTPageViewDemo alloc] init];
            testVC.isFromMix = YES;
            [testVCS addObject:testVC];
        }else {
            LTMixPageSimpleDemo *testVC = [[LTMixPageSimpleDemo alloc] init];
            [testVCS addObject:testVC];
        }
    }];
    return testVCS.copy;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
