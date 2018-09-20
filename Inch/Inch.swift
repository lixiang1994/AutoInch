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
#if os(iOS)
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

typealias InchNumber = CGFloat

enum InchType: Int {
    case unknown = -1
    case i35
    case i40
    case i47
    case i55
    case i58Full
    case i61Full
    case i65Full
    
    var width: InchNumber {
        switch self {
        case .unknown:  return 0
        case .i35:      return 320
        case .i40:      return 320
        case .i47:      return 375
        case .i55:      return 414
        case .i58Full:  return 375
        case .i61Full:  return 414
        case .i65Full:  return 414
        }
    }
    
    var height: InchNumber {
        switch self {
        case .unknown:  return 0
        case .i35:      return 480
        case .i40:      return 568
        case .i47:      return 667
        case .i55:      return 736
        case .i58Full:  return 812
        case .i61Full:  return 896
        case .i65Full:  return 896
        }
    }
    
    private var size: CGSize { return CGSize(width: width, height: height) }
    
    static func type(size: CGSize) -> InchType {
        let width = min(size.width, size.height)
        let height = max(size.width, size.height)
        let size = CGSize(width: width, height: height)
        
        switch size {
        case InchType.i35.size:     return .i35
        case InchType.i40.size:     return .i40
        case InchType.i47.size:     return .i47
        case InchType.i55.size:     return .i55
        case InchType.i58Full.size: return .i58Full
        case InchType.i61Full.size: return .i61Full
        case InchType.i65Full.size: return .i65Full
        default:                    return .unknown
        }
    }
    
    static let current: InchType = type(size: UIScreen.main.bounds.size)
    
    /// swift4.2可以去掉
    static let all: [InchType] = [.i35, .i40, .i47, .i55, .i58Full, .i61Full, i65Full]
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
extension Double: Inchable {}
extension String: Inchable {}
extension CGRect: Inchable {}
extension CGSize: Inchable {}
extension CGFloat: Inchable {}
extension CGPoint: Inchable {}

protocol Inchable {
    
    func i35(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i58full(_ value: Self) -> Self
    func i61full(_ value: Self) -> Self
    func i65full(_ value: Self) -> Self
    
    func w320(_ value: Self) -> Self
    func w375(_ value: Self) -> Self
    func w414(_ value: Self) -> Self
}

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
    func ifull(_ value: Self) -> Self {
        return matching([.i58Full, .i61Full, .i65Full], value)
    }
    
    func w320(_ value: Self) -> Self {
        return matching(width: 320, value)
    }
    func w375(_ value: Self) -> Self {
        return matching(width: 375, value)
    }
    func w414(_ value: Self) -> Self {
        return matching(width: 414, value)
    }
    
    private func matching(type: InchType, _ value: Self) -> Self {
        return InchType.current == type ? value : self
    }
    private func matching(width: InchNumber, _ value: Self) -> Self {
        return InchType.current.width == width ? value : self
    }
    /// 内测方法
    private func matching(_ types: [InchType], _ value: Self) -> Self {
        return types.contains(.current) ? value : self
    }
    private func matching(_ range: Range<InchType>, _ value: Self) -> Self {
        return range ~= .current ? value : self
    }
    private func matching(_ range: ClosedRange<InchType>, _ value: Self) -> Self {
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

#endif
