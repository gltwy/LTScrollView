//
//  LTPageViewMoreDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2020/8/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class LTPageViewMoreDemo: UIViewController {
    
    enum EStyle {
        case `default`
        case setStyle
        case setStyleOther
        case customStyle
    }
    
    private var style: EStyle
    
    init(style: EStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        switch style {
        case .default:
            style4()
            break
        case .setStyle:
            style2()
            break
        case .setStyleOther:
            style3()
            break
        case .customStyle:
            style1()
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: 默认设置
extension LTPageViewMoreDemo {
    
    @objc func style1() {
        let layout = LTLayout()
        
        layout.sliderHeight = 40 //默认44

        let titles = ["我是", "默认", "设置", "点击我的", "最上方", "可以", "切换其他", "样式"]
        var viewControllers = [UIViewController]()
        for _ in titles {
            viewControllers.append(LTPageViewTestOneVC())
        }
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE - 40), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout)
        pageView.isClickScrollAnimation = true
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        view.addSubview(pageView)
    }
}

//MARK: 系统样式1
extension LTPageViewMoreDemo {
    
    @objc private func style2() {
        
        let layout = LTLayout()
        layout.bottomLineHeight = 4
        layout.bottomLineCornerRadius = 2
        layout.sliderHeight = 40
        
        let titles = ["我可以", "圆角滑块", "改变标题view的高", "改变标题颜色", "标题选中颜色", "标题字号", "整个滑块的高", "单个滑块的宽度", "是否隐藏滑块", "标题间隔", "最左最右距离", "是否放大标题", "放大标题的倍率", "是否开启颜色渐变", "更多设置请查看LTLayout"]
        
        var viewControllers = [UIViewController]()
        for _ in titles {
            viewControllers.append(LTPageViewTestOneVC())
        }
        
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE - 40), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout)
        pageView.isClickScrollAnimation = true
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        view.addSubview(pageView)
    }
}

//MARK: 系统样式2
extension LTPageViewMoreDemo {
    
    @objc private func style3() {
        
        let titles = ["我可以", "居中", "显示", "哦"]

        let layout = LTLayout()
        layout.sliderWidth = 50
        layout.titleMargin = 10.0
        // （屏幕宽度 - 标题总宽度 - 标题间距宽度） / 2 = 最左边以及最右边剩余
        let lrMargin = (view.bounds.width - (CGFloat(titles.count) * layout.sliderWidth + CGFloat(titles.count - 1) * layout.titleMargin)) * 0.5
        layout.lrMargin = lrMargin
        layout.isAverage = true
        
        var viewControllers = [UIViewController]()
        for _ in titles {
            viewControllers.append(LTPageViewTestOneVC())
        }
        
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE - 40), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout)
        pageView.isClickScrollAnimation = true
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        view.addSubview(pageView)
    }
}

//MARK: 自定义badge
extension LTPageViewMoreDemo {
    
    @objc private func style4() {
        let layout = LTLayout()
        layout.titleMargin = 15
        layout.lrMargin = 15
        layout.isNeedScale = true
        let titles = ["添加背景图片", "自定义badge", "我是富文本", "修改位置", "更多样式"]
        var viewControllers = [UIViewController]()
        for _ in titles {
            viewControllers.append(LTPageViewTestOneVC())
        }
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE - 40), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout, itemViewClass: LTCustomTitleItemView.self)
        pageView.isClickScrollAnimation = true
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        view.addSubview(pageView)
    }
}
