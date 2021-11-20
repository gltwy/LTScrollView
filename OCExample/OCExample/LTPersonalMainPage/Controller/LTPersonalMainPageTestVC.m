//
//  LTPageViewTestOneVC.m
//  OCExample
//
//  LTPageViewTestOneVC.m
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

#import "LTPersonalMainPageTestVC.h"
#import "LTScrollView-Swift.h"
#import "TestTableViewCell.h"
#import "MJRefresh.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)

@interface LTPersonalMainPageTestVC () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;

@end

@implementation LTPersonalMainPageTestVC

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
    
    if (self.totalCount == 0) {
        self.totalCount = 20;
    }
    
#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    
    [self setupRefreshData];
}

- (void)setupRefreshData {
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.totalCount += 10;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.totalCount = 20;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalCount;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
        //这个44为导航高度
        CGFloat Y = statusBarH + 44;
        //这个44为切换条的高度
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y - 44;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
