//
//  LTMixPageSimpleChildViewController.m
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

#import "LTMixPageSimpleChildViewController.h"
#import "TestTableViewCell.h"
#import "MJRefresh.h"
#import "LTScrollView-Swift.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)

@interface LTMixPageSimpleChildViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;

@end

@implementation LTMixPageSimpleChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [TestTableViewCell cellWithTableView:tableView];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row + 1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第 %ld 行", indexPath.row + 1);
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - 44 - 64 - 24 - 34) : self.view.bounds.size.height - 44 - 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H - 44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
