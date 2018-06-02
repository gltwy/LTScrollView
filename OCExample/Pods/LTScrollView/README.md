# LTScrollView

实现原理： [http://blog.csdn.net/glt_code/article/details/78576628](http://blog.csdn.net/glt_code/article/details/78576628)

[![CI Status](http://img.shields.io/travis/1282990794@qq.com/LTScrollView.svg?style=flat)](https://travis-ci.org/1282990794@qq.com/LTScrollView)
[![Version](https://img.shields.io/cocoapods/v/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)
[![License](https://img.shields.io/cocoapods/l/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)
[![Platform](https://img.shields.io/cocoapods/p/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)

![image](https://github.com/gltwy/LTScrollView/blob/master/demo.gif)

## Example

- LTScrollView / Example : 为 Swift 使用示例.
- LTScrollView / OCExample : 为 OC 使用示例.

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
pod 'LTScrollView', '~> 0.1.5'
end
```

Then, run the following command:

```bash
$ pod install
```

提示错误 `[!] Unable to find a specification for LTScrollView ` 解决办法：

```
$ pod repo remove master
$ pod setup
```

## Usage

### Swift使用说明

##### Swift.LTSimple使用说明

```swift
private lazy var layout: LTLayout = {
    let layout = LTLayout()
    layout.titleViewBgColor = UIColor(r: 255, g: 239, b: 213)
    layout.titleColor = UIColor(r: 0, g: 0, b: 0)
    layout.titleSelectColor = UIColor(r: 255, g: 0, b: 0)
    layout.bottomLineColor = UIColor.red
    layout.pageBottomLineColor = UIColor(r: 230, g: 230, b: 230)
    return layout
}()

private lazy var simpleManager: LTSimpleManager = {
    let Y: CGFloat = glt_iphoneX ? 64 + 24.0 : 64.0
    let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
    let simpleManager = LTSimpleManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
    simpleManager.delegate = self
    //设置悬停位置
    //        simpleManager.hoverY = 64
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

//MARK: 滚动代理方法监听
extension LTSimpleManagerDemo: LTSimpleScrollViewDelegate {
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("offset -> ", scrollView.contentOffset.y)
    }
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
    layout.titleViewBgColor = UIColor(r: 255, g: 239, b: 213)
    layout.titleColor = UIColor(r: 0, g: 0, b: 0)
    layout.titleSelectColor = UIColor(r: 255, g: 0, b: 0)
    layout.bottomLineColor = UIColor.red
    layout.pageBottomLineColor = UIColor(r: 230, g: 230, b: 230)
    layout.isAverage = true
    //设置滑块的宽度
    layout.sliderWidth = 20
    //调节滑块的高 默认44
    layout.sliderHeight = 45
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
    //设置悬停位置Y值
    //        advancedManager.hoverY = Y
    advancedManager.delegate = self
    return advancedManager
}()

//MARK: 选中事件
advancedManager.advancedDidSelectIndexHandle = {
    print($0)
}

//MARK: 滚动代理方法监听
func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
    print("offset --> ", offsetY)
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

//滚动代理方法监听
-(void)glt_scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"---> %lf", scrollView.contentOffset.y);
}

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

//滚动代理方法监听
-(void)glt_scrollViewOffsetY:(CGFloat)offsetY {
    NSLog(@"---> %lf", offsetY);
}

[self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
    NSLog(@"%ld", index);
}];

```

### LTLayout属性说明
```swift
public class LTLayout: NSObject {
    
    /* pageView背景颜色 */
    @objc public var titleViewBgColor: UIColor? = UIColor.gray
    
    /* 标题颜色，请使用RGB赋值 */
    @objc public var titleColor: UIColor? = NORMAL_BASE_COLOR
    
    /* 标题选中颜色，请使用RGB赋值 */
    @objc public var titleSelectColor: UIColor? = SELECT_BASE_COLOR
    
    /* 标题字号 */
    @objc public var titleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    
    /* 滑块底部线的颜色 */
    @objc public var bottomLineColor: UIColor? = UIColor.blue
    
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
    
    /* 是否隐藏滑块 */
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
    @objc public var pageBottomLineColor: UIColor? = UIColor.gray
    
}

```
## 更新说明

2018.05.12 - 0.1.5
```objective-c
1. 修复循环引用导致控制器无法释放的问题
2. 可手动设置悬停PageTitleView的位置（y值）
3. 修复了LTAdvanced的已知Bug
```

2018.05.05 - 0.1.4
```objective-c
1. LTPageView 支持更多样式，详情可见LTLayout属性说明
2. 修复LTSimpleManager下拉刷新过程中切换Bug
3. 修复LTAdvancedManager数据较少时的显示Bug
4. 增加滑动过程中UIScrollView代理方法的监听
```

## Author

1282990794@qq.com

## License

LTScrollView is available under the MIT license. See the LICENSE file for more info.


