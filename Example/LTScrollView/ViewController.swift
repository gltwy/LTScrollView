//
//  ViewController.swift
//  LTScrollView
//
//  Created by 1282990794@qq.com on 02/03/2018.
//  Copyright (c) 2018 1282990794@qq.com. All rights reserved.
//
/*
 * github地址
 * https://github.com/gltwy/LTScrollView
 *
 * git 下载地址
 * https://github.com/gltwy/LTScrollView.git
 */
import UIKit
import LTScrollView

class ViewController: UIViewController, LTTableViewProtocal {
    
    private let datas = ["基础版（LTSimple）", "进阶版（LTAdvanced）"]
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = tableViewConfig(self, self, nil)
        tableView.frame.origin.y = 64
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.textLabel?.text = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewControllers = [LTSimpleManagerDemo(), LTAdvancedManagerDemo()]
        pushVc(viewControllers[indexPath.row], index: indexPath.row)
    }
    
    private func pushVc(_ VC: UIViewController, index: Int) {
        VC.title = datas[index]
        navigationController?.pushViewController(VC, animated: true)
    }
}

