//
//  LTPageViewDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/6/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class LTPageViewDemo: UIViewController {

    
    private lazy var viewControllers: [UIViewController] = {
        let defaultVC = LTPageViewMoreDemo(style: .default)
        let setVC = LTPageViewMoreDemo(style: .setStyle)
        let setStyleOtherVC = LTPageViewMoreDemo(style: .setStyleOther)
        let customStyleVC = LTPageViewMoreDemo(style: .customStyle)
        return [defaultVC, setVC, setStyleOtherVC, customStyleVC]
    }()
    
    private lazy var titles: [String] = {
        return ["自定义标题样式", "系统样式1", "系统样式2", "默认"]
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
        return layout
    }()
    
    private lazy var pageView: LTPageView = {
        let pageView = LTPageView(frame: CGRect(x: 0, y: self.isFromMix ? 0 : GLT_NAVCHEIGHT, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout/*, itemViewClass: LTCustomTitleItemView.self*/)
        pageView.isClickScrollAnimation = true
        return pageView
    }()
    
    private lazy var isFromMix: Bool = false
    
    init(isFromMix: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isFromMix = isFromMix
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageView)
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
