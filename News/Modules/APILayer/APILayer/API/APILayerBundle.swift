//
//  APILayerBundle.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi on 30/4/2564 BE.
//

import Foundation

public enum APILayerFramework {
    public static let useResourceBundles = true
    public static let bundleName = "APILayer.bundle"
}

private class GetBundle {}

extension Bundle {
    public class func apiLayerResourceBundle() -> Bundle {
        let framework = Bundle(for: GetBundle.self)
        guard APILayerFramework.useResourceBundles else {
            return framework
        }
        guard let resourceBundleURL = framework.url(
            forResource: APILayerFramework.bundleName,
            withExtension: nil)
        else {
            fatalError("\(APILayerFramework.bundleName) not found!")
        }
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access \(APILayerFramework.bundleName)")
        }
        return resourceBundle
    }
}
