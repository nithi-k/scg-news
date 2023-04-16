//
//  CUIFont.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import UIKit


public enum AppFont {
    // Only call load font once
    public static let registerFonts: () = {
        [GothamRounded.book, GothamRounded.medium, GothamRounded.bold, GothamRounded.light].forEach { name in
            try? UIFont.register(path: name, type: "otf")
        }
    }()

    public static func showAllFonts() {
        UIFont.familyNames.forEach { familyName in
            UIFont.fontNames(forFamilyName: familyName).forEach({
                print("Family Name: \(familyName), Font Name: \($0)")
            })
        }
    }
}

public enum GothamRounded {
    static let book = "GothamRounded-Book"
    static let medium = "GothamRounded-Medium"
    static let bold = "GothamRounded-Bold"
    static let light = "GothamRounded-Light"
}

public extension UIFont {
    static func bookGothamRounded(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.customFont(name: GothamRounded.book, size: fontSize)
    }
    
    static func mediumGothamRounded(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.customFont(name: GothamRounded.medium, size: fontSize)
    }
    
    static func boldGothamRounded(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.customFont(name: GothamRounded.bold, size: fontSize)
    }
    
    static func lightGothamRounded(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.customFont(name: GothamRounded.light, size: fontSize)
    }
}
