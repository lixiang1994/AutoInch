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

extension Int: InchableAuto {}
extension Float: InchableAuto {}
extension CGFloat: InchableAuto {}
extension Double: InchableAuto {}
extension String: Inchable {}

protocol Inchable {
    
    func i58full(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i35(_ value: Self) -> Self
}

protocol InchableAuto: Inchable {
    
    func auto(_ base: Self) -> Self
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
}

extension InchableAuto where Self == Int {
    func auto(_ base: Self) -> Self { return Self(Double(self).auto(Double(base))) }
}
extension InchableAuto where Self == Float {
    func auto(_ base: Self) -> Self { return Self(Double(self).auto(Double(base))) }
}
extension InchableAuto where Self == CGFloat {
    func auto(_ base: Self) -> Self { return Self(Double(self).auto(Double(base))) }
}
extension InchableAuto where Self == Double {
    func auto(_ base: Self = 375.0) -> Self {
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        return self * (width / base)
    }
}
