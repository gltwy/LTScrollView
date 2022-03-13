//
//  LTMixPageSimpleDemo.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import MJRefresh

class LTMixPageSimpleDemo: UIViewController {
    
    private lazy var titles: [String] = {
        return ["必须", "设置LTSimpleManager", "内isSimpeMix", "属性为true", "否则联动无效"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for _ in titles {
            vcs.append(LTMixPageSimpleChildViewController())
        }
        return vcs
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.bottomLineHeight = 2.0
        layout.titleFont = UIFont.systemFont(ofSize: 13)
        layout.bottomLineCornerRadius = 1.0
        layout.lrMargin = 20;
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 , 自定义样式请参考LTPageView */
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let H: CGFloat = view.bounds.height - GLT_NAVCHEIGHT - GLT_BOTTOMSPACE - 44
        return CGRect(x: 0, y: 0, width: view.bounds.width, height: H)
    }
    
    private lazy var simpleManager: LTSimpleManager = {
        let simpleManager = LTSimpleManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self
        simpleManager.isSimpeMix = true
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
    
    deinit {
        print("LTMixPageSimpleDemo < --> deinit")
    }
}


extension LTMixPageSimpleDemo {
    
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
        
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
}

extension LTMixPageSimpleDemo: LTSimpleScrollViewDelegate {
    
    //MARK: 滚动代理方法
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("offset -> ", scrollView.contentOffset.y)
    }
    
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        //注意这里循环引用问题。
        scrollView.mj_header = MJRefreshNormalHeader {[weak scrollView] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
                scrollView?.mj_header.endRefreshing()
            })
        }
    }
}

extension LTMixPageSimpleDemo {
    private func testLabel() -> UILabel {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 180))
        headerView.backgroundColor = UIColor.red
        headerView.text = "点击响应事件"
        headerView.textColor = UIColor.white
        headerView.textAlignment = .center
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))
        return headerView
    }
}

