//
//  LTAdvancedManagerDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
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

class LTAdvancedManagerDemo: UIViewController {

    private lazy var viewControllers: [UIViewController] = {
        let oneVc = LTAdvancedTestOneVC()
        let twoVc = LTAdvancedTestOneVC()
        let threeVc = LTAdvancedTestOneVC()
        let fourVc = LTAdvancedTestOneVC()
        return [oneVc, twoVc, threeVc, fourVc]
    }()
    
    private lazy var titles: [String] = {
        return ["热门", "精彩推荐", "科技控", "游戏"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.titleViewBgColor = UIColor(r: 255, g: 239, b: 213)
        layout.titleColor = UIColor(r: 0, g: 0, b: 0)
        layout.titleSelectColor = UIColor(r: 255, g: 0, b: 0)
        layout.bottomLineColor = UIColor.red
        layout.pageBottomLineColor = UIColor(r: 230, g: 230, b: 230)
        layout.isAverage = true
        layout.sliderWidth = 20
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
        //MARK: 选中事件
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

