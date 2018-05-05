//
//  LTAdvancedManagerDemo.m
//  OCExample
//
//  Created by 高刘通 on 2018/4/19.
//  Copyright © 2018年 LT. All rights reserved.
//
//  如有疑问，欢迎联系本人QQ: 1282990794
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

#import "LTAdvancedManagerDemo.h"
#import "LTAdvancedTestViewController.h"
#import "MJRefresh.h"
#import "LTHeaderView.h"
#import "LTScrollView-Swift.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface LTAdvancedManagerDemo () <LTAdvancedScrollViewDelegate>
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTAdvancedManager *managerView;
@end

@implementation LTAdvancedManagerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubViews];
}


-(void)setupSubViews {
    
    [self.view addSubview:self.managerView];
    
    [self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
        NSLog(@"%ld", index);
    }];
}

-(LTAdvancedManager *)managerView {
    if (!_managerView) {
        CGFloat Y = kIPhoneX ? 64 + 24.0 : 64.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        _managerView = [[LTAdvancedManager alloc] initWithFrame:CGRectMake(0, Y, self.view.bounds.size.width, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout headerViewHandle:^UIView * _Nonnull{
            return [self setupHeaderView];
        }];
        _managerView.delegate = self;
    }
    return _managerView;
}

-(void)glt_scrollViewOffsetY:(CGFloat)offsetY {
    NSLog(@"---> %lf", offsetY);
}

-(LTHeaderView *)setupHeaderView {
    LTHeaderView *headerView = [[LTHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180.0)];
    return headerView;
}

-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.titleViewBgColor = RGBA(255, 239, 213, 1);
        _layout.pageBottomLineColor = RGBA(230, 230, 230, 1);
        _layout.bottomLineColor = [UIColor redColor];
        _layout.isAverage = YES;
        _layout.sliderWidth = 20;
    }
    return _layout;
}


- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"热门", @"精彩推荐", @"科技控", @"游戏"];
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
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LTAdvancedTestViewController *testVC = [[LTAdvancedTestViewController alloc] init];
        [testVCS addObject:testVC];
    }];
    return testVCS.copy;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
