//
//  Screen.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2018/1/22.
//  Copyright © 2018年 lee. All rights reserved.
//

import Foundation

#if os(iOS)

import UIKit

public class ScreenWrapper<Base> {
    let base: Base
    
    public private(set) var value: Base
    
    init(_ base: Base) {
        self.base = base
        self.value = base
    }
}

public protocol ScreenCompatible {
    associatedtype ScreenCompatibleType
    var screen: ScreenCompatibleType { get }
}

extension ScreenCompatible {
    
    public var screen: ScreenWrapper<Self> {
        get { return ScreenWrapper(self) }
    }
}

extension ScreenWrapper {
    
    public func width(greaterThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 > base }, is: value, zoomed: zoomed ?? value)
    }
    public func width(lessThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 < base }, is: value, zoomed: zoomed ?? value)
    }
    public func width(equalTo base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 == base }, is: value, zoomed: zoomed ?? value)
    }
    private func width(_ matching: (CGFloat) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(Screen.base.bounds.width) {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func height(greaterThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 > base }, is: value, zoomed: zoomed ?? value)
    }
    public func height(lessThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 < base }, is: value, zoomed: zoomed ?? value)
    }
    public func height(equalTo base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 == base }, is: value, zoomed: zoomed ?? value)
    }
    private func height(_ matching: (CGFloat) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(Screen.base.bounds.height) {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func inch(_ types: Screen.Inch..., is value: Base) -> Self {
        return inch(types, is: value, zoomed: value)
    }
    public func inch(_ types: Screen.Inch..., is value: Base, zoomed: Base) -> Self {
        return inch(types, is: value, zoomed: zoomed)
    }
    private func inch(_ types: [Screen.Inch], is value: Base, zoomed: Base) -> Self {
        for type in types where Screen.Inch.current == type {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func level(_ types: Screen.Level..., is value: Base) -> Self {
        return level(types, is: value, zoomed: value)
    }
    public func level(_ types: Screen.Level..., is value: Base, zoomed: Base) -> Self {
        return level(types, is: value, zoomed: zoomed)
    }
    private func level(_ types: [Screen.Level], is value: Base, zoomed: Base) -> Self {
        for type in types where Screen.Level.current == type {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
}

public enum Screen {
    
    public static var base: UIScreen = .main
    
    public static var isZoomedMode: Bool {
        guard !UIDevice.iPhonePlus else { return base.bounds.width == 375 }
        guard !UIDevice.iPhoneMini else { return base.bounds.width == 320 }
        return base.scale != base.nativeScale
    }
    
    public static var size: CGSize {
        base.bounds.size
    }
    public static var nativeSize: CGSize {
        base.nativeBounds.size
    }
    public static var scale: CGFloat {
        base.scale
    }
    public static var nativeScale: CGFloat {
        base.nativeScale
    }
    
    /// 真实宽高比 例如: iPhone 16 Pro (201:437)
    public static var aspectRatio: String {
        if
            let cache = _aspectRatio,
            cache.0 == base.nativeBounds.size {
            return cache.1
            
        } else {
            let result = base.aspectRatio
            _aspectRatio = (base.nativeBounds.size, result)
            return result
        }
    }
    private static var _aspectRatio: (CGSize, String)?
    
    /// 标准宽高比 例如: iPhone 16 Pro (9:19.5)
    public static var standardAspectRatio: String {
        if
            let cache = _standardAspectRatio,
            cache.0 == base.nativeBounds.size {
            return cache.1
            
        } else {
            let result = base.standardAspectRatio
            _standardAspectRatio = (base.nativeBounds.size, result)
            return result
        }
    }
    private static var _standardAspectRatio: (CGSize, String)?
    
    public enum Inch: Double {
        case unknown = -1
        case _3_5 = 3.5
        case _4_0 = 4.0
        case _4_7 = 4.7
        case _5_4 = 5.4
        case _5_5 = 5.5
        case _5_8 = 5.8
        case _6_1 = 6.1
        case _6_3 = 6.3
        case _6_5 = 6.5
        case _6_7 = 6.7
        case _6_9 = 6.9
        
        public static var current: Inch {
            switch (nativeSize.width / scale, nativeSize.height / scale, scale) {
            case (320, 480, 2):
                return ._3_5
                
            case (320, 568, 2):
                return ._4_0
                
            case (375, 667, 2):
                return ._4_7
                
            case (360, 780, 3), (375, 812, 3) where UIDevice.iPhoneMini:
                return ._5_4
                
            case (360, 640, 3), (414, 736, 3) where UIDevice.iPhonePlus:
                return ._5_5
            
            case (375, 812, 3):
                return ._5_8
                
            case (414, 896, 2), (390, 844, 3), (393, 852, 3):
                return ._6_1
                
            case (402, 874, 3):
                return ._6_3

            case (414, 896, 3):
                return ._6_5
                
            case (428, 926, 3), (430, 932, 3):
                return ._6_7
                
            case (440, 956, 3):
                return ._6_9
                
            default:
                return .unknown
            }
        }
    }
    
    public enum Level: Int {
        case unknown = -1
        /// 3: 2
        case compact
        /// 16: 9
        case regular
        /// 19.5: 9
        case full
        
        public static var current: Level {
            switch standardAspectRatio {
            case "3:4", "4:3":
                return .compact
                
            case "9:16", "16:9":
                return .regular
            
            case "9:19.5", "19.5:9":
                return .full
                
            default:
                return .unknown
            }
        }
    }
}

extension Screen {
    
    public static var isCompact: Bool {
        return Level.current == .compact
    }
    
    public static var isRegular: Bool {
        return Level.current == .regular
    }
    
    public static var isFull: Bool {
        return Level.current == .full
    }
}

extension Int: ScreenCompatible {}
extension Bool: ScreenCompatible {}
extension Float: ScreenCompatible {}
extension Double: ScreenCompatible {}
extension String: ScreenCompatible {}
extension CGRect: ScreenCompatible {}
extension CGSize: ScreenCompatible {}
extension CGFloat: ScreenCompatible {}
extension CGPoint: ScreenCompatible {}
extension UIImage: ScreenCompatible {}
extension UIColor: ScreenCompatible {}
extension UIFont: ScreenCompatible {}
extension UIEdgeInsets: ScreenCompatible {}


fileprivate extension UIDevice {
    
    /// 是否使用了降采样
    static var isUsingDownsampling: Bool {
        // 比较屏幕尺寸
        let logicalSize = UIScreen.main.bounds.size
        let physicalSize = UIScreen.main.nativeBounds.size
        let scale = UIScreen.main.scale

        let calculatedPhysicalWidth = logicalSize.width * scale
        let calculatedPhysicalHeight = logicalSize.height * scale

        let widthEqual = Int(calculatedPhysicalWidth) == Int(physicalSize.width)
        let heightEqual = Int(calculatedPhysicalHeight) == Int(physicalSize.height)

        if !(widthEqual && heightEqual) {
            return true
        }
        
        // 检查设备型号
        let identifiers: Set<String> = [
            // iPhone Plus 系列
            "iPhone7,1",  // iPhone 6 Plus
            "iPhone8,2",  // iPhone 6s Plus
            "iPhone9,2", "iPhone9,4",  // iPhone 7 Plus
            "iPhone10,2", "iPhone10,5",  // iPhone 8 Plus
            // iPhone mini 系列
            "iPhone13,1",  // iPhone 12 mini
            "iPhone14,4",  // iPhone 13 mini
            // 添加其他使用降采样的设备型号（目前为止，这些设备已知使用降采样）
        ]
        
        return identifiers.contains(identifier)
    }
    
    static var iPhoneMini: Bool {
        let temp = ["iPhone13,1", "iPhone14,4"]
        
        switch identifier {
        case "iPhone13,1", "iPhone14,4":
            return true
            
        case "i386", "x86_64", "arm64":
            return temp.contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")
            
        default:
            return false
        }
    }
    
    static var iPhonePlus: Bool {
        let temp = [
            "iPhone7,1",
            "iPhone8,2",
            "iPhone9,2",
            "iPhone9,4",
            "iPhone10,2",
            "iPhone10,5"
        ]
        
        switch identifier {
        case
            "iPhone7,1",
            "iPhone8,2",
            "iPhone9,2",
            "iPhone9,4",
            "iPhone10,2",
            "iPhone10,5":
            return true
            
        case "i386", "x86_64", "arm64":
            return temp.contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")
            
        default:
            return false
        }
    }
    
    private static let identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    } ()
}

extension UIScreen {
    
    /// 真实宽高比 例如: iPhone 16 Pro (201:437)
    var aspectRatio: String {
        // 计算宽高比
        let (ratioWidth, ratioHeight) = calculateAspectRatio(
            width: nativeBounds.width,
            height: nativeBounds.height
        )
        print("屏幕比例：\(ratioWidth):\(ratioHeight)")
        return "\(ratioWidth):\(ratioHeight)"
    }
    
    /// 标准宽高比 例如: iPhone 16 Pro (9:19.5)
    var standardAspectRatio: String {
        // 获取近似的标准比例
        let result = getStandardAspectRatio(
            width: nativeBounds.width,
            height: nativeBounds.height
        )
        print("屏幕近似比例：\(result)")
        return result
    }
    
    private func calculateAspectRatio(width: CGFloat, height: CGFloat) -> (Int, Int) {
        // 计算最大公约数（欧几里得算法）
        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a
            var b = b
            while b != 0 {
                let temp = b
                b = a % b
                a = temp
            }
            return a
        }
        
        let precision: CGFloat = 1000  // 精度倍数
        let widthInt = Int(width * precision)
        let heightInt = Int(height * precision)
        
        let gcdValue = gcd(widthInt, heightInt)
        
        let ratioWidth = widthInt / gcdValue
        let ratioHeight = heightInt / gcdValue
        
        return (ratioWidth, ratioHeight)
    }
    
    private func getStandardAspectRatio(width: CGFloat, height: CGFloat) -> String {
        let aspectRatio = width / height
        
        // 常见的屏幕比例
        let commonRatios: [(ratio: CGFloat, description: String)] = [
            (16.0/9.0, "16:9"),
            (9.0/16.0, "9:16"),
            (4.0/3.0, "4:3"),
            (3.0/4.0, "3:4"),
            (19.5/9.0, "19.5:9"),
            (9.0/19.5, "9:19.5"),
            (2.0/1.0, "2:1"),
            (1.0/2.0, "1:2"),
            (1.0/1.0, "1:1")
        ]
        
        var closestRatio = commonRatios[0]
        var smallestDifference = abs(aspectRatio - closestRatio.ratio)
        
        for ratio in commonRatios {
            let difference = abs(aspectRatio - ratio.ratio)
            if difference < smallestDifference {
                smallestDifference = difference
                closestRatio = ratio
            }
        }
        
        return closestRatio.description
    }
}

#endif
