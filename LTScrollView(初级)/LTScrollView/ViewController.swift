//
//  ViewController.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/13.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit
import MJRefresh

private let kHeaderHeight: CGFloat = 175.0

class ViewController: UIViewController {

    var contentTableView: UITableView?
    
    fileprivate lazy var tableView: LTTableView = {
        let tableView = LTTableView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 64), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "rootCell")
        return tableView
    }()
    
    fileprivate lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: kHeaderHeight))
        headerView.backgroundColor = UIColor.yellow
        return headerView
    }()
    
    fileprivate lazy var pageView: LTPageView = {
        let viewControllers = [FirstViewController(),SecondViewController(),ThirdViewController(),ForthViewController()]
        let titles = ["嘿嘿", "呵呵", "哈哈", "嘻嘻"]
        let layout = LTLayout()
        layout.titleColor = UIColor.white
        layout.titleViewBgColor = UIColor.gray
        layout.titleSelectColor = UIColor.red
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height  - 64), currentViewController: self, viewControllers: viewControllers, titles: titles, layout:layout)
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ScrollView联动"
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        registerNotification()
        reftreshData()
        pageViewDidSelect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }

}

extension ViewController {
    func reftreshData()  {
        tableView.mj_header = MJRefreshNormalHeader {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                print("下拉加载更多数据")
                self.tableView.mj_header.endRefreshing()
            })
        }
    }
}

extension ViewController {
    func pageViewDidSelect()  {
        pageView.didSelectIndexBlock = {(_ , index) in
            print("点击切换位置--当前位置-> \(index)")
        }
    }
}

extension ViewController {

    fileprivate func registerNotification()  {
        NotificationCenter.default.addObserver(self, selector: #selector(contentScrollViewDidScroll(_:)), name: kContentScrollViewNotification, object: nil)
    }
    
  
    fileprivate func removeNotification()  {
        NotificationCenter.default.removeObserver(self, name: kContentScrollViewNotification, object: nil)
    }

    
    /*
     * 思路：
     1. 当内容tableView滚动的时候，如果内容的偏移量y值小于kHeaderHeight（说明此时headerview可见），此时应该滚动底部tableView，所以内容的tableView的contentoffset应该为0，并且此时隐藏右面的scrollIndicator
     2. 如果内容的偏移量y值大于kHeaderHeight（说明此时headerview不可见），此时应该滚动内容tableView，此时让内容的scrollIndicator显示
     */
    @objc func contentScrollViewDidScroll(_ notification: Notification)  {
        if case let scrollView as UITableView = notification.object {
            contentTableView = scrollView
            if tableView.contentOffset.y < kHeaderHeight {
                scrollView.contentOffset = .zero;
                scrollView.showsVerticalScrollIndicator = false
            }else{
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "rootCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "ddd"
        cell.contentView.addSubview(pageView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height - 64
    }
    
    /*
     * 思路： 
        1. 如果滚动的tableview，当内容scrollview的偏移量大于0，此时说明tableView的偏移量肯定是headerView，即为kHeaderHeight
        2. 如果滚动的tableview，当前的滚动小于kHeaderHeight，所有的内容scollView应该回到顶部
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView == tableView  else {
            return
        }
        guard let contentTableView = contentTableView else {
            return
        }
        if contentTableView.contentOffset.y > 0 {
            tableView.contentOffset = CGPoint(x: 0, y: kHeaderHeight)
        }
        
        if scrollView.contentOffset.y < kHeaderHeight {
            NotificationCenter.default.post(name: kScrollViewToTopNotification, object: nil)
        }
    }

}



