//
//  LTAdvancedViewController.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/24.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit
import MJRefresh

private let kHeaderHeight: CGFloat = 180.0

class LTAdvancedViewController: UIViewController {
    
    var contentTableView: UITableView?
    var currentIndex: Int = 0
    var lastDiffTitleToNav:CGFloat = 180.0
    
    fileprivate lazy var headerView: LTHeaderView = {
        let headerView = LTHeaderView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: kHeaderHeight))
        headerView.backgroundColor = UIColor.yellow
        return headerView
    }()
    
    fileprivate let viewControllers = [LTAdvancedTestOneVC(),LTAdvancedTestTwoVC(),LTAdvancedTestThreeVC(),LTAdvancedTestFourVC()]
    
    fileprivate lazy var pageView: LTPageView = {
        
        let titles = ["嘿嘿", "呵呵", "哈哈", "嘻嘻"]
        let layout = LTLayout()
        layout.titleColor = UIColor.white
        layout.titleViewBgColor = UIColor.gray
        layout.titleSelectColor = UIColor.red
        let pageView = LTPageView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height  - 64), currentViewController: self, viewControllers: self.viewControllers, titles: titles, layout:layout)
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        pageView.pageTitleView.frame.origin.y = 180
        view.backgroundColor = UIColor.white
        view.addSubview(pageView)
        registerNotification()
        pageViewDidSelect()
        view.addSubview(headerView)
        
        pageView.addChildVcBlock = {(_, VC) -> Void in
            if case let vc as LTAdvancedBaseViewController = VC {
                vc.scrollView?.contentOffset.y = -(self.pageView.pageTitleView.frame.origin.y + 44)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }
    
}



extension LTAdvancedViewController {
    func pageViewDidSelect()  {
        pageView.didSelectIndexBlock = { (_ , index) in
            print("点击切换位置--当前位置-> \(index)")
            self.currentIndex = index
            //            let vc = self.viewControllers[index]
            //             vc.scrollView?.contentOffset.y = -(self.pageView.pageTitleView.frame.origin.y + 44)
        }
    }
}

extension LTAdvancedViewController {
    
    fileprivate func registerNotification()  {
        NotificationCenter.default.addObserver(self, selector: #selector(contentScrollViewDidScroll(_:)), name: kContentScrollViewNotification, object: nil)
    }
    
    fileprivate func removeNotification()  {
        NotificationCenter.default.removeObserver(self, name: kContentScrollViewNotification, object: nil)
    }
    
    private func calculatePageTitleViewY(_ absOffset: CGFloat, _ offsetY: CGFloat) -> CGFloat {
        
        //从导航栏底部开始 到 初始位置y的值
        var pageTitleViewY = pageView.pageTitleView.frame.origin.y
        //page titleView底部上移的距离
        let titleViewBottomDistance = offsetY + 180 + 44
        //headerView的整体偏移量
        let headerViewOffset = titleViewBottomDistance + pageTitleViewY
        
        if absOffset > 0 && titleViewBottomDistance > 0
        {
            if headerViewOffset >= 180 {
                pageTitleViewY += -absOffset
                if pageTitleViewY <= 0 {
                    pageTitleViewY = 0
                }
            }
            print("up up . -----", titleViewBottomDistance)
        }
        else
        {
            if headerViewOffset <= 180 {
                pageTitleViewY = -titleViewBottomDistance + 180
                if pageTitleViewY >= 180 {
                    pageTitleViewY = 180
                }
                print("down down",titleViewBottomDistance, pageTitleViewY)
            }
        }
        return pageTitleViewY
    }
    
    
    @objc func contentScrollViewDidScroll(_ notification: Notification)  {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let contentScrollView = userInfo["contentScrollView"] as! UIScrollView
        //上一下停止位置与当前位置的偏移量
        let absOffset = userInfo["absOffset"] as! CGFloat
        let baseVc = viewControllers[self.currentIndex]
        let offsetY = contentScrollView.contentOffset.y
        if baseVc.scrollView != contentScrollView {
            return
        }
        
        /*
         * 向上滑动（0-180）：从初始位置开始上移的距离 + 从导航栏底部开始headerView.y的值 = headerView的高度， 此时headerView的y应该随着scrollview上次和本次的差值的改变而改变
         * 如果上面的值 大于 180 说明 tableView的contentOffset开始大于0， 此时headerView的y值应该固定为0
         * 向下滑动：从初始位置开始上移的距离(负数) + 从导航栏底部开始headerView.y的值 肯定小于 headerView的高度，此时headerView的y应该为 从初始位置开始上移的距离 加上 headerView的高度
         */
        
        //从导航栏底部开始 到 初始位置y的值
        var pageTitleViewY = pageView.pageTitleView.frame.origin.y
        //page titleView底部上移的距离
        let titleViewBottomDistance = offsetY + 180 + 44
        //headerView的整体偏移量
        let headerViewOffset = titleViewBottomDistance + pageTitleViewY
        
        
        if absOffset > 0 && titleViewBottomDistance > 0
        {
            if headerViewOffset >= 180 {
                pageTitleViewY += -absOffset
                if pageTitleViewY <= 0 {
                    pageTitleViewY = 0
                }
            }
            print("up up . -----", titleViewBottomDistance)
        }
        else
        {
            if headerViewOffset <= 180 {
                pageTitleViewY = -titleViewBottomDistance + 180
                if pageTitleViewY >= 180 {
                    pageTitleViewY = 180
                }
                print("down down",titleViewBottomDistance, pageTitleViewY)
            }
        }
        
        
        pageView.pageTitleView.frame.origin.y = pageTitleViewY
        headerView.frame.origin.y = pageTitleViewY - 180 + 64
        // 如果其他页面已经加载 则改变其他页面的偏移量 改变的原理依旧是通过上次和本次的差值进行计算
        let lastDiffTitleToNavOffset = pageTitleViewY - lastDiffTitleToNav
        lastDiffTitleToNav = pageTitleViewY
        for VC in viewControllers {
            if VC != baseVc && VC.scrollView != nil {
                VC.scrollView!.contentOffset.y += (-lastDiffTitleToNavOffset)
            }
        }
        
    }
}

