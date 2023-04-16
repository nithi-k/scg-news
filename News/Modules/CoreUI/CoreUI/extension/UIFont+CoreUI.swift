//
//  UIFont+CoreUI.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 2020/10/19.
//

import UIKit

extension UIFont {
    public static func customFont(name: String, size: CGFloat) -> UIFont {
        //return UIFont.systemFont(ofSize: size)
        guard let customFont = UIFont(name: name, size: size) else {
            fatalError("""
                Failed to load the \(name) font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return customFont
    }
    
    enum RegisterFontError: Error {
        case invalidFontFile
        case fontPathNotFound
        case initFontError
        case registerFailed
    }
    
    public static func register(path: String, type: String = "ttf") throws {
        let frameworkBundle = Bundle.coreUIResourceBundle()
        
        guard let resourceBundleURL = frameworkBundle.path(forResource: path, ofType: type) else {
            throw RegisterFontError.fontPathNotFound
        }
        guard
            let fontData = NSData(contentsOfFile: resourceBundleURL),
            let dataProvider = CGDataProvider.init(data: fontData) else {
            throw RegisterFontError.invalidFontFile
        }
        guard let fontRef = CGFont.init(dataProvider) else {
            throw RegisterFontError.initFontError
        }
        var errorRef: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) else {
            throw RegisterFontError.registerFailed
        }
    }
}
