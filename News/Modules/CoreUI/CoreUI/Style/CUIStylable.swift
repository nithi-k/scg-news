//
//  CUIStylable.swift
//  CoreUI
//
//  Created by Russell Yi on 2020/10/16.
//

import UIKit

// MARK: - Color Style
// ref: https://flatuicolors.com/palette/us
public protocol CUIColorStylable {
    var green: UIColor { get }
    var blue: UIColor { get }
    var red: UIColor { get }
    var white: UIColor { get }
    var black: UIColor { get }
    var lightGray: UIColor { get }
    var darkGray: UIColor { get }
}

extension CUIColorStylable {
    // You can add deafault value at here
}

// MARK: - Layout Style
public protocol CUILayoutStylable {
    var zero: CGFloat { get }
    var smallSpace: CGFloat { get }
    var mediumSpace: CGFloat { get }
    var standardSpace: CGFloat { get }
    var largeSpace: CGFloat { get }
    
    var buttonHeight: CGFloat { get }
    var buttonBottomSpace: CGFloat { get }
}

extension CUILayoutStylable {
    // You can add deafault value at here
}

// MARK: - Appearance Style
public protocol CUIAppearanceStylable {
    var shadowOpacity: Float { get }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGSize { get }
    var opacity: CGFloat { get }
    var lineWidth: CGFloat { get }

    var cornerRadius: CGFloat { get }
    var cornerRadius1: CGFloat { get }

    var borderWidth: CGFloat { get }
    var borderWidth1: CGFloat { get }
}

extension CUIAppearanceStylable {
    // You can add deafault value at here
}

// MARK: - Font Style
public protocol CUIFontStylable {
    func book(ofSize size: CGFloat) -> UIFont
    func medium(ofSize size: CGFloat) -> UIFont
    func bold(ofSize size: CGFloat) -> UIFont
    func light(ofSize size: CGFloat) -> UIFont
}

extension CUIFontStylable {
    // You can add deafault value at here
}
