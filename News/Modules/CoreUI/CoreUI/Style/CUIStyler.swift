//
//  CUIStyler.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 2020/10/15.
//

import UIKit

// MARK: - UI Styler
public struct CUIStyler {
    public static var color: CUIColorStylable = CUIColorStyler()
    
    public static var layout = CUILayoutStyler()
    
    public static var appearance = CUIAppearanceStyler()
    
    public static var font: CUIFontStylable {
        return CUIFontStyler()
    }
    
    public init() {}
}

// MARK: - Color Styler
public struct CUIColorStyler {
    public init() {}
}

extension CUIColorStyler: CUIColorStylable {
    public var green: UIColor {
        return UIColor(hexString: "#00b894")
    }
    
    public var blue: UIColor {
        return UIColor(hexString: "#0984e3")
    }
    
    public var red: UIColor {
        return UIColor(hexString: "#d63031")
    }
    
    public var white: UIColor {
        return UIColor(hexString: "#ffffff")
    }
    
    public var black: UIColor {
        return UIColor(hexString: "#2d3436")
    }
    
    public var lightGray: UIColor {
        return UIColor(hexString: "#dfe6e9")
    }
    
    public var darkGray: UIColor {
        return UIColor(hexString: "#636e72")
    }
}

// MARK: - Layout Styler
public struct CUILayoutStyler {
    public init() {}
}

extension CUILayoutStyler: CUILayoutStylable {
    public var zero: CGFloat { 0.0 }
    public var line: CGFloat { 1 }
    public var smallSpace: CGFloat { 4.0 }
    public var mediumSpace: CGFloat { 8.0 }
    public var standardSpace: CGFloat { 16.0 }
    public var largeSpace: CGFloat { 24.0 }
    
    public var buttonHeight: CGFloat { 48 }
    public var buttonBottomSpace: CGFloat { 40 }
}

// MARK: - Appearance Styler
public struct CUIAppearanceStyler {
    public init() {}
}

extension CUIAppearanceStyler: CUIAppearanceStylable {
    public var shadowOpacity: Float { 0.15 }
    public var shadowRadius: CGFloat { 8 }
    public var shadowOffset: CGSize { CGSize(width: 0, height: 2) }
    public var opacity: CGFloat { 0.45 }
    public var lineWidth: CGFloat { 1 }

    public var cornerRadius: CGFloat { 8 }
    public var cornerRadius1: CGFloat { 12 }

    public var borderWidth: CGFloat { 3 }
    public var borderWidth1: CGFloat { 2 }
}

// MARK: - Font Styler
public struct CUIFontStyler {
    public init() {}
}

extension CUIFontStyler: CUIFontStylable {
    public func book(ofSize size: CGFloat) -> UIFont {
        return UIFont.bookGothamRounded(ofSize: size)
    }
    
    public func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont.mediumGothamRounded(ofSize: size)
    }
    
    public func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont.boldGothamRounded(ofSize: size)
    }
    
    public func light(ofSize size: CGFloat) -> UIFont {
        return UIFont.lightGothamRounded(ofSize: size)
    }
}

private extension UIColor {
    ///  Creates an UIColor object from HEX string.
    ///
    ///  - Parameters:
    ///     - hexString: HEX string in "#363636" format.
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
    
        let red = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue = CGFloat(Int(color) & mask) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
