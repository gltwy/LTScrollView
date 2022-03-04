//
//  LTLivePlayLoopsListDemo.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/3.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LTLivePlayLoopsListDemo: UIViewController {

    private lazy var playListView: LTLivePlayLoopsListView = {
        let playListView = LTLivePlayLoopsListView(frame: CGRect(x: 0, y: GLT_NAVCHEIGHT, width: GLT_MAINWIDTH, height: GLT_MAINWHEIGHT - GLT_NAVCHEIGHT), content: UILabel.self)
        playListView.delegate = self
        playListView.dataSource = self
        /** 是否开启支持无限轮播 */
        playListView.isCanLoops = true
        return playListView
    }()
    
    private lazy var contentView: UIButton = {
        let contentView = UIButton(type: .custom)
        contentView.frame = CGRect(x: 0, y: 0, width: playListView.glt_width, height: playListView.glt_height)
        contentView.setBackgroundImage(UIImage(named: "test"), for: .normal)
        contentView.contentMode = .scaleAspectFill
        contentView.setTitle("播放器播放视频流...", for: .normal)
        contentView.titleLabel?.font = .systemFont(ofSize: 20)
        return contentView
    }()
    
    private lazy var dataSource: [String] = {
        return ["1", "2", "3", "4", "5"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(playListView)
        
        playListView.currentIndex = 2
        playListView.reloadData()
        
        /**
         loopsList.currentIndex = 2
         loopsList.reloadData()
         等价
         loopsList.reloadData()
         loopsList.scrollTo(index: 2)
         */
    }
}

extension LTLivePlayLoopsListDemo: LTLivePlayLoopsListDelegate, LTLivePlayLoopsListDataSource {
    
    func didSelect(livePlayView: LTLivePlayLoopsListView, inView: UIView, index: Int) {
        print("当前加载 - \(dataSource[index])")
        inView.addSubview(contentView)
    }
  
    func prefetch(livePlayView: LTLivePlayLoopsListView, inView: UIView, index: Int) {
        print("预加载 - \(dataSource[index])")
        let contentLabel = inView as! UILabel
        contentLabel.text = "第\(dataSource[index])个item(此处可放置预览视图)"
        contentLabel.backgroundColor = .green
        contentLabel.font = .systemFont(ofSize: 24)
        contentLabel.textAlignment = .center
    }
    
    func numberofItems(livePlayView: LTLivePlayLoopsListView) -> Int {
        return dataSource.count
    }
    
    func checkCanScroll() -> Bool {
        return true
    }
}
