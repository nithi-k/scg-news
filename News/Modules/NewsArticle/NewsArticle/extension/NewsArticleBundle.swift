//
//  NewsArticleBundle.swift
//  NewsArticle
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import Foundation

public enum CorUIFrameWork {
    public static let useResourceBundles = true
    
    public static let bundleName = "NewsArticle.bundle"
}

private class NewsArticle {}

extension Bundle {
    public class func resourceBundle() -> Bundle {
        let framework = Bundle(for: NewsArticle.self)
        
        guard CorUIFrameWork.useResourceBundles else {
            return framework
        }
        
        guard let resourceBundleURL = framework.url(forResource: CorUIFrameWork.bundleName, withExtension: nil) else {
            fatalError("\(CorUIFrameWork.bundleName) not found!")
        }
        
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access \(CorUIFrameWork.bundleName)")
        }
        
        return resourceBundle
    }
}

extension UIImage {
    class func image(named: String) -> UIImage {
        return UIImage(named: named, in: Bundle.resourceBundle(), compatibleWith: nil) ?? UIImage()
    }
}
