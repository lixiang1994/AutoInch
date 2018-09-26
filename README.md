# Inch - 优雅的iPhone全尺寸屏幕精准适配工具

![Swift4](https://img.shields.io/badge/language-Swift4-blue.svg)

### 前言
很多时候我们苦于需要精准的适配各个屏幕尺寸的UI, 通常根据某一种倍数计算的结果并不能满足精准的需求, 随着iPhone设备不同尺寸的增加 这种需求更加迫切, 当然我说的这些都是属于对于产品细节要求苛刻 追求完美的那一部分, 如果你觉得随便适配适配看着还行就够了, 那么现在就可以X掉这个页面了.

### 问题A

通常为了解决这一情况的问题 OC中我们通常会写一些宏 例如 ISIPHONEX ISPLUS... 之类的提供快速判断的 但是每一个地方都需要写如此多的判断显然不是明智的, 也有AUTO(20,25,30) 类似这种的宏函数, 但是他们都有一个共同的缺点  扩展性不好, 假如每年果爹都出一块新尺寸的设备.. 使用这种思路适配简直是鼓励跳槽或者是闲来无事打发时间.

#### 解决方案

考虑到扩展性和每一个尺寸的精确性, 我建了一个类型枚举 并且声明了iPhone所有尺寸类型 命名方式以 i开头+英寸数字:

```
enum InchType: Int {
    case unknown = -1
    case i35
    case i40
    case i47
    case i55
    case i58Full
    case i61Full
    case i65Full
```

接下来就是确定当前设备属于哪个类型

同样在类型枚举中增加一个当前类型的常量 通过type方法来根据当前屏幕size获取对应类型.
未来如果增加了新的设备 我们直接扩展这个枚举即可.

```
enum InchType: Int {
    case unknown = -1
    case i35
    case i40
    case i47
    case i55
    case i58Full
    case i61Full
    case i65Full
    
    ..... // 具体实现请看源码
    
    static let current: InchType = type(size: UIScreen.main.bounds.size)
}
```

现在当前设备类型已经得到, 接下来就是考虑如何设计才能保证更灵活的扩展以及调用, 思前想后这种情景中最合适的莫过于链式, 同时想达到最大的灵活性 在Swift中必然要用到强大的`protocol`, 这样设计的好处在于链式可以无限制扩展新的值 并且语法优雅 调用起来简洁美观, `protocol`可以把应用对象不仅仅局限在一种类型上.

```
protocol Inchable {
    
    func i35(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i58full(_ value: Self) -> Self
    func i61full(_ value: Self) -> Self
    func i65full(_ value: Self) -> Self
    
    ....
}
```

为协议扩展默认实现 根据当前类型判断返回原有的还是该类型的.


```
extension Inchable {
    
    func i35(_ value: Self) -> Self {
        return matching(type: .i35, value)
    }
    func i40(_ value: Self) -> Self {
        return matching(type: .i40, value)
    }
    func i47(_ value: Self) -> Self {
        return matching(type: .i47, value)
    }
    func i55(_ value: Self) -> Self {
        return matching(type: .i55, value)
    }
    func i58full(_ value: Self) -> Self {
        return matching(type: .i58Full, value)
    }
    func i61full(_ value: Self) -> Self {
        return matching(type: .i61Full, value)
    }
    func i65full(_ value: Self) -> Self {
        return matching(type: .i65Full, value)
    }
    
    ...
    
    private func matching(type: InchType, _ value: Self) -> Self {
        return InchType.current == type ? value : self
    }
}
```

最后就可以让我们需要支持的类型实现该协议

```
extension Int: Inchable {}
extension Float: Inchable {}
extension Double: Inchable {}
extension String: Inchable {}
extension CGRect: Inchable {}
extension CGSize: Inchable {}
extension CGFloat: Inchable {}
extension CGPoint: Inchable {}
```

到这里基本上就已经写完了, 下面看一下调用效果:

```
view.height = 10.i35(4).i40(5).i47(7).i55(9).i58full(20)
```

OK, 是不是感觉很清爽? 再啰嗦一下, 以上面的示例来说明一下干了些啥, 为某个view设置一下高度, 默认是`10` 那么如果是3.5英寸屏幕(4s)返回值就会是`4`, 如果是4.0英寸(se/5s)返回值就是`5`, 以此类推.. 5.8英寸full就是iPhone X.

当然如果有些尺寸不需要适配你也可以不写, 如果当前设备你没有设置就会返回默认值 (示例中为 10), 这样一来即使未来增加了某些新的尺寸设备, 我们还没来得及更新适配, 因为有默认值所以问题也不大, 在扩展新尺寸时只需要在枚举中增加新类型并且在需要适配的地方后面追加一个.iXX()即可.

各种玩法, 甚至可以扩展UIColor实现该协议 不同设备不同颜色也是阔以玩的, 当然除了适配屏幕外 还可以用这个思路完成其他的操作 留给你们点想象空间.

```
/// String
label.text = "真实姓名:".i47("您的真实姓名").i55("请输入您的真实姓名").i58full("输入真实姓名")
```

#### 总结

以上方案可以很好地支持不同设备精准适配的需求, 并且保持良好的扩展性和灵活性, 这里也充分利用了Swift强大的语法特性, 为适配创造了更多的可能.

### 问题B

有些时候对每个尺寸的屏幕进行精确适配是件很麻烦的事情, 虽然效果会很好, 但是会造成编写大量适配代码的问题, 而且不同设备的对应的大小还需要单独计算或者调试得出.

#### 解决方案

除了针对不同尺寸设备单独进行精确适配外, 还有一种适配方式, 那就是等比例适配.
什么是等比例适配呢? 根据一个基准数值计算相较于这个数值的比例, 按照这个比例计算出当前的值, 举个例子
基准数值为375, 对应的值为100, 可以理解为在屏幕宽为375时 某值为100. 那么在屏幕宽414时 某值应该是多少呢?
先计算比例 `414 ÷ 375 = 1.104` 再计算最终的值 `1.104 * 100 = 110.4`.
ok, 等比例适配其实就是按照一个基准 计算比例然后将值进行等比例转换, 来达到不同大小的屏幕显示效果相同的效果, 类似一张图片等比例缩放.

道理就是这么个道理, 但是我们写代码时不可能每个地方都要写这个计算, 这里我写了一些扩展来解决这个问题.

```
extension Double {
    
    /// 自动比例转换 (基于屏幕宽度)
    ///
    /// - Parameter baseWidth: 基准屏幕宽度 默认375
    /// - Returns: 返回结果
    func auto(_ baseWidth: Double = 375) -> Double {
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        return self * (width / baseWidth)
    }
}
```

对`Double`类型进行扩展 增加转换方法, 在调用时直接写`100.auto()`即可, 简单方便.
但还会有一个问题, Swift里面类型要求非常严格, 比如某些类型是`CGFloat`或者`Int`的, 那么直接赋值`Double`类型肯定是不行的, 还需要类型转换.
例如: 
```
layer.cornerRadius = CGFloat(20.auto())
```
为了解决多种类型转换问题, 我增加了如下处理:

```
extension BinaryInteger {
    
    func auto(_ baseWidth: Double = 375) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto(baseWidth)
    }
    func auto<T: BinaryInteger>(_ baseWidth: Double = 375) -> T {
        let temp = Double("\(self)") ?? 0
        return temp.auto(baseWidth)
    }
    func auto<T: BinaryFloatingPoint>(_ baseWidth: Double = 375) -> T {
        let temp = Double("\(self)") ?? 0
        return temp.auto(baseWidth)
    }
}

extension BinaryFloatingPoint {
    
    func auto(_ baseWidth: Double = 375) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto(baseWidth)
    }
    func auto<T: BinaryInteger>(_ baseWidth: Double = 375) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto(baseWidth))
    }
    func auto<T: BinaryFloatingPoint>(_ baseWidth: Double = 375) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto(baseWidth))
    }
}
```
emmmm... 傻乎乎的对`Float`, `CGFloat`, `Int`, `Int32`, `Int64`...各种各样的类型扩展, 再写一遍`Double`里的代码, 这很不Swift.
这里我通过对整型和浮点类型协议的扩展, 可以让所有数值类型全部都支持自动转换方法, 再加上泛型推导, 妈妈再也不用担心类型转换了.

#### 总结

等比例适配算是我目前用到最多的适配方式, 几乎不用操心小屏幕的适配, 很无脑, 按照678设备的字号,间距,宽高等直接固定数字加`auto()`即可, 当然也不是所有地方都要加适配, 只对需要适配的地方进行处理, 例如导航栏 不同尺寸设备的字号,大小都是一样的 当然就不需要处理了.
总结一句话, 对需要适配的部分一定要适配完全, 包括字号 间距 宽高 圆角等, 就像是一张图片进行等比缩放一样, 不要同一个地方一部分适配了一部分又没适配, 那样效果会很尴尬的.

### 使用

直接扔到工程中即可, 未来如果有更好的想法我会继续扩展这个工具, 所以现在就不弄到pods了, 喜欢就拖走, Star一生平安.


## 如果你有更好的想法 欢迎Issues留言讨论, 我是LEE, 下个轮子见.

Swift版本
==============
最低支持 `Swift 4.X`。


许可证
==============
使用 GPL V3 许可证，详情见 LICENSE 文件。

