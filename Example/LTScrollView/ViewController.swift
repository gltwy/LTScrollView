//
//  ViewController.swift
//  LTScrollView
//
//  Created by 1282990794@qq.com on 02/03/2018.
//  Copyright (c) 2018 1282990794@qq.com. All rights reserved.
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

private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

let GLT_STATUSHEIGHT = UIApplication.shared.statusBarFrame.size.height

let GLT_BOTTOMSPACE: CGFloat = glt_iphoneX ? 34 : 0

let GLT_NAVCHEIGHT = GLT_STATUSHEIGHT + 44

let GLT_MAINWIDTH = UIScreen.main.bounds.size.width

let GLT_MAINWHEIGHT = UIScreen.main.bounds.size.height

class ViewController: UIViewController, LTTableViewProtocal {
    
    private let datas = ["基础版-刷新控件在顶部(有更新！)\nLTSimple",
                         "进阶版-刷新控件在中间\nLTAdvanced",
                         "下拉放大-导航渐变\nLTPersonalMainPage",
                         "切换视图(重大更新！！！)\nLTPageView"]
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = tableViewConfig(self, self, nil)
        tableView.frame.origin.y = UIApplication.shared.statusBarFrame.height + 44
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
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
        cell.textLabel?.attributedText = textAttributes(string: datas[indexPath.row])
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            pushVc(LTSimpleManagerDemo(), index: indexPath.row)
            break
        case 1:
            pushVc(LTAdvancedManagerDemo(), index: indexPath.row)
            break
        case 2:
            pushVc(LTPersonMainPageDemo(), index: indexPath.row)
            break
        case 3:
            pushVc(LTPageViewDemo(), index: indexPath.row)
            break
        default:break
        }
    }
    
    private func pushVc(_ VC: UIViewController, index: Int) {
        VC.title = datas[index]
        navigationController?.pushViewController(VC, animated: true)
    }
}

extension ViewController {
    
    private func textAttributes(string: String) -> NSAttributedString {
        var attributes:[NSAttributedString.Key: Any] = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return NSAttributedString(string: string, attributes: attributes)
    }
}

