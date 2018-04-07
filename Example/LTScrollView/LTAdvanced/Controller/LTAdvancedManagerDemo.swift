//
//  LTAdvancedManagerDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
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

class LTAdvancedManagerDemo: UIViewController {

    private lazy var viewControllers: [UIViewController] = {
        let oneVc = LTAdvancedTestOneVC()
        let twoVc = LTAdvancedTestOneVC()
        let threeVc = LTAdvancedTestOneVC()
        let fourVc = LTAdvancedTestOneVC()
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

    private lazy var advancedManager: LTAdvancedManager = {
        let Y: CGFloat = glt_iphoneX ? 64 + 24.0 : 64.0
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        let advancedManager = LTAdvancedManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.testLabel()
            return headerView
        })
        return advancedManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(advancedManager)
        advancedManagerConfig()
        
    }

}

extension LTAdvancedManagerDemo {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        advancedManager.advancedDidSelectIndexHandle = {
            print($0)
        }
    }
}


extension LTAdvancedManagerDemo {
    private func testLabel() -> LTHeaderView {
        return LTHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 180))
    }
}

