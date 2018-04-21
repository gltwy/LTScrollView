# LTScrollView

实现原理： [http://blog.csdn.net/glt_code/article/details/78576628](http://blog.csdn.net/glt_code/article/details/78576628)

[![CI Status](http://img.shields.io/travis/1282990794@qq.com/LTScrollView.svg?style=flat)](https://travis-ci.org/1282990794@qq.com/LTScrollView)
[![Version](https://img.shields.io/cocoapods/v/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)
[![License](https://img.shields.io/cocoapods/l/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)
[![Platform](https://img.shields.io/cocoapods/p/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)

![image](https://github.com/gltwy/LTScrollView/blob/master/glt.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift, which automates and simplifies the process of using 3rd-party libraries like LTScrollView in your projects.  You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate LTScrollView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'LTScrollView', '~> 0.1.2'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Swift使用说明

##### Swift.LTSimple使用说明

```swift
private lazy var layout: LTLayout = {
    let layout = LTLayout()
    layout.titleColor = UIColor.white
    layout.titleViewBgColor = UIColor.gray
    layout.titleSelectColor = UIColor.yellow
    layout.bottomLineColor = UIColor.yellow
    return layout
}()

private lazy var simpleManager: LTSimpleManager = {
    let Y: CGFloat = glt_iphoneX ? 64 + 24.0 : 64.0
    let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
    let simpleManager = LTSimpleManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
    return simpleManager
}()

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

//MARK: 控制器刷新事件
simpleManager.refreshTableViewHandle { (scrollView, index) in
    scrollView.mj_header = MJRefreshNormalHeader {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
            scrollView.mj_header.endRefreshing()
        })
    }
}

```

##### Swift.LTAdvanced使用说明

```swift
private lazy var layout: LTLayout = {
    let layout = LTLayout()
    layout.titleColor = UIColor.white
    layout.titleViewBgColor = UIColor.gray
    layout.titleSelectColor = UIColor.yellow
    layout.bottomLineColor = UIColor.yellow
    return layout
}()

private lazy var advancedManager: LTAdvancedManager = {
    let Y: CGFloat = glt_iphoneX ? 64 + 24.0 : 64.0
    let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
    let advancedManager = LTAdvancedManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
        guard let strongSelf = self else { return UIView() }
        let headerView = strongSelf.testLabel()
        return headerView
    })
    return advancedManager
}()

//MARK: 选中事件
advancedManager.advancedDidSelectIndexHandle = {
    print($0)
}

```
### OC使用说明

##### OC.LTSimple使用说明

```objective-c
-(LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat Y = kIPhoneX ? 64 + 24.0 : 64.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, Y, self.view.bounds.size.width, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout];
    }
    return _managerView;
}
    
//配置headerView
[self.managerView configHeaderView:^UIView * _Nullable{
    return [weakSelf setupHeaderView];
}];

//pageView点击事件
[self.managerView didSelectIndexHandle:^(NSInteger index) {
    NSLog(@"点击了 -> %ld", index);
}];

//控制器刷新事件
[self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
    __weak typeof(scrollView) weakScrollView = scrollView;
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakScrollView) strongScrollView = weakScrollView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"对应控制器的刷新自己玩吧，这里就不做处理了🙂-----%ld", index);
            [strongScrollView.mj_header endRefreshing];
        });
    }];
}];

```

##### OC.LTAdvanced使用说明
```objective-c
-(LTAdvancedManager *)managerView {
    if (!_managerView) {
        CGFloat Y = kIPhoneX ? 64 + 24.0 : 64.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        _managerView = [[LTAdvancedManager alloc] initWithFrame:CGRectMake(0, Y, self.view.bounds.size.width, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout headerViewHandle:^UIView * _Nonnull{
            return [self setupHeaderView];
        }];
    }
    return _managerView;
}

[self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
    NSLog(@"%ld", index);
}];

```

## Author

1282990794@qq.com

## License

LTScrollView is available under the MIT license. See the LICENSE file for more info.


