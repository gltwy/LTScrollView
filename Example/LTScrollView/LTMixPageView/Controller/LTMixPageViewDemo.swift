//
//  LTMixPageViewDemo.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/2/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LTMixPageViewDemo: UIViewController {

    
    private lazy var viewControllers: [UIViewController] = {
        let defaultVC = LTMixPageSimpleDemo()
        let setVC = LTMixPageSimpleDemo()
        let setStyleOtherVC = LTMixPageSimpleDemo()
        let testVC = LTPageViewDemo(isFromMix: true)
        let customStyleVC = LTMixPageSimpleDemo()
        return [defaultVC, setVC, setStyleOtherVC, testVC, customStyleVC]
    }()
    
    private lazy var titles: [String] = {
        return ["上下左右", "自定义", "注意设置", "isSimpeMix", "否则无效"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.sliderHeight = 40
        layout.lrMargin = 20
        layout.titleMargin = 20
        layout.bottomLineColor = .randomColor
        layout.titleColor = .randomColor
        layout.titleSelectColor = .randomColor
        layout.titleViewBgColor = .white
        layout.titleFont = UIFont.systemFont(ofSize: 12)
        return layout
    }()
    
    private lazy var pageView: LTPageView = {
        let pageView = LTPageView(frame: CGRect(x: 0, y: GLT_NAVCHEIGHT, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout)
        pageView.isClickScrollAnimation = true
        return pageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageView)
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
    }
}
