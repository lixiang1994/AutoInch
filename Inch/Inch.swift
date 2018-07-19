//
//  Inch.swift
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
import UIKit

postfix operator <~
postfix operator >~
postfix func <~ (l: InchType) -> [InchType] {
    guard l.rawValue >= 0 else { return [] }
    return Array(InchType.all[l.rawValue ..< InchType.all.count])
}
postfix func >~ (l: InchType) -> [InchType] {
    guard l.rawValue < InchType.all.count else { return InchType.all }
    return Array(InchType.all[0 ... l.rawValue])
}

enum InchType: Int {
    case unknown = -1
    case i35
    case i40
    case i47
    case i55
    case i58Full
    
    static let current: InchType = {
        let screenWidth = Float(UIScreen.main.bounds.width)
        let screenHeight = Float(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        let height = max(screenWidth, screenHeight)
        
        if width == 320, height == 480 { return .i35 }
        if width == 320, height == 568 { return .i40 }
        if width == 375, height == 667 { return .i47 }
        if width == 414, height == 736 { return .i55 }
        if width == 375, height == 812 { return .i58Full }
        
        return .unknown
    } ()
    
    static let all: [InchType] = [.i35,
                                  .i40,
                                  .i47,
                                  .i55,
                                  .i58Full]
}

extension InchType: Equatable {
    static func == (lhs: InchType, rhs: InchType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension InchType: Comparable {
    static func < (lhs: InchType, rhs: InchType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension InchType: Strideable {
    typealias Stride = Int
    
    func distance(to other: InchType) -> Int {
        return 1
    }
    
    func advanced(by n: Int) -> InchType {
        return InchType(rawValue: n) ?? .unknown
    }
}

extension Int: Inchable {}
extension Float: Inchable {}
extension CGFloat: Inchable {}
extension Double: Inchable {}
extension String: Inchable {}

protocol Inchable {
    
    func i58full(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i35(_ value: Self) -> Self
    
    func inchs(_ inchs: [InchType], _ value: Self) -> Self
    func inchs(_ range: Range<InchType>, _ value: Self) -> Self
    func inchs(_ range: ClosedRange<InchType>, _ value: Self) -> Self
}

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
    
    func inchs(_ inchs: [InchType], _ value: Self) -> Self {
        return inchs.contains(.current) ? value : self
    }
    func inchs(_ range: Range<InchType>, _ value: Self) -> Self {
        return range ~= .current ? value : self
    }
    func inchs(_ range: ClosedRange<InchType>, _ value: Self) -> Self {
        return range ~= .current ? value : self
    }
    func inchs(_ range: CountableRange<InchType>, _ value: Self) -> Self {
        return range ~= .current ? value : self
    }
}

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

extension BinaryInteger {
    
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
    
    func auto<T: BinaryInteger>(_ baseWidth: Double = 375) -> T {
        let temp: Double = auto(baseWidth)
        return T(temp)
    }
    func auto<T: BinaryFloatingPoint>(_ baseWidth: Double = 375) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto(baseWidth))
    }
}
