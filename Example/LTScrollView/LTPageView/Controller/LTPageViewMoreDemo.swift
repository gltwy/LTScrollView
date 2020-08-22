//
//  LTPageViewMoreDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2020/8/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

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
            style1()
            break
        case .setStyle:
            style2()
            break
        case .setStyleOther:
            style3()
            break
        case .customStyle:
            style4()
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
        layout.sliderWidth = 15
        
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
        layout.titleMargin = 5
        
        //自定义每一个item的宽度
        layout.layoutItemWidths = [150, 120, 90, 100, 80]
        
        //此处如果不设置为false，将来取每一个itemView的时候frame由于缩放效果会导致frame改变
        //如果为true可以从 layout.layoutItemWidths 取值这样不会影响内部布局
        layout.isNeedScale = false
        
        let titles = ["添加背景图片", "自定义badge", "我是富文本", "修改位置", "更多样式"]
        
        var viewControllers = [UIViewController]()
        for _ in titles {
            viewControllers.append(LTPageViewTestOneVC())
        }
        
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE - 40), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout)
        
        pageView.isClickScrollAnimation = true
        
        //在此处自定义itemView
        pageView.customLayoutItems {[weak self] (itemViews, _) in
            for (index, itemView) in itemViews.enumerated() {
                self?.customStyle(itemView: itemView, index: index)
            }
        }
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        view.addSubview(pageView)
    }
    
    //注意layoutItemWidths使用说明
    private func customStyle(itemView: LTPageTitleItemView, index: Int) {
        itemView.backgroundColor = .randomColor
        
        switch index {
        case 0:
            let imageView = UIImageView()
            imageView.image = UIImage(named: "test")
            imageView.glt_size = CGSize(width: 120, height: 30)
            //isNeedScale 为true此处 itemView.glt_width 替换为 layout.layoutItemWidths[index]
            imageView.glt_left = (itemView.glt_width - imageView.glt_width) * 0.5
            imageView.glt_centerY = itemView.glt_centerY
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            itemView.insertSubview(imageView, at: 0)
            break
        case 1:
            let badgeView = UIView()
            badgeView.backgroundColor = .red
            badgeView.frame = CGRect(x: itemView.glt_width - 15, y: 5, width: 10, height: 10)
            let maskPath = UIBezierPath(roundedRect: badgeView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = badgeView.bounds
            maskLayer.path = maskPath.cgPath
            badgeView.layer.mask = maskLayer
            itemView.addSubview(badgeView)
            break
        case 2:
            //富文本选中以后的处理可以根据选中index位置自己设置
            let itemTitle = itemView.titleLabel?.text ?? ""
            let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: itemView.glt_width, height: itemView.glt_height))
            titleLabel.font = UIFont.systemFont(ofSize: 10)
            titleLabel.textAlignment = .center
            let attr = NSMutableAttributedString(string: itemTitle)
            attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: (itemTitle as NSString).range(of: "我是"))
            attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.randomColor], range: (itemTitle as NSString).range(of: "富文本"))
            titleLabel.attributedText = attr
            itemView.addSubview(titleLabel)
            itemView.setTitle("", for: .normal)
            break
        case 3:
            itemView.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: -10, right: 0)
            break
        default:
            break
        }
    }
    
}
