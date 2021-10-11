# AutoInch - 优雅的iPhone等比例/全尺寸精准适配工具

[![License](https://img.shields.io/cocoapods/l/AutoInch.svg)](LICENSE)&nbsp;
![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)&nbsp;
![Platform](https://img.shields.io/cocoapods/p/AutoInch.svg?style=flat)&nbsp;
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-4BC51D.svg?style=flat")](https://swift.org/package-manager/)&nbsp;
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![Cocoapods](https://img.shields.io/cocoapods/v/AutoInch.svg)](https://cocoapods.org)

## [:cn:天朝子民](README_CN.md)

## If you haven't used it, Please use [Rename -> UIAdapter](https://github.com/lixiang1994/UIAdapter).

## If you have used it and want to migrate together, Please check the [migration guide](https://github.com/lixiang1994/AutoInch/blob/master/RENAMEGUIDE.md)

## Features

- [x] Numerical type fast conversion
- [x] Storyboard equal scale adaptation 
- [x] Xib equal scale adaptation 
- [x] Custom calculation processing
- [x] Quick match for each screen size type


## Installation

**CocoaPods - Podfile**

```ruby
pod 'AutoInch'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/AutoInch"
```

#### [Swift Package Manager for Apple platforms](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

Select Xcode menu `File > Swift Packages > Add Package Dependency` and enter repository URL with GUI.  
```
Repository: https://github.com/lixiang1994/AutoInch
```

#### [Swift Package Manager](https://swift.org/package-manager/)

Add the following to the dependencies of your `Package.swift`:
```swift
.package(url: "https://github.com/lixiang1994/AutoInch.git", from: "version")
```

## Usage

First make sure to import the framework:

```swift
import AutoInch
```

Here are some usage examples. All devices are also available as simulators:


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

Property (Then):

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

![Constraint](Resources/Storyboard%20Constraint.png)
![UILabel Font](Resources/Storyboard%20Label%20Font.png)

### Screen

e.g.

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
    .width(._320, is: "width 320")
    .width(._375, is: "width 375")
    .height(._844, is: "height 844")
    .height(._812, is: "height 812")
    .inch(._4_7, is: "4.7 inches")
    .inch(._5_8, is: "5.8 inches")
    .inch(._6_5, is: "6.5 inches")
    .level(.compact, is: "screen 3: 2")
    .level(.regular, is: "screen 16: 9")
    .level(.full, is: "screen 19.5: 9")
    .value
)
```


## Screenshot

![TikTok 1](Resources/Storyboard%20TikTok%20Demo1.jpg)

![TikTok 2](Resources/Storyboard%20TikTok%20Demo2.jpg)

## Contributing

If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality of AutoInch yourself and want others to use it too, please submit a pull request.


## License

AutoInch is under MIT license. See the [LICENSE](LICENSE) file for more info.


>### [相关文章 Inch](https://www.jianshu.com/p/d2c09cb65ef7)
>### [相关文章 Auto](https://www.jianshu.com/p/e0e12206e0c7)
>### [相关文章 Auto](https://www.jianshu.com/p/48c67d0c95b6)

-----

> ## 欢迎入群交流
![QQ](https://github.com/lixiang1994/Resources/blob/master/QQClub/QQClub.JPG)
