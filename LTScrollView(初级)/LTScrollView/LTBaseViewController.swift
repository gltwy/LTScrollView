//
//  LTBaseViewController.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit
import MJRefresh

public let kContentScrollViewNotification = Notification.Name(rawValue: "contentScrollViewDidScroll")
public let kScrollViewToTopNotification = Notification.Name(rawValue: "scrollViewToTop")

class LTBaseViewController: UIViewController {

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 64 - 44), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BaseCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        self.automaticallyAdjustsScrollViewInsets = false
        registerNotification()
        reftreshData()
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

extension LTBaseViewController {
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                print("上拉加载更多数据")
                self.tableView.mj_footer.endRefreshing()
            })
        }
    }
}


//MARK: 注册/移除/发送通知
extension LTBaseViewController {
    
    fileprivate func registerNotification()  {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollViewToTop(_:)), name: kScrollViewToTopNotification, object: nil)
    }
    
    @objc func scrollViewToTop(_ notification: Notification)  {
        tableView.contentOffset = .zero
    }
    
    fileprivate func removeNotification()  {
        NotificationCenter.default.removeObserver(self, name: kScrollViewToTopNotification, object: nil)
    }
    
    fileprivate func sendToTopScrollViewNotification(_ scrollView: UIScrollView)  {
        NotificationCenter.default.post(name: kContentScrollViewNotification, object: scrollView)
    }
    
}

extension LTBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
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
