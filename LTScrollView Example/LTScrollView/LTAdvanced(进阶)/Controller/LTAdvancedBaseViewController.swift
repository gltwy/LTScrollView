//
//  LTAdvancedBaseViewController.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/27.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit
import MJRefresh

public let kContentScrollViewNotification = Notification.Name(rawValue: "contentScrollViewDidScroll")
public let kScrollViewToTopNotification = Notification.Name(rawValue: "scrollViewToTop")

class LTAdvancedBaseViewController: UIViewController {
    
    var lastContentOffset: CGFloat = 0.0
    var isLoadViewController: Bool = false
    var scrollView: UIScrollView?
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 64), style:.plain)
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(180+44, 0, 0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(180+44, 0, 0, 0)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BaseCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        self.automaticallyAdjustsScrollViewInsets = false
        reftreshData()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
        } else {
            // Fallback on earlier versions
        }
        reftreshData()
        scrollView = tableView
        //        scrollViewDidScroll(tableView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }
    
}

extension LTAdvancedBaseViewController {
    fileprivate func reftreshData()  {
        tableView.mj_header = MJRefreshNormalHeader {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                print("上拉加载更多数据")
                self.tableView.mj_header.endRefreshing()
            })
        }
    }
}


//MARK: 注册/移除/发送通知
extension LTAdvancedBaseViewController {
    
    //    fileprivate func registerNotification()  {
    //        NotificationCenter.default.addObserver(self, selector: #selector(scrollViewToTop(_:)), name: kScrollViewToTopNotification, object: nil)
    //    }
    
    //    @objc func scrollViewToTop(_ notification: Notification)  {
    //        tableView.contentOffset = .zero
    //    }
    
    fileprivate func removeNotification()  {
        NotificationCenter.default.removeObserver(self, name: kScrollViewToTopNotification, object: nil)
    }
    
    fileprivate func sendToTopScrollViewNotification(_ scrollView: UIScrollView)  {
        let absOffset = scrollView.contentOffset.y - self.lastContentOffset
        NotificationCenter.default.post(name: kContentScrollViewNotification, object: nil, userInfo: ["contentScrollView":scrollView, "absOffset":absOffset])
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
}

extension NSObject {
    
    var glt_scrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, "glt_scrollView_key") as? UIScrollView
        }
        set {
            objc_setAssociatedObject(self, "glt_scrollView_key", newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
}

extension LTAdvancedBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "BaseCell", for: indexPath)
        cell.textLabel?.text = "第 \(indexPath.row + 1) 行"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sendToTopScrollViewNotification(scrollView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row + 1)行")
    }
}
