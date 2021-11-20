//
//  ViewController.m
//  OCExample
//
//  Created by 高刘通 on 2018/4/18.
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

#import "ViewController.h"
#import "LTScrollView-Swift.h"
#import "TestTableViewCell.h"
#import "LTSimpleManagerDemo.h"
#import "LTAdvancedManagerDemo.h"
#import "LTPersonMainPageDemo.h"
#import "LTPageViewDemo.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;

@property(copy, nonatomic) NSArray *titles;

@end

@implementation ViewController

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
    
    self.titles = @[@"基础版-刷新控件在顶部(有更新！)\nLTSimple",
                    @"进阶版-刷新控件在中间\nLTAdvanced",
                    @"下拉放大-导航渐变\nLTPersonalMainPage",
                    @"切换视图(重大更新！！！)\nLTPageView"];
    self.title = @"首页";
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [TestTableViewCell cellWithTableView:tableView];
    cell.textLabel.attributedText = [self textAttribute:self.titles[indexPath.row]];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(NSAttributedString *)textAttribute:(NSString *)string {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSRangeFromString(string);
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    return [[NSAttributedString alloc] initWithAttributedString:attr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            LTSimpleManagerDemo *demoVC = [[LTSimpleManagerDemo alloc] init];
            demoVC.title = self.titles[indexPath.row];
            [self.navigationController pushViewController:demoVC animated:YES];
        }break;
        case 1:
        {
            LTAdvancedManagerDemo *demoVC = [[LTAdvancedManagerDemo alloc] init];
            demoVC.title = self.titles[indexPath.row];
            [self.navigationController pushViewController:demoVC animated:YES];
        }break;
        case 2:
        {
            LTPersonMainPageDemo *demoVC = [[LTPersonMainPageDemo alloc] init];
            demoVC.title = self.titles[indexPath.row];
            [self.navigationController pushViewController:demoVC animated:YES];
        }break;
        case 3:
        {
            LTPageViewDemo *demoVC = [[LTPageViewDemo alloc] init];
            demoVC.title = self.titles[indexPath.row];
            [self.navigationController pushViewController:demoVC animated:YES];
        }break;
            
            
        default:break;
    }
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
