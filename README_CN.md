# AutoInch - 优雅的iPhone等比例/全尺寸精准适配工具

[![License](https://img.shields.io/cocoapods/l/AutoInch.svg)](LICENSE)&nbsp;
![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)&nbsp;
![Platform](https://img.shields.io/cocoapods/p/AutoInch.svg?style=flat)&nbsp;
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-4BC51D.svg?style=flat")](https://swift.org/package-manager/)&nbsp;
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![Cocoapods](https://img.shields.io/cocoapods/v/AutoInch.svg)](https://cocoapods.org)

## 如果你还未使用过它, 推荐使用 [迁移版本 -> UIAdapter](https://github.com/lixiang1994/UIAdapter).

## 如果你已经在使用它并且想一起迁移, 请查看 [迁移指南](https://github.com/lixiang1994/AutoInch/blob/master/RENAMEGUIDE.md)

## 特性

- [x] 数值类型快速转换
- [x] Storyboard 等比例适配支持 
- [x] Xib 等比例适配支持 
- [x] 自定义计算处理
- [x] 各个屏幕尺寸快速匹配


## 安装

**CocoaPods - Podfile**

```ruby
pod 'AutoInch'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/AutoInch"
```

#### [Swift Package Manager for Apple platforms](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

选择 Xcode 菜单 `File > Swift Packages > Add Package Dependency` 输入仓库地址.  
```
Repository: https://github.com/lixiang1994/AutoInch
```

#### [Swift Package Manager](https://swift.org/package-manager/)

将以下内容添加到你的 `Package.swift`:
```swift
.package(url: "https://github.com/lixiang1994/AutoInch.git", from: "version")
```

## 使用

首先导入

```swift
import AutoInch
```

下面是一些简单示例. 支持所有设备和模拟器:

### Auto


AutoLayout (SnapKit): 

```swift
private func setupLayout() {
    cardView.snp.makeConstraints { (make) in
	make.top.equalTo(16.auto())
	make.left.right.equalToSuperview().inset(15.auto())
	make.bottom.equalTo(-26.auto())
    }
	
    lineView.snp.makeConstraints { (make) in
	make.left.right.equalToSuperview().inset(15.auto())
	make.top.equalTo(titleLabel.snp.bottom)
	make.height.equalTo(1)
    }
        
    titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview()
        make.left.equalTo(15.auto())
        make.height.equalTo(48.auto())
    }
        
    stateLabel.snp.makeConstraints { (make) in
        make.top.equalTo(lineView).offset(10.auto())
        make.left.equalTo(15.auto())
        make.height.equalTo(15.auto())
    }
}
```

属性设置 (Then):

```swift
private lazy var cardView = UIView().then {
    $0.cornerRadius = 6.auto()
    $0.backgroundColor = .white
}

private lazy var lineView = UIView().then {
    $0.backgroundColor = .hex("000000", alpha: 0.05)
}

private lazy var titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 20.auto(), weight: .medium)
}

private lazy var stateLabel = UILabel().then {
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 12.auto(), weight: .medium)
}
```

Storyboard / Xib:

![约束](Resources/Storyboard%20Constraint.png)
![UILabel 字体大小](Resources/Storyboard%20Label%20Font.png)

### Inch

例子

```swift
// default other screen numberOfLines = 0
// 3.5 inches screen numberOfLines = 1
// 4.0 inches screen numberOfLines = 2
label.numberOfLines = 0.screen.inch(._3_5, is: 1).inch(._4_0, is: 2).value
```


```swift
// default other screen numberOfLines = 0
// width 320 screen numberOfLines = 1
// width 375 inches screen numberOfLines = 2
label.numberOfLines = 0.screen.width(._320, is: 1).width(._375, is: 2).value
```


```swift
print("this is " +
    "default".screen
    .width(._320, is: "宽度 320")
    .width(._375, is: "宽度 375")
    .height(._844, is: "高度 844")
    .height(._812, is: "高度 812")
    .inch(._4_7, is: "4.7 英寸")
    .inch(._5_8, is: "5.8 英寸")
    .inch(._6_5, is: "6.5 英寸")
    .level(.compact, is: "屏幕级别 紧凑屏")
    .level(.regular, is: "屏幕级别 常规屏")
    .level(.full, is: "屏幕级别 全面屏")
    .value
)
```


## 截屏

![TikTok 1](Resources/Storyboard%20TikTok%20Demo1.jpg)

![TikTok 2](Resources/Storyboard%20TikTok%20Demo2.jpg)

## 贡献

如果您需要实现特定功能或遇到错误，请打开issue。
如果您自己扩展了AutoInch的功能并希望其他人也使用它，请提交拉取请求。

## 协议

AutoInch 使用 MIT 协议. 有关更多信息，请参阅[LICENSE](LICENSE)文件.


>### [相关文章 Inch](https://www.jianshu.com/p/d2c09cb65ef7)
>### [相关文章 Auto](https://www.jianshu.com/p/e0e12206e0c7)
>### [相关文章 Auto](https://www.jianshu.com/p/48c67d0c95b6)


-----

> ## 欢迎入群交流
![QQ](https://github.com/lixiang1994/Resources/blob/master/QQClub/QQClub.JPG)
