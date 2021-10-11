# Guide

Repository has been migrated to [UIAdapter](https://github.com/lixiang1994/UIAdapter).

## Installation

**CocoaPods - Podfile**

```ruby
pod 'AutoInch' -> pod 'UIAdapter'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/AutoInch" -> github "lixiang1994/UIAdapter"
```

#### [Swift Package Manager for Apple platforms](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

Select Xcode menu `File > Swift Packages > Add Package Dependency` and enter repository URL with GUI.  
```
Repository: https://github.com/lixiang1994/AutoInch -> Repository: https://github.com/lixiang1994/UIAdapter
```

#### [Swift Package Manager](https://swift.org/package-manager/)

Add the following to the dependencies of your `Package.swift`:
```swift
.package(url: "https://github.com/lixiang1994/UIAdapter.git", from: "version")
```

## Usage

First make sure to import the framework:

```swift
import UIAdapter
```

### Zoom

AutoLayout (SnapKit): 

```swift
private func setupLayout() {
    cardView.snp.makeConstraints { (make) in
        make.top.equalTo(16.zoom())
        make.left.right.equalToSuperview().inset(15.zoom())
        make.bottom.equalTo(-26.zoom())
    }
	
    lineView.snp.makeConstraints { (make) in
	      make.left.right.equalToSuperview().inset(15.zoom())
	      make.top.equalTo(titleLabel.snp.bottom)
	      make.height.equalTo(1)
    }
        
    titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview()
        make.left.equalTo(15.zoom())
        make.height.equalTo(48.zoom())
    }
        
    stateLabel.snp.makeConstraints { (make) in
        make.top.equalTo(lineView).offset(10.zoom())
        make.left.equalTo(15.zoom())
        make.height.equalTo(15.zoom())
    }
}
```

Property (Then):

```swift
private lazy var cardView = UIView().then {
    $0.cornerRadius = 6.zoom()
    $0.backgroundColor = .white
}

private lazy var lineView = UIView().then {
    $0.backgroundColor = .hex("000000", alpha: 0.05)
}

private lazy var titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 20.zoom(), weight: .medium)
}

private lazy var stateLabel = UILabel().then {
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 12.zoom(), weight: .medium)
}
```

Storyboard / Xib:

<img width="534" alt="renameguide" src="https://user-images.githubusercontent.com/13112992/136746722-87fc5134-6a18-48bd-9278-b157d5243703.png">

