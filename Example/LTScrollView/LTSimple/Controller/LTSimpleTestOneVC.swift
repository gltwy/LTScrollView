//
//  LTSimpleTestOneVC.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/27.
//  Copyright © 2017年 LT. All rights reserved.
//
//
//  如有疑问，欢迎联系本人QQ: 1282990794
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

import UIKit
import MJRefresh
private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

class LTSimpleTestOneVC: UIViewController, LTTableViewProtocal {
    
    private lazy var tableView: UITableView = {
//         如果设置了layout.isHovered = false不悬停 此处Y的值应该从0开始 高度再加上sliderHeight 即：
//        let H: CGFloat = glt_iphoneX ? (view.bounds.height - 64 - 24 - 34) : view.bounds.height - 64
//        let tableView = tableViewConfig(CGRect(x: 0, y:0, width: view.bounds.width, height: H), self, self, nil)
        
        let iPhoneXH = view.bounds.height - 44 - 64 - 24 - 34
        let otherH = view.bounds.height - 64 - 44
        let H: CGFloat = glt_iphoneX ? iPhoneXH : otherH
        let tableView = tableViewConfig(CGRect(x: 0, y:44, width: view.bounds.width, height: H), self, self, nil)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        glt_scrollView = tableView
        reftreshData()
        if #available(iOS 11.0, *) {
            glt_scrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    deinit {
        print("释放了")
    }
}

extension LTSimpleTestOneVC {
    fileprivate func reftreshData()  {
        self.tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                print("上拉加载更多数据")
                self?.tableView.mj_footer.endRefreshing()
            })
        }
    }
}


extension LTSimpleTestOneVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.textLabel?.text = "第 \(indexPath.row + 1) 行"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("点击了第\(indexPath.row + 1)行")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

