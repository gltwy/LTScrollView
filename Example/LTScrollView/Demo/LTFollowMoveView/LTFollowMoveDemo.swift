//
//  LTFollowMoveDemo.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LTFollowMoveDemo: UIViewController, LTFollowMoveViewDelegate {

    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 0, y: returnHeight, width: view.glt_width, height: 50)
        cancelButton.setTitle("点击弹出", for: .normal)
        cancelButton.backgroundColor = .red
        cancelButton.addTarget(self, action: #selector(jump), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var moveView: LTFollowMoveTestView = {
        let moveView = LTFollowMoveTestView(frame: CGRect(x: 0, y: 0, width: self.view.glt_width, height: returnHeight))
        return moveView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(cancelButton)
    }
    
    @objc func jump() {
        let testView = LTFollowMoveView(frame: UIScreen.main.bounds, contentView: self.moveView)
        testView.delegate = self
        /**
        testView.stretchRate = 0.5
        testView.isTapHide = true
        testView.isQuickPanHide = false
        testView.isCanPanBlank = true
        testView.willShowHandle = {
            print("即将展示 - 1")
        }
        testView.showFinishedHandle = {
            print("展示完成 - 1")
        }
        testView.dismissFinishedHandle = {
            print("消失完成 - 1")
        }
         */
        testView.show(inView: self.view)
    }
    
    func showFinished(followView: LTFollowMoveView) {
        print("展示完成 - 2")
    }
    
    func dismissFinished(followView: LTFollowMoveView) {
        print("消失完成 - 2")
    }
    
    func willShow(followView: LTFollowMoveView) {
        print("即将展示 - 2")
    }
    
}
