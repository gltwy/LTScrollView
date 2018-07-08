# LTScrollView

实现原理： [http://blog.csdn.net/glt_code/article/details/78576628](http://blog.csdn.net/glt_code/article/details/78576628)

[![CI Status](http://img.shields.io/travis/1282990794@qq.com/LTScrollView.svg?style=flat)](https://travis-ci.org/1282990794@qq.com/LTScrollView)
[![Version](https://img.shields.io/cocoapods/v/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)
[![License](https://img.shields.io/cocoapods/l/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)
[![Platform](https://img.shields.io/cocoapods/p/LTScrollView.svg?style=flat)](http://cocoapods.org/pods/LTScrollView)

![image](https://github.com/gltwy/LTScrollView/blob/master/demo.gif)

## Demo文件路径以及说明

- LTScrollView / Example : 为 Swift 使用示例.
- LTScrollView / OCExample : 为 OC 使用示例.
- 支持的子View为UIScrollView、UICollectionView、UITableView.

## CocoaPods安装

安装[CocoaPods](http://cocoapods.org) 使用以下命令：

```bash
$ gem install cocoapods
```

### Podfile

在你的 `Podfile`中添加LTScrollView

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
#注意此处需要添加use_frameworks!
use_frameworks!

pod 'LTScrollView', '~> 0.1.7'
end
```

然后，使用以下命令安装

```bash
$ pod install
```

提示错误 `[!] Unable to find a specification for LTScrollView ` 解决办法：

```
$ pod repo remove master
$ pod setup
```

## Swift使用说明

### Swift.LTSimple使用说明

1. 创建LTSimpleManager实例对象
```objective-c
@objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout)
```
2. 设置headerView
```objective-c
@objc public func configHeaderView(_ handle: (() -> UIView?)?)
```
3. 子控制器中glt_scrollView进行赋值
```objective-c
self.glt_scrollView = self.tableView（self.scrollView / self.collectionView）
```
4. 更多使用说明请参考Demo（LTScrollView / Example）


### Swift.LTAdvanced使用说明

1. 创建LTAdvancedManager实例对象、并设置headerView
```objective-c
@objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout, headerViewHandle handle: () -> UIView)
```
2. 子控制器中glt_scrollView进行赋值
```objective-c
self.glt_scrollView = self.tableView（self.scrollView / self.collectionView）
```
3. 更多使用说明请参考Demo（LTScrollView / Example）

## OC使用说明

### OC.LTSimple使用说明
1. 创建LTSimpleManager实例对象
```objective-c
[[LTSimpleManager alloc] initWithFrame:frame viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout]
```
2. 设置headerView
```objective-c
[self.managerView configHeaderView:^UIView * _Nullable{ }]
```
3. 子控制器中glt_scrollView进行赋值
```objective-c
self.glt_scrollView = self.tableView（self.scrollView / self.collectionView）
```
4. 更多使用说明请参考Demo（LTScrollView / OCExample）

### OC.LTAdvanced使用说明
1. 创建LTAdvancedManager实例对象、并设置headerView
```objective-c
 [[LTAdvancedManager alloc] initWithFrame:frame viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout headerViewHandle:^UIView * _Nonnull{}]
```
2. 子控制器中glt_scrollView进行赋值
```objective-c
self.glt_scrollView = self.tableView（self.scrollView / self.collectionView）
```
3. 更多使用说明请参考Demo（LTScrollView / OCExample）

## LTLayout属性说明
```swift
public class LTLayout: NSObject {
    
    /* pageView背景颜色 */
    @objc public var titleViewBgColor: UIColor? = UIColor(r: 255, g: 239, b: 213)
    
    /* 标题颜色，请使用RGB赋值 */
    @objc public var titleColor: UIColor? = NORMAL_BASE_COLOR
    
    /* 标题选中颜色，请使用RGB赋值 */
    @objc public var titleSelectColor: UIColor? = SELECT_BASE_COLOR
    
    /* 标题字号 */
    @objc public var titleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    
    /* 滑块底部线的颜色 - UIColor.blue */
    @objc public var bottomLineColor: UIColor? = UIColor.red
    
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
    
    /* 滑块底部线圆角 */
    @objc public var bottomLineCornerRadius: CGFloat = 0.0
    
    /* 是否隐藏滑块、底部线*/
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
    @objc public var pageBottomLineColor: UIColor? = UIColor(r: 230, g: 230, b: 230)
    
    /* pageView的内容ScrollView是否开启左右弹性效果 */
    @objc public var isShowBounces: Bool = false
    
    /* 内部使用-外界不要调用 */
    var isSinglePageView: Bool = false
}

```
## 更新说明

2018.06.30 - 0.1.7
```objective-c
1. 修复LTAdvancedManager数据较少时，其他子控制器自动下落Bug
2. 解决issue中的部分问题
3. 优化内部实现
```

2018.06.02 - 0.1.6
```objective-c
1. 修复LTSimple当HeaderView的高度为小数时无法滑动的Bug
2. 增加代码设置滚动位置的方法
3. 增加切换动画属性设置
4. 修复已知Bug
```

2018.05.12 - 0.1.5
```objective-c
1. 修复循环引用导致控制器无法释放的问题
2. 可手动设置悬停PageTitleView的位置（y值）
3. 修复了LTAdvanced的已知Bug
```
## Author
- Email:  1282990794@qq.com
- -Blog:  https://blog.csdn.net/glt_code

## License

LTScrollView is available under the MIT license. See the LICENSE file for more info.


