//
//  LTPageView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

let NORMAL_BASE_COLOR: UIColor = UIColor(r: 0, g: 0, b: 0)
let SELECT_BASE_COLOR: UIColor = UIColor(r: 255, g: 0, b: 0)

public let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)

private let glt_sliderDefaultWidth: CGFloat = 40.010101010
public class LTLayout: NSObject {
    
    /* pageView背景颜色 */
    @objc public var titleViewBgColor: UIColor? = UIColor(r: 255, g: 239, b: 213)
    
    /* 标题颜色，请使用RGB赋值 */
    @objc public var titleColor: UIColor? = NORMAL_BASE_COLOR
    
    /* 标题选中颜色，请使用RGB赋值 */
    @objc public var titleSelectColor: UIColor? = SELECT_BASE_COLOR
    
    /* 标题字号 */
    @objc public var titleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    
    /* 滑块底部线的颜色 - UIColor.blue */
    @objc public var bottomLineColor: UIColor? = UIColor.red
    
    /* 整个滑块的高，pageTitleView的高 */
    @objc public var sliderHeight: CGFloat = 44.0
    
    /* 单个滑块的宽度, 一旦设置，将不再自动计算宽度，而是固定为你传递的值 */
    @objc public var sliderWidth: CGFloat = glt_sliderDefaultWidth
    
    /*
     * 如果刚开始的布局不希望从最左边开始， 只想平均分配在整个宽度中，设置它为true
     * 注意：此时最左边 lrMargin 以及 titleMargin 仍然有效，如果不需要可以手动设置为0
     */
    @objc public var isAverage: Bool = false
    
    /* 滑块底部线的高 */
    @objc public var bottomLineHeight: CGFloat = 2.0
    
    /* 滑块底部线圆角 */
    @objc public var bottomLineCornerRadius: CGFloat = 0.0
    
    /* 是否隐藏滑块、底部线*/
    @objc public var isHiddenSlider: Bool = false
    
    /* 标题直接的间隔（标题距离下一个标题的间隔）*/
    @objc public var titleMargin: CGFloat = 30.0
    
    /* 距离最左边和最右边的距离 */
    @objc public var lrMargin: CGFloat = 10.0
    
    /* 滑动过程中是否放大标题 */
    @objc public var isNeedScale: Bool = true
    
    /* 放大标题的倍率 */
    @objc public var scale: CGFloat = 1.2
    
    /* 是否开启颜色渐变 */
    @objc public var isColorAnimation: Bool = true
    
    /* 是否隐藏底部线 */
    @objc public var isHiddenPageBottomLine: Bool = false
    
    /* pageView底部线的高度 */
    @objc public var pageBottomLineHeight: CGFloat = 0.5
    
    /* pageView底部线的颜色 */
    @objc public var pageBottomLineColor: UIColor? = UIColor(r: 230, g: 230, b: 230)
    
    /* pageView的内容ScrollView是否开启左右弹性效果 */
    @objc public var isShowBounces: Bool = false
    
    /* pageView的内容ScrollView是否开启左右滚动 */
    @objc public var isScrollEnabled: Bool = true
    
    /* 内部使用-外界不要调用 */
    var isSinglePageView: Bool = false
}

public typealias PageViewDidSelectIndexBlock = (LTPageView, Int) -> Void
public typealias AddChildViewControllerBlock = (Int, UIViewController) -> Void

@objc public protocol LTPageViewDelegate: class {
    @objc optional func glt_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func glt_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}

public class LTPageView: UIView {
    
    private weak var currentViewController: UIViewController?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var layout: LTLayout = LTLayout()
    
    private var glt_currentIndex: Int = 0;
    private var glt_buttons: [UIButton] = []
    private var glt_textWidths: [CGFloat] = []
    private var glt_startOffsetX: CGFloat = 0.0
    private var glt_clickIndex: Int = 0
    private var isClick: Bool = false
    private var isFirstLoad: Bool = true
    private var glt_lineWidths: [CGFloat] = []
    
    private var glt_isClickScrollAnimation = false
    
    @objc public var didSelectIndexBlock: PageViewDidSelectIndexBlock?
    
    @objc public var addChildVcBlock: AddChildViewControllerBlock?
    
    /* 点击切换滚动过程动画  */
    @objc public var isClickScrollAnimation = false
    
    /* pageView的scrollView左右滑动监听 */
    @objc public weak var delegate: LTPageViewDelegate?
    
    private lazy var glt_titleRGBlColor: (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(layout.titleColor ?? NORMAL_BASE_COLOR)
    
    private lazy var glt_selectTitleRGBlColor: (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(layout.titleSelectColor ?? SELECT_BASE_COLOR)
    
    public var titleViewY: CGFloat? {
        didSet {
            guard let updateY = titleViewY else { return }
            pageTitleView.frame.origin.y = updateY
        }
    }
    
    public lazy var pageTitleView: UIView = {
        let pageTitleView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.layout.sliderHeight))
        pageTitleView.backgroundColor = self.layout.titleViewBgColor
        return pageTitleView
    }()
    
    private lazy var sliderLineView: UIView = {
        let sliderLineView = UIView(frame: CGRect(x: self.layout.lrMargin, y: self.pageTitleView.bounds.height - layout.bottomLineHeight - layout.pageBottomLineHeight, width: 0, height: self.layout.bottomLineHeight))
        sliderLineView.backgroundColor = self.layout.bottomLineColor
        return sliderLineView
    }()
    
    private lazy var pageBottomLineView: UIView = {
        let pageBottomLineView = UIView(frame: CGRect(x: 0, y: self.pageTitleView.bounds.height - (self.layout.pageBottomLineHeight), width: pageTitleView.bounds.width, height: self.layout.pageBottomLineHeight))
        pageBottomLineView.backgroundColor = self.layout.pageBottomLineColor
        return pageBottomLineView
    }()
    
    private lazy var sliderScrollView: UIScrollView = {
        let sliderScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: pageTitleView.bounds.width, height: pageTitleView.bounds.height))
        sliderScrollView.tag = 403
        sliderScrollView.showsHorizontalScrollIndicator = false
        sliderScrollView.bounces = false
        return sliderScrollView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        scrollView.contentSize = CGSize(width: self.bounds.width * CGFloat(self.titles.count), height: 0)
        scrollView.tag = 302
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = layout.isShowBounces
        scrollView.isScrollEnabled = layout.isScrollEnabled
        return scrollView
    }()
    
    
    @objc public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout) {
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            sliderScrollView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(scrollView)
        addSubview(pageTitleView)
        buttonsLayout()
        pageTitleView.addSubview(sliderScrollView)
        sliderScrollView.addSubview(sliderLineView)
        pageTitleView.addSubview(pageBottomLineView)
        pageTitleView.isHidden = layout.isHiddenPageBottomLine
        sliderLineView.isHidden = layout.isHiddenSlider
        if layout.isHiddenSlider {
            sliderLineView.frame.size.height = 0.0
        }
    }
    
    /* 滚动到某个位置 */
    @objc public func scrollToIndex(index: Int)  {
        
        var index = index
        if index >= titles.count {
            print("超过最大数量限制, 请正确设置值, 默认这里取第一个")
            index = 0
        }
        
        if isClickScrollAnimation {
            
            let nextButton = glt_buttons[index]
            
            if layout.sliderWidth == glt_sliderDefaultWidth {
                
                if layout.isAverage {
                    let adjustX = (nextButton.frame.size.width - glt_lineWidths[index]) * 0.5
                    sliderLineView.frame.origin.x = nextButton.frame.origin.x + adjustX
                    sliderLineView.frame.size.width = glt_lineWidths[index]
                }else {
                    sliderLineView.frame.origin.x = nextButton.frame.origin.x
                    sliderLineView.frame.size.width = nextButton.frame.width
                }
                
            }else {
                if isFirstLoad {
                    setupSliderLineViewWidth(currentButton: glt_buttons[index])
                    isFirstLoad = false
                }
            }
        }
        
        setupTitleSelectIndex(index)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LTPageView {
    
    
    private func buttonsLayout() {
        
        if titles.count == 0 { return }
        
        
        // 将所有的宽度计算出来放入数组
        for text in titles {
            
            if layout.isAverage {
                let textAverageW = (pageTitleView.bounds.width - layout.lrMargin * 2.0 - layout.titleMargin * CGFloat(titles.count - 1)) / CGFloat(titles.count)
                glt_textWidths.append(textAverageW)
            }else {
                if text.count == 0 {
                    glt_textWidths.append(60)
                    glt_lineWidths.append(60)
                    continue
                }
            }
            
            let textW = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 8), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : layout.titleFont ?? UIFont.systemFont(ofSize: 16)], context: nil).size.width
            
            if !layout.isAverage {
                glt_textWidths.append(textW)
            }
            glt_lineWidths.append(textW)
        }
        
        
        
        // 按钮布局
        var upX: CGFloat = layout.lrMargin
        let subH = pageTitleView.bounds.height - (self.layout.bottomLineHeight)
        let subY: CGFloat = 0
        
        for index in 0..<titles.count {
            
            let subW = glt_textWidths[index]
            
            let button = subButton(frame: CGRect(x: upX, y: subY, width: subW, height: subH), flag: index, title: titles[index], parentView: sliderScrollView)
            button.setTitleColor(layout.titleColor, for: .normal)
            
            if index == 0 {
                button.setTitleColor(layout.titleSelectColor, for: .normal)
                createViewController(0)
            }
            
            upX = button.frame.origin.x + subW + layout.titleMargin
            
            glt_buttons.append(button)
            
        }
        
        if layout.isNeedScale {
            glt_buttons[0].transform = CGAffineTransform(scaleX: layout.scale , y: layout.scale)
        }
        
        // lineView的宽度为第一个的宽度
        if layout.sliderWidth == glt_sliderDefaultWidth {
            if layout.isAverage {
                sliderLineView.frame.size.width = glt_lineWidths[0]
                sliderLineView.frame.origin.x = (glt_textWidths[0] - glt_lineWidths[0]) * 0.5 + layout.lrMargin
            }else {
                sliderLineView.frame.size.width = glt_buttons[0].frame.size.width
                sliderLineView.frame.origin.x = glt_buttons[0].frame.origin.x
            }
        }else {
            sliderLineView.frame.size.width = layout.sliderWidth
            sliderLineView.frame.origin.x = ((glt_textWidths[0] + layout.lrMargin * 2) - layout.sliderWidth) * 0.5
        }
        
        if layout.bottomLineCornerRadius != 0.0 {
            sliderLineView.layer.cornerRadius = layout.bottomLineCornerRadius
            sliderLineView.layer.masksToBounds = true
            sliderLineView.clipsToBounds = true
        }
        
        if layout.isAverage {
            sliderScrollView.contentSize = CGSize(width: pageTitleView.bounds.width, height: 0)
            return
        }
        
        // 计算sliderScrollView的contentSize
        let sliderContenSizeW = upX - layout.titleMargin + layout.lrMargin
        
        if sliderContenSizeW < scrollView.bounds.width {
            sliderScrollView.frame.size.width = sliderContenSizeW
        }
        
        //最后多加了一个 layout.titleMargin， 这里要减去
        sliderScrollView.contentSize = CGSize(width: sliderContenSizeW, height: 0)
        
    }
    
    @objc private func titleSelectIndex(_ btn: UIButton)  {
        
        setupTitleSelectIndex(btn.tag)
        
    }
    
    private func setupTitleSelectIndex(_ btnSelectIndex: Int) {
        
        if glt_currentIndex == btnSelectIndex || scrollView.isDragging || scrollView.isDecelerating {
            return
        }
        
        let totalW = bounds.width
        
        isClick = true
        glt_isClickScrollAnimation = true
        
        
        scrollView.setContentOffset(CGPoint(x: totalW * CGFloat(btnSelectIndex), y: 0), animated: isClickScrollAnimation)
        
        
        if isClickScrollAnimation {
            return
        }
        
        let nextButton = glt_buttons[btnSelectIndex]
        
        if layout.sliderWidth == glt_sliderDefaultWidth {
            
            if layout.isAverage {
                let adjustX = (nextButton.frame.size.width - glt_lineWidths[btnSelectIndex]) * 0.5
                sliderLineView.frame.origin.x = nextButton.frame.origin.x + adjustX
                sliderLineView.frame.size.width = glt_lineWidths[btnSelectIndex]
            }else {
                sliderLineView.frame.origin.x = nextButton.frame.origin.x
                sliderLineView.frame.size.width = nextButton.frame.width
            }
            
        }else {
            setupSliderLineViewWidth(currentButton: nextButton)
        }
        
        glt_currentIndex = btnSelectIndex
        
    }
    
    
    // currentButton将要滚动到的按钮
    private func setupSliderLineViewWidth(currentButton: UIButton)  {
        let maxLeft = currentButton.frame.origin.x - layout.lrMargin
        let maxRight = maxLeft + layout.lrMargin * 2 + currentButton.frame.size.width
        let originX = (maxRight - maxLeft - layout.sliderWidth) * 0.5  + maxLeft
        sliderLineView.frame.origin.x = originX
        sliderLineView.frame.size.width = layout.sliderWidth
    }
    
}

extension LTPageView {
    
    private func createViewController(_ index: Int)  {
        let VC = viewControllers[index]
        guard let currentViewController = currentViewController else { return }
        if currentViewController.childViewControllers.contains(VC) {
            return
        }
        var viewControllerY: CGFloat = 0.0
        layout.isSinglePageView ? viewControllerY = 0.0 : (viewControllerY = layout.sliderHeight)
        VC.view.frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: viewControllerY, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(VC.view)
        currentViewController.addChildViewController(VC)
        VC.automaticallyAdjustsScrollViewInsets = false
        addChildVcBlock?(index, VC)
        if let glt_scrollView = VC.glt_scrollView {
            if #available(iOS 11.0, *) {
                glt_scrollView.contentInsetAdjustmentBehavior = .never
            }
            glt_scrollView.frame.size.height = glt_scrollView.frame.size.height - viewControllerY
        }
    }
    
    private func scrollViewDidScrollOffsetX(_ offsetX: CGFloat)  {
        
        _ = setupLineViewX(offsetX: offsetX)
        
        let index = currentIndex()
        
        if glt_currentIndex != index {
            
            //如果开启滚动动画
            if isClickScrollAnimation {
                //如果不是点击事件继续在这个地方设置偏移
                if !glt_isClickScrollAnimation {
                    setupSlierScrollToCenter(offsetX: offsetX, index: index)
                }
            }else {
                //设置滚动的位置
                setupSlierScrollToCenter(offsetX: offsetX, index: index)
            }
            
            // 如果是点击的话
            if isClick {
                
                let upButton = glt_buttons[glt_currentIndex]
                
                let currentButton = glt_buttons[index]
                
                if layout.isNeedScale {
                    UIView.animate(withDuration: 0.2, animations: {
                        currentButton.transform = CGAffineTransform(scaleX: self.layout.scale , y: self.layout.scale)
                        upButton.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0 )
                    })
                }
                
                setupButtonStatusAnimation(upButton: upButton, currentButton: currentButton)
                
            }
            
            if layout.isColorAnimation == false {
                let upButton = glt_buttons[glt_currentIndex]
                let currentButton = glt_buttons[index]
                setupButtonStatusAnimation(upButton: upButton, currentButton: currentButton)
            }
            
            //如果开启滚动动画
            if isClickScrollAnimation {
                //如果不是点击事件继续在这个地方设置偏移
                if !glt_isClickScrollAnimation {
                    
                    createViewController(index)
                    
                    didSelectIndexBlock?(self, index)
                }
            }else {
                //默认的设置
                createViewController(index)
                
                didSelectIndexBlock?(self, index)
            }
            
            glt_currentIndex = index
            
        }
        
        
        isClick = false
        
    }
    
    private func setupIsClickScrollAnimation(index: Int) {
        if !isClickScrollAnimation {
            return
        }
        for button in glt_buttons {
            if button.tag == index {
                if layout.isNeedScale {
                    button.transform = CGAffineTransform(scaleX: layout.scale , y: layout.scale)
                }
                button.setTitleColor(self.layout.titleSelectColor, for: .normal)
            }else {
                if layout.isNeedScale {
                    button.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
                }
                button.setTitleColor(self.layout.titleColor, for: .normal)
            }
        }
        glt_isClickScrollAnimation = false
    }
    
    private func setupButtonStatusAnimation(upButton: UIButton, currentButton: UIButton)  {
        upButton.setTitleColor(layout.titleColor, for: .normal)
        currentButton.setTitleColor(layout.titleSelectColor, for: .normal)
    }
    
    //MARK: 让title的ScrollView滚动到中心点位置
    private func setupSlierScrollToCenter(offsetX: CGFloat, index: Int)  {
        
        let currentButton = glt_buttons[index]
        
        let btnCenterX = currentButton.center.x
        
        var scrollX = btnCenterX - sliderScrollView.bounds.width * 0.5
        
        if scrollX < 0 {
            scrollX = 0
        }
        
        if scrollX > sliderScrollView.contentSize.width - sliderScrollView.bounds.width {
            scrollX = sliderScrollView.contentSize.width - sliderScrollView.bounds.width
        }
        
        sliderScrollView.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
    }
    
    //MARK: 设置线的移动
    private func setupLineViewX(offsetX: CGFloat) -> Bool {
        
        if isClick {
            return false
        }
        
        
        //目的是改变它的值，让制滑动第一个和最后一个的时候（-0.5），导致数组下标越界
        var offsetX = offsetX
        
        let scrollW = scrollView.bounds.width
        
        // 目的是滑动到最后一个的时候 不让其再往后滑动
        if offsetX + scrollW >= scrollView.contentSize.width {
            if layout.sliderWidth == glt_sliderDefaultWidth {
                let adjustX = (glt_textWidths.last! - glt_lineWidths.last!) * 0.5
                sliderLineView.frame.origin.x = layout.lrMargin + adjustX
            }else {
                setupSliderLineViewWidth(currentButton: glt_buttons.last!)
            }
            offsetX = scrollView.contentSize.width - scrollW - 0.5
        }
        
        // 目的是滑动到第一个的时候 不让其再往前滑动
        if offsetX <= 0 {
            if layout.sliderWidth == glt_sliderDefaultWidth {
                let adjustX = (glt_textWidths[0] - glt_lineWidths[0]) * 0.5
                sliderLineView.frame.origin.x = layout.lrMargin + adjustX
            }else {
                sliderLineView.frame.origin.x = ((glt_textWidths[0] + layout.lrMargin * 2) - layout.sliderWidth) * 0.5
            }
            offsetX = 0.5
        }
        
        var nextIndex = Int(offsetX / scrollW)
        
        var sourceIndex = Int(offsetX / scrollW)
        
        //向下取整 目的是减去整数位，只保留小数部分
        var progress = (offsetX / scrollW) - floor(offsetX / scrollW)
        
        if offsetX > glt_startOffsetX { // 向左滑动
            
            //向左滑动 下个位置比源位置下标 多1
            nextIndex = nextIndex + 1
            
        }else { // 向右滑动
            
            //向右滑动 由于源向下取整的缘故 必须补1 nextIndex则恰巧是原始位置
            sourceIndex = sourceIndex + 1
            
            progress = 1 - progress
            
        }
        
        let nextButton = glt_buttons[nextIndex]
        
        let currentButton = glt_buttons[sourceIndex]
        
        if layout.isColorAnimation {
            
            let colorDelta = (glt_selectTitleRGBlColor.0 - glt_titleRGBlColor.0, glt_selectTitleRGBlColor.1 - glt_titleRGBlColor.1, glt_selectTitleRGBlColor.2 - glt_titleRGBlColor.2)
            
            let nextColor = UIColor(r: glt_titleRGBlColor.0 + colorDelta.0 * progress, g: glt_titleRGBlColor.1 + colorDelta.1 * progress, b: glt_titleRGBlColor.2 + colorDelta.2 * progress)
            
            let currentColor = UIColor(r: glt_selectTitleRGBlColor.0 - colorDelta.0 * progress, g: glt_selectTitleRGBlColor.1 - colorDelta.1 * progress, b: glt_selectTitleRGBlColor.2 - colorDelta.2 * progress)
            
            currentButton.setTitleColor(currentColor, for: .normal)
            nextButton.setTitleColor(nextColor, for: .normal)
            
        }
        
        if layout.isNeedScale {
            let scaleDelta = (layout.scale - 1.0) * progress
            currentButton.transform = CGAffineTransform(scaleX: layout.scale - scaleDelta, y: layout.scale - scaleDelta)
            nextButton.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        // 判断是否是自定义Slider的宽度（这里指没有自定义）
        if layout.sliderWidth == glt_sliderDefaultWidth {
            
            if layout.isAverage {
                /*
                 * 原理：（按钮的宽度 - 线的宽度）/ 2 = 线的X便宜量
                 * 如果是不是平均分配 按钮的宽度 = 线的宽度
                 */
                // 计算宽度的该变量
                let moveW = glt_lineWidths[nextIndex] - glt_lineWidths[sourceIndex]
                
                // （按钮的宽度 - 线的宽度）/ 2
                let nextButtonAdjustX = (nextButton.frame.size.width - glt_lineWidths[nextIndex]) * 0.5
                
                // （按钮的宽度 - 线的宽度）/ 2
                let currentButtonAdjustX = (currentButton.frame.size.width - glt_lineWidths[sourceIndex]) * 0.5
                
                // x的该变量
                let moveX = (nextButton.frame.origin.x + nextButtonAdjustX) - (currentButton.frame.origin.x + currentButtonAdjustX)
                
                self.sliderLineView.frame.size.width = glt_lineWidths[sourceIndex] + moveW * progress
                
                self.sliderLineView.frame.origin.x = currentButton.frame.origin.x + moveX * progress + currentButtonAdjustX
                
            }else {
                // 计算宽度的该变量
                let moveW = nextButton.frame.width - currentButton.frame.width
                
                // 计算X的该变量
                let moveX = nextButton.frame.origin.x - currentButton.frame.origin.x
                
                self.sliderLineView.frame.size.width = currentButton.frame.width + moveW * progress
                self.sliderLineView.frame.origin.x = currentButton.frame.origin.x + moveX * progress - 0.25
            }
            
        }else {
            
            
            /*
             * 原理：按钮的最左边X（因为有lrMargin，这里必须减掉） 以及 按钮的相对右边X（注意不是最右边，因为每个按钮的X都有一个lrMargin， 所以相对右边则有两个才能保证按钮的位置，这个和titleMargin无关）
             */
            let maxNextLeft = nextButton.frame.origin.x - layout.lrMargin
            let maxNextRight = maxNextLeft + layout.lrMargin * 2.0 + nextButton.frame.size.width
            let originNextX = (maxNextRight - maxNextLeft - layout.sliderWidth) * 0.5 + maxNextLeft
            
            let maxLeft = currentButton.frame.origin.x - layout.lrMargin
            let maxRight = maxLeft + layout.lrMargin * 2.0 + currentButton.frame.size.width
            let originX = (maxRight - maxLeft - layout.sliderWidth) * 0.5 + maxLeft
            
            let moveX = originNextX - originX
            
            self.sliderLineView.frame.origin.x = originX + moveX * progress
            
            sliderLineView.frame.size.width = layout.sliderWidth
        }
        
        return false
    }
    
    private func currentIndex() -> Int {
        if scrollView.bounds.width == 0 || scrollView.bounds.height == 0 {
            return 0
        }
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        return max(0, index)
    }
    
}

extension LTPageView {
    
    private func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给标题颜色赋值")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}

extension LTPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidScroll?(scrollView)
        let offsetX = scrollView.contentOffset.x
        scrollViewDidScrollOffsetX(offsetX)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDragging?(scrollView)
        glt_startOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.glt_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndScrollingAnimation?(scrollView)
        
        
        if glt_isClickScrollAnimation {
            let index = currentIndex()
            createViewController(index)
            setupSlierScrollToCenter(offsetX: scrollView.contentOffset.x, index: index)
            setupIsClickScrollAnimation(index: index)
            didSelectIndexBlock?(self, index)
        }
        
    }
}

extension LTPageView {
    
    @discardableResult
    private func subButton(frame: CGRect, flag: Int, title: String?, parentView: UIView) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.tag = flag
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(titleSelectIndex(_:)), for: .touchUpInside)
        button.titleLabel?.font = layout.titleFont
        parentView.addSubview(button)
        return button
    }
    
}

