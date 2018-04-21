//
//  LTAdvancedManagerDemo.m
//  OCExample
//
//  Created by 高刘通 on 2018/4/19.
//  Copyright © 2018年 LT. All rights reserved.
//

#import "LTAdvancedManagerDemo.h"
#import "LTAdvancedTestViewController.h"
#import "MJRefresh.h"
#import "LTHeaderView.h"
#import "LTScrollView-Swift.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface LTAdvancedManagerDemo ()
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
    }
    return _managerView;
}

-(LTHeaderView *)setupHeaderView {
    LTHeaderView *headerView = [[LTHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180.0)];
    return headerView;
}

-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.titleColor = [UIColor whiteColor];
        _layout.titleViewBgColor = [UIColor grayColor];
        _layout.titleSelectColor = [UIColor yellowColor];
        _layout.bottomLineColor = [UIColor yellowColor];
    }
    return _layout;
}


- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"热门", @"价格", @"其他", @"价值"];
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
