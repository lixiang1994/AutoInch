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

public enum Auto {
    
    /// 转换 用于数值的等比例计算 如需自定义可重新赋值
    public static var conversion: ((Double) -> Double) = { (origin) in
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return origin
        }
        
        let base = 375.0 
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        return origin * (width / base)
    }
    
    /// 适配 用于可视化等比例计算 如需自定义可重新赋值
    public static var adaptation: ((CGFloat) -> CGFloat) = { (origin) in
        return origin.auto()
    }
}

fileprivate protocol AutoCalculationable {
    
    /// 自动计算
    ///
    /// - Returns: 结果
    func auto() -> Double
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


extension NSLayoutConstraint {
    
    @IBInspectable private var autoConstant: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            constant = Auto.adaptation(constant)
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
            
            font = UIFont(
                name: font.fontName,
                size: Auto.adaptation(font.pointSize)
            )
            attributedText = text.reset(font: { Auto.adaptation($0) })
        }
    }
    
    @IBInspectable private var autoLine: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText else { return }
            
            attributedText = text.reset(line: { Auto.adaptation($0) })
        }
    }
}

extension UITextView {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let font = font else { return }
            
            self.font = UIFont(
                name: font.fontName,
                size: Auto.adaptation(font.pointSize)
            )
        }
    }
}

extension UITextField {
    
    @IBInspectable private var autoFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let font = font else { return }
            
            self.font = UIFont(
                name: font.fontName,
                size: Auto.adaptation(font.pointSize)
            )
        }
    }
}

extension UIImageView {
    
    @IBInspectable private var autoImage: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            if let width = image?.size.width {
                image = image?.scaled(to: Auto.adaptation(width))
            }
            if let width = highlightedImage?.size.width {
                highlightedImage = highlightedImage?.scaled(to: Auto.adaptation(width))
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
                label.font = UIFont(
                    name: font.fontName,
                    size: Auto.adaptation(font.pointSize)
                )
            }
            
            let titles = states.enumerated().compactMap {
                (i, state) -> (Int, NSAttributedString)? in
                guard let t = attributedTitle(for: state) else { return nil }
                return (i, t)
            }
            titles.filtered(duplication: { $0.1 }).forEach {
                setAttributedTitle(
                    $1.reset(font: { Auto.adaptation($0) }),
                    for: states[$0]
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
                    $1.scaled(to: Auto.adaptation($1.size.width)),
                    for: states[$0]
                )
            }
            
            let backgrounds = states.enumerated().compactMap {
                (i, state) -> (Int, UIImage)? in
                guard let v = backgroundImage(for: state) else { return nil }
                return (i, v)
            }
            backgrounds.filtered(duplication: { $0.1 }).forEach {
                setBackgroundImage(
                    $1.scaled(to: Auto.adaptation($1.size.width)),
                    for: states[$0]
                )
            }
        }
    }
    
    @IBInspectable private var autoTitleInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            titleEdgeInsets = UIEdgeInsets(
                top: Auto.adaptation(titleEdgeInsets.top),
                left: Auto.adaptation(titleEdgeInsets.left),
                bottom: Auto.adaptation(titleEdgeInsets.bottom),
                right: Auto.adaptation(titleEdgeInsets.right)
            )
        }
    }
    
    @IBInspectable private var autoImageInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            imageEdgeInsets = UIEdgeInsets(
                top: Auto.adaptation(imageEdgeInsets.top),
                left: Auto.adaptation(imageEdgeInsets.left),
                bottom: Auto.adaptation(imageEdgeInsets.bottom),
                right: Auto.adaptation(imageEdgeInsets.right)
            )
        }
    }
    
    @IBInspectable private var autoContentInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            contentEdgeInsets = UIEdgeInsets(
                top: Auto.adaptation(contentEdgeInsets.top),
                left: Auto.adaptation(contentEdgeInsets.left),
                bottom: Auto.adaptation(contentEdgeInsets.bottom),
                right: Auto.adaptation(contentEdgeInsets.right)
            )
        }
    }
}

@available(iOS 9.0, *)
extension UIStackView {
    
    @IBInspectable private var autoSpacing: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            spacing = Auto.adaptation(spacing)
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
                temp[.font] = UIFont(
                    name: font.fontName,
                    size: size(font.pointSize)
                )
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
        return try reduce(into: [Element]()) {
            if try !$0.compactMap({ try closure($0) }).contains(try closure($1)) {
                $0.append($1)
            }
        }
    }
}

#endif
