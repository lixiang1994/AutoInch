# Inch - 优雅的iPhone全尺寸屏幕精准适配工具


### 前言
很多时候我们苦于需要精准的适配各个屏幕尺寸的UI, 通常根据某一种倍数计算的结果并不能满足精准的需求, 随着iPhone设备不同尺寸的增加 这种需求更加迫切, 当然我说的这些都是属于对于产品细节要求苛刻 追求完美的那一部分, 如果你觉得随便适配适配看着还行就够了, 那么现在就可以X掉这个页面了.

### 问题
很多时候为了解决这一情况的问题 OC中我们通常会写一些宏 例如 ISIPHONEX ISPLUS... 之类的提供快速判断的 但是每一个地方都需要写如此多的判断显然不是明智的, 也有AUTO(20,25,30) 类似这种的宏函数, 但是他们都有一个共同的缺点  扩展性不好, 假如每年果爹都出一块新尺寸的设备.. 使用这种思路适配简直是鼓励跳槽或者是闲来无事打发时间.

### 解决方案
考虑到扩展性和每一个尺寸的精确性, 我建了一个类型枚举 并且声明了iPhone所有尺寸类型 命名方式以 i开头+英寸数字:

```
enum InchType {
    case unknown
    case i58Full
    case i55
    case i47
    case i40
    case i35
    ....
```

接下来就是确定当前设备属于哪个类型

同样在类型枚举中增加一个当前类型的常量 通过闭包的方式初始化这个常量.
未来如果增加了新的设备 我们直接扩展这个枚举即可.

```
enum InchType {
    case unknown
    case i58Full
    case i55
    case i47
    case i40
    case i35
    
    static let current: InchType = {
        let screenWidth = Float(UIScreen.main.bounds.width)
        let screenHeight = Float(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        let height = max(screenWidth, screenHeight)
        
        if width == 375, height == 812 { return .i58Full }
        if width == 414, height == 736 { return .i55 }
        if width == 375, height == 667 { return .i47 }
        if width == 320, height == 568 { return .i40 }
        if width == 320, height == 480 { return .i35 }
        return .unknown
    } ()
}
```

现在当前设备类型已经得到, 接下来就是考虑如何设计才能保证更灵活的扩展以及调用, 思前想后这种情景中最合适的莫过于链式, 同时想达到最大的灵活性 在Swift中必然要用到强大的`protocol`, 这样设计的好处在于链式可以无限制扩展新的值 并且语法优雅 调用起来简洁美观, `protocol`可以把应用对象不仅仅局限在一种类型上.

```
protocol Inchable {
    
    func i58full(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i35(_ value: Self) -> Self
}
```

为协议扩展默认实现 根据当前类型判断返回原有的还是该类型的.


```
extension Inchable {
    
    func i58full(_ value: Self) -> Self {
        return InchType.current == .i58Full ? value : self
    }
    func i55(_ value: Self) -> Self {
        return InchType.current == .i55 ? value : self
    }
    func i47(_ value: Self) -> Self {
        return InchType.current == .i47 ? value : self
    }
    func i40(_ value: Self) -> Self {
        return InchType.current == .i40 ? value : self
    }
    func i35(_ value: Self) -> Self {
        return InchType.current == .i35 ? value : self
    }
}
```

最后就可以让我们需要支持的类型实现该协议

```
extension Int: Inchable {}
extension Float: Inchable {}
extension CGFloat: Inchable {}
extension Double: Inchable {}
extension String: Inchable {}
```

到这里基本上就已经写完了, 下面看一下调用效果:

```
view.height = 10.i35(4).i40(5).i47(7).i55(9).i58full(20)
```

OK, 是不是感觉很清爽? 再啰嗦一下, 以上面的示例来说明一下干了些啥, 为某个view设置一下高度, 默认是`10` 那么如果是3.5英寸屏幕(4s)返回值就会是`4`, 如果是4.0英寸(se/5s)返回值就是`5`, 以此类推.. 5.8英寸full就是iPhone X.

当然如果有些尺寸不需要适配你也可以不写, 如果当前设备你没有设置就会返回默认值 (示例中为 10), 这样一来即使未来增加了某些新的尺寸设备, 我们还没来得及更新适配, 因为有默认值所以问题也不大, 在扩展新尺寸时只需要在枚举值增加新类型并且在需要适配的地方后面追加一个.iXX()即可.

各种玩法, 甚至可以扩展UIColor实现该协议 不同设备不同颜色也是阔以玩的, 当然除了适配屏幕外 还可以用这个思路完成其他的操作 留给你们点想象空间.

```
/// String
label.text = "真实姓名:".i47("您的真实姓名").i55("请输入您的真实姓名").i58full("输入真实姓名")
```


### 总结

以上方案可以很好地支持不同设备精准适配的需求, 并且保持良好的扩展性和灵活性, 这里也充分利用了Swift强大的语法特性, 为适配创造了更多的可能.


### 使用
直接扔到工程中即可, 未来如果有更好的想法我会继续扩展这个工具, 所以现在就不弄到pods了, 喜欢就拖走, Star一生平安.


## 如果你有更好的想法 欢迎Issues留言讨论, 我是LEE, 下个轮子见.

Swift版本
==============
最低支持 `Swift 4.X`。


许可证
==============
使用 GPL V3 许可证，详情见 LICENSE 文件。

