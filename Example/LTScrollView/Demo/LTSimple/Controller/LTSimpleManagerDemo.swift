//
//  LTSimpleManagerDemo.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//
//  如有疑问，请搜索并关注微信公众号"技术大咖社"并留言即可
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

//let GLT_STATUSHEIGHT = UIApplication.shared.statusBarFrame.height
////此处在项目开发中，注意iPhone mini的导航栏的真实高度，可以通过self.navigationController?.navigationBar.frame获取，这里不再列出
//let GLT_NAVCHEIGHT: CGFloat = GLT_STATUSHEIGHT >= 44 ? 88 : 64
//var glt_iphoneX: Bool {
//    if #available(iOS 11.0, *) {
//        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
//    } else {
//        return false
//    }
//}

import UIKit
import MJRefresh

class LTSimpleManagerDemo: UIViewController {
    
    private lazy var titles: [String] = {
        return ["此处标题View支持", "自定义", "查看", "LTPageView具体使用"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for _ in titles {
            vcs.append(LTSimpleTestOneVC())
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
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    private lazy var simpleManager: LTSimpleManager = {
        let simpleManager = LTSimpleManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout/*, itemViewClass: LTCustomTitleItemView.self*/)
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self
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
        print("LTSimpleManagerDemo < --> deinit")
    }
}


extension LTSimpleManagerDemo {
    
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

extension LTSimpleManagerDemo: LTSimpleScrollViewDelegate {
    
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

extension LTSimpleManagerDemo {
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

