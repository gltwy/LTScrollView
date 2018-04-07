//
//  LTPageView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

public let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)

public class LTLayout: NSObject {
    public var titleColor: UIColor? = UIColor.white
    public var titleSelectColor: UIColor? = UIColor.blue
    public var titleViewBgColor: UIColor? = UIColor.gray
    public var titleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    public var bottomLineColor: UIColor? = UIColor.blue
    public var sliderHeight: CGFloat?
    public var bottomLineHeight: CGFloat?
}

public typealias pageViewDidSelectIndexBlock = (LTPageView, Int) -> Void
public typealias addChildViewControllerBlock = (Int, UIViewController) -> Void

public class LTPageView: UIView {
    
    private var currentViewController: UIViewController
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var layout: LTLayout = LTLayout()
    public var didSelectIndexBlock: pageViewDidSelectIndexBlock?
    public var addChildVcBlock: addChildViewControllerBlock?
    
    public var titleViewY: CGFloat? {
        didSet {
            guard let updateY = titleViewY else { return }
            pageTitleView.frame.origin.y = updateY
        }
    }
    
    public lazy var pageTitleView: UIView = {
        let pageTitleView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.layout.sliderHeight ?? 44.0))
        pageTitleView.backgroundColor = self.layout.titleViewBgColor
        return pageTitleView
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: self.pageTitleView.bounds.height - (self.layout.bottomLineHeight ?? 2.0), width: 0, height: self.layout.bottomLineHeight ?? 2.0))
        lineView.backgroundColor = self.layout.bottomLineColor
        return lineView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        scrollView.contentSize = CGSize(width: self.bounds.width * CGFloat(self.titles.count), height: 0)
        scrollView.tag = 302
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        return scrollView
    }()
    
    
    public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout) {
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(pageTitleView)
        buttonsLayout()
        pageTitleView.addSubview(lineView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LTPageView {
    private func buttonsLayout()
    {
        let totalW = bounds.width
        let subW = totalW / CGFloat(titles.count)
        let subY: CGFloat = 0
        let subH = pageTitleView.bounds.height - (self.layout.bottomLineHeight ?? 2.0)
        lineView.frame.size.width = subW
        for index in 0..<titles.count {
            let subX = subW * CGFloat(index)
            let button = subButton(frame: CGRect(x: subX, y: subY, width: subW, height: subH), flag: index, title: titles[index], parentView: pageTitleView)
            if index == 0 {
                button.isEnabled = false
                createViewController(0)
            }
        }
    }
    
    @discardableResult
    private func subButton(frame: CGRect, flag: Int, title: String?, parentView: UIView) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.tag = flag
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(titleSelectIndex(_:)), for: .touchUpInside)
        button.setTitleColor(layout.titleSelectColor, for: .disabled)
        button.setTitleColor(layout.titleColor, for: .normal)
        button.titleLabel?.font = layout.titleFont
        parentView.addSubview(button)
        return button
    }
    
    @objc private func titleSelectIndex(_ btn: UIButton)  {
        let totalW = bounds.width
        scrollView.setContentOffset(CGPoint(x: totalW * CGFloat(btn.tag), y: 0), animated: true)
    }
}

extension LTPageView {
    private func createViewController(_ index: Int)  {
        let VC = viewControllers[index]
        if currentViewController.childViewControllers.contains(VC) {
            return
        }
        currentViewController.addChildViewController(VC)
        VC.view.frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(VC.view)
        guard let addChildVcBlock = addChildVcBlock else {
            return
        }
        addChildVcBlock(index, VC)
    }
    
    private func scrollViewDidScrollOffsetX(_ offsetX: CGFloat)  {
        let scrllW = scrollView.bounds.size.width
        let abs = offsetX.truncatingRemainder(dividingBy: scrllW)
        lineView.frame.origin.x = offsetX / CGFloat(titles.count)
        if abs == 0 {
            let contentIndex = Int(offsetX / scrllW)
            for tempView in pageTitleView.subviews{
                if tempView.isKind(of: UIButton.self){
                    let button = tempView as! UIButton
                    if button.tag == contentIndex{
                        button.isEnabled = false
                    }else{
                        button.isEnabled = true
                    }
                }
            }
            createViewController(contentIndex)
            guard let didSelectIndexBlock = didSelectIndexBlock else {
                return
            }
            didSelectIndexBlock(self, contentIndex)
        }
    }
}

extension LTPageView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        scrollViewDidScrollOffsetX(offsetX)
    }
}


