//
//  LTFollowMoveTestView.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

let returnHeight: CGFloat = UIScreen.main.bounds.height * 0.618

class LTFollowMoveTestView: UIView, LTTableViewProtocal {
        
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.glt_width, height: 44))
        titleLabel.text = "评论-下拉拖动"
        titleLabel.backgroundColor = .green
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = tableViewConfig(CGRect(x: 0, y:44, width: self.bounds.width, height: returnHeight - 44), self, self, nil)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("释放了")
    }
}



extension LTFollowMoveTestView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.textLabel?.text = "第 \(indexPath.row + 1) 行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt - \(indexPath.row)")
    }
}

