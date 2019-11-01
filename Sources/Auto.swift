//
//  Auto.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2018/11/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#if canImport(Foundation)

import Foundation

#if os(iOS)

import UIKit

public enum Auto {
    
    /// 设置转换闭包
    ///
    /// - Parameter conversion: 转换闭包
    public static func set(conversion: @escaping ((Double) -> Double)) {
        conversionClosure = conversion
    }
    
    /// 转换 用于数值的等比例计算 如需自定义可重新设置
    static var conversionClosure: ((Double) -> Double) = { (origin) in
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return origin
        }
        
        let base = 375.0
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        return (origin * (width / base)).rounded(3)
    }
}

extension Auto {
    
    static func conversion(_ value: Double) -> Double {
        return conversionClosure(value)
    }
}

protocol AutoCalculationable {
    
    /// 自动计算
    ///
    /// - Returns: 结果
    func auto() -> Self
}

extension Double: AutoCalculationable {
    
    func auto() -> Double {
        return Auto.conversion(self)
    }
}

extension BinaryInteger {
    
    public func auto() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    public func auto<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    public func auto<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
}

extension BinaryFloatingPoint {
    
    public func auto() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    public func auto<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto())
    }
    public func auto<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto())
    }
}

extension CGPoint: AutoCalculationable {
    
    public func auto() -> CGPoint {
        return CGPoint(x: x.auto(), y: y.auto())
    }
}

extension CGSize: AutoCalculationable {
    
    public func auto() -> CGSize {
        return CGSize(width: width.auto(), height: height.auto())
    }
}

extension CGRect: AutoCalculationable {
    
    public func auto() -> CGRect {
        return CGRect(origin: origin.auto(), size: size.auto())
    }
}

extension CGVector: AutoCalculationable {
    
    public func auto() -> CGVector {
        return CGVector(dx: dx.auto(), dy: dy.auto())
    }
}

extension UIOffset: AutoCalculationable {
    
    public func auto() -> UIOffset {
        return UIOffset(horizontal: horizontal.auto(), vertical: vertical.auto())
    }
}

extension UIEdgeInsets: AutoCalculationable {
    
    public func auto() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.auto(),
            left: left.auto(),
            bottom: bottom.auto(),
            right: right.auto()
        )
    }
}


extension NSLayoutConstraint {
    
    @IBInspectable private var autoConstant: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            constant = constant.auto().rounded(0)
        }
    }
}

extension UIView {
    
    @IBInspectable private var autoCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            let value: CGFloat = newValue.auto().rounded(0)
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(value * 100)) / 100)
        }
    }
}

extension UILabel {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText?.mutableCopy() as? NSMutableAttributedString else {
                return
            }
            
            font = font.withSize(font.pointSize.auto().rounded(0))
            attributedText = text.reset(font: { $0.auto().rounded(0) })
        }
    }
    
    @IBInspectable private var autoLine: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText else { return }
            
            attributedText = text.reset(line: { $0.auto().rounded(0) })
        }
    }
    
    @IBInspectable private var autoShadowOffset: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            shadowOffset = shadowOffset.auto().rounded(0)
        }
    }
}

extension UITextView {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let font = font else { return }
            
            self.font = font.withSize(font.pointSize.auto().rounded(0))
        }
    }
}

extension UITextField {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let font = font else { return }
            
            self.font = font.withSize(font.pointSize.auto().rounded(0))
        }
    }
}

extension UIImageView {
    
    @IBInspectable private var autoImage: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            if let width = image?.size.width {
                image = image?.scaled(to: width.auto().rounded(0))
            }
            if let width = highlightedImage?.size.width {
                highlightedImage = highlightedImage?.scaled(to: width.auto().rounded(0))
            }
        }
    }
}

extension UIButton {
    
    @IBInspectable private var autoTitle: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            let states: [UIControl.State] = [
                .normal,
                .highlighted,
                .selected,
                .disabled
            ]
            
            if
                let _ = title(for: state),
                let label = titleLabel,
                let font = label.font {
                label.font = font.withSize(font.pointSize.auto().rounded(0))
            }
            
            let titles = states.enumerated().compactMap {
                (i, state) -> (Int, NSAttributedString)? in
                guard let t = attributedTitle(for: state) else { return nil }
                return (i, t)
            }
            titles.filtered(duplication: { $0.1 }).forEach {
                setAttributedTitle(
                    $0.1.reset(font: { $0.auto().rounded(0) }),
                    for: states[$0.0]
                )
            }
        }
    }
    
    @IBInspectable private var autoImage: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            let states: [UIControl.State] = [
                .normal,
                .highlighted,
                .selected,
                .disabled
            ]
            
            let images = states.enumerated().compactMap {
                (i, state) -> (Int, UIImage)? in
                guard let v = image(for: state) else { return nil }
                return (i, v)
            }
            images.filtered(duplication: { $0.1 }).forEach {
                setImage(
                    $0.1.scaled(to: $0.1.size.width.auto().rounded(0)),
                    for: states[$0.0]
                )
            }
            
            let backgrounds = states.enumerated().compactMap {
                (i, state) -> (Int, UIImage)? in
                guard let v = backgroundImage(for: state) else { return nil }
                return (i, v)
            }
            backgrounds.filtered(duplication: { $0.1 }).forEach {
                setBackgroundImage(
                    $0.1.scaled(to: $0.1.size.width.auto().rounded(0)),
                    for: states[$0.0]
                )
            }
        }
    }
    
    @IBInspectable private var autoTitleInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            titleEdgeInsets = titleEdgeInsets.auto().rounded(0)
        }
    }
    
    @IBInspectable private var autoImageInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            imageEdgeInsets = imageEdgeInsets.auto().rounded(0)
        }
    }
    
    @IBInspectable private var autoContentInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            contentEdgeInsets = contentEdgeInsets.auto().rounded(0)
        }
    }
}

@available(iOS 9.0, *)
extension UIStackView {
    
    @IBInspectable private var autoSpacing: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            spacing = spacing.auto().rounded(0)
        }
    }
}

fileprivate extension NSAttributedString {
    
    func reset(font size: (CGFloat) -> CGFloat) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        enumerateAttributes(
            in: NSRange(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (attributes, range, stop) in
            var temp = attributes
            if let font = attributes[.font] as? UIFont {
                temp[.font] = font.withSize(size(font.pointSize))
            }
            string.setAttributes(temp, range: range)
        }
        return string
    }
    
    func reset(line spacing: (CGFloat) -> CGFloat) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        enumerateAttributes(
            in: NSRange(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (attributes, range, stop) in
            var temp = attributes
            if let paragraph = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
                paragraph.lineSpacing = spacing(paragraph.lineSpacing)
                temp[.paragraphStyle] = paragraph
            }
            string.setAttributes(temp, range: range)
        }
        return string
    }
}

fileprivate extension UIImage {
    
    func scaled(to width: CGFloat, opaque: Bool = false) -> UIImage? {
        guard self.size.width > 0 else {
            return nil
        }
        
        let scale = width / self.size.width
        let size = CGSize(width: width, height: self.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(origin: .zero, size: size))
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return new
    }
}

fileprivate extension Array {
    
    func filtered<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        return try reduce(into: [Element]()) { (result, e) in
            let contains = try result.contains { try closure($0) == closure(e) }
            result += contains ? [] : [e]
        }
    }
}

public extension Double {
    
    func rounded(_ decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(max(0, decimalPlaces)))
        return (self * divisor).rounded() / divisor
    }
}

public extension BinaryFloatingPoint {
    
    func rounded(_ decimalPlaces: Int) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.rounded(decimalPlaces)
    }
    
    func rounded<T>(_ decimalPlaces: Int) -> T where T: BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.rounded(decimalPlaces))
    }
}

public extension CGPoint {
    
    func rounded(_ decimalPlaces: Int) -> CGPoint {
        return CGPoint(x: x.rounded(decimalPlaces), y: y.rounded(decimalPlaces))
    }
}

public extension CGSize {
    
    func rounded(_ decimalPlaces: Int) -> CGSize {
        return CGSize(width: width.rounded(decimalPlaces), height: height.rounded(decimalPlaces))
    }
}

public extension CGRect {
    
    func rounded(_ decimalPlaces: Int) -> CGRect {
        return CGRect(origin: origin.rounded(decimalPlaces), size: size.rounded(decimalPlaces))
    }
}

public extension UIEdgeInsets {
    
    func rounded(_ decimalPlaces: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.rounded(decimalPlaces),
            left: left.rounded(decimalPlaces),
            bottom: bottom.rounded(decimalPlaces),
            right: right.rounded(decimalPlaces)
        )
    }
}

#endif

#endif
