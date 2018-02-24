//
//  LTSimpleManagerDemo.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//

/*
 * github地址
 * https://github.com/gltwy/LTScrollView
 *
 * git 下载地址
 * https://github.com/gltwy/LTScrollView.git
 */

import UIKit
import MJRefresh
import LTScrollView

class LTSimpleManagerDemo: UIViewController {

    private lazy var viewControllers: [UIViewController] = {
        let oneVc = LTSimpleTestOneVC()
        let twoVc = LTSimpleTestTwoVC()
        let threeVc = LTSimpleTestThreeVC()
        let fourVc = LTSimpleTestFourVC()
        return [oneVc, twoVc, threeVc, fourVc]
    }()
    
    private lazy var titles: [String] = {
        return ["嘿嘿", "呵呵", "哈哈", "嘻嘻"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.titleColor = UIColor.white
        layout.titleViewBgColor = UIColor.gray
        layout.titleSelectColor = UIColor.yellow
        layout.bottomLineColor = UIColor.yellow
        return layout
    }()
    
    private lazy var simpleManager: LTSimpleManager = {
        let Y: CGFloat = glt_iphoneX ? 64 + 24.0 : 64.0
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        let simpleManager = LTSimpleManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        return simpleManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(simpleManager)
        simpleManagerConfig()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension LTSimpleManagerDemo {
    
    //MARK: 具体使用请参考以下
    private func simpleManagerConfig() {
        
        //MARK: headerView设置
        simpleManager.configHeaderView {[weak self] in
            guard let strongSelf = self else { return nil }
            let headerView = strongSelf.testLabel()
            return headerView
        }
        
        //MARK: pageView点击事件
        simpleManager.didSelectIndexHandle { (index) in
            print("点击了 \(index) 😆")
        }
        
        //MARK: 控制器刷新事件
        simpleManager.refreshTableViewHandle { (scrollView, index) in
            scrollView.mj_header = MJRefreshNormalHeader {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
                    scrollView.mj_header.endRefreshing()
                })
            }
        }
        
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
}


extension LTSimpleManagerDemo {
    private func testLabel() -> UILabel {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 185))
        headerView.backgroundColor = UIColor.red
        headerView.text = "点击响应事件"
        headerView.textAlignment = .center
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))
        return headerView
    }
}
