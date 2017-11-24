//
//  LTHomePageViewController.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/24.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

private let reusedID: String = "homeCell"

class LTHomePageViewController: UIViewController {

    fileprivate let datas = ["基础版", "进阶版"]
    
    fileprivate lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LTHomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reusedID)
        }
        cell?.textLabel?.text = datas[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let simpleVc = LTSimpleViewController()
            simpleVc.title = datas[indexPath.row]
            navigationController?.pushViewController(simpleVc, animated: true)
        }else{
            let advancedVc = LTAdvancedViewController()
            advancedVc.title = datas[indexPath.row]
            navigationController?.pushViewController(advancedVc, animated: true)
        }
    }
}


