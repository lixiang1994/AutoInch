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

import Foundation

#if os(iOS)

import UIKit

public protocol AutoCalculationable {
    
    /// 自动计算
    ///
    /// - Returns: 结果
    func auto() -> Double
}

//extension Double {
//    /// 扩展Double类 重写auto()实现
//    func auto() -> Double {
//        // ... 自定义计算处理
//        return self
//    }
//}

extension AutoCalculationable where Self == Double {
    
    public func auto() -> Double {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return self
        }
        
        let base = 375.0
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        return self * (width / base)
    }
}

extension Double: AutoCalculationable { }

extension BinaryInteger {
    
    public func auto() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    public func auto<T: BinaryInteger>() -> T {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    public func auto<T: BinaryFloatingPoint>() -> T {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
}

extension BinaryFloatingPoint {
    
    public func auto() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    public func auto<T: BinaryInteger>() -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto())
    }
    public func auto<T: BinaryFloatingPoint>() -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto())
    }
}

public protocol AutoAdapterable {
    func adapt(origin value: CGFloat) -> CGFloat
}

extension AutoAdapterable {
    public func adapt(origin value: CGFloat) -> CGFloat {
        return value.auto()
    }
}

extension UILabel: AutoAdapterable { }
extension UIButton: AutoAdapterable { }
extension UITextView: AutoAdapterable { }
extension UITextField: AutoAdapterable { }
extension NSLayoutConstraint: AutoAdapterable { }

extension NSLayoutConstraint {
    
    @IBInspectable private var autoConstant: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            constant = adapt(origin: constant)
        }
    }
}

extension UILabel {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText else { return }
            
            attributedText = text.reset(font: { adapt(origin: $0) })
        }
    }
    
    @IBInspectable private var autoLine: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText else { return }
            
            attributedText = text.reset(line: { adapt(origin: $0) })
        }
    }
}

extension UITextView {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let size = font?.pointSize else { return }
            
            font = font?.withSize(adapt(origin: size))
        }
    }
}

extension UITextField {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let size = font?.pointSize else { return }
            
            font = font?.withSize(adapt(origin: size))
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
            
            if let _ = title(for: state), let label = titleLabel {
                let size = label.font.pointSize
                label.font = label.font.withSize(adapt(origin: size))
            }
            
            for state in states {
                if let text = attributedTitle(for: state) {
                    let title = text.reset(font: { adapt(origin: $0) })
                    setAttributedTitle(title, for: state)
                }
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
            
            for state in states {
                if let image = image(for: state) {
                    let width = adapt(origin: image.size.width)
                    let new = image.scaled(to: width)
                    setImage(new, for: state)
                }
                if let image = backgroundImage(for: state) {
                    let width = adapt(origin: image.size.width)
                    let new = image.scaled(to: width)
                    setBackgroundImage(new, for: state)
                }
            }
        }
    }
    
    @IBInspectable private var autoTitleInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            titleEdgeInsets = UIEdgeInsets(
                top: adapt(origin: titleEdgeInsets.top),
                left: adapt(origin: titleEdgeInsets.left),
                bottom: adapt(origin: titleEdgeInsets.bottom),
                right: adapt(origin: titleEdgeInsets.right)
            )
        }
    }
    
    @IBInspectable private var autoImageInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            imageEdgeInsets = UIEdgeInsets(
                top: adapt(origin: imageEdgeInsets.top),
                left: adapt(origin: imageEdgeInsets.left),
                bottom: adapt(origin: imageEdgeInsets.bottom),
                right: adapt(origin: imageEdgeInsets.right)
            )
        }
    }
    
    @IBInspectable private var autoContentInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            contentEdgeInsets = UIEdgeInsets(
                top: adapt(origin: contentEdgeInsets.top),
                left: adapt(origin: contentEdgeInsets.left),
                bottom: adapt(origin: contentEdgeInsets.bottom),
                right: adapt(origin: contentEdgeInsets.right)
            )
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

#endif
