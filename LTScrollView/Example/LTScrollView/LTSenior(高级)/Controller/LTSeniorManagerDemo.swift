//
//  LTSeniorManagerDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//
/*
 * github地址
 * https://github.com/gltwy/LTScrollView
 *
 * git 下载地址
 * https://github.com/gltwy/LTScrollView.git
 */
import UIKit

class LTSeniorManagerDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: view.bounds)
        label.text = "近期更新，敬请期待！🙂"
        label.textAlignment = .center
        view.addSubview(label)
        
    }

}
