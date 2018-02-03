//
//  LTSeniorManagerDemo.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class LTSeniorManagerDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: view.bounds.height))
        label.text = "近期更新，敬请期待！🙂"
        label.textAlignment = .center
        view.addSubview(label)
        
    }

}
