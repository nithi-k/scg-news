//
//  APIConstants.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi on 11/5/2564 BE.
//

import Foundation

public struct URLEnvironment: Equatable {
    public var url: String
    public var cert: String?
    public var name: String
    public var version: String
    public var apiKey: String
    public var debugMode: Bool
    public var identifier: String {
        return "\(name)-\(url)-\(version)"
    }

    public init(
        url: String,
        cert: String? = nil,
        name: String, version: String,
        apiKey: String,
        debugMode: Bool = false) {
        self.url = url
        self.cert = cert
        self.name = name
        self.version = version
        self.debugMode = debugMode
        self.apiKey = apiKey
    }
}

public class APIConstants {
    public static let shared = APIConstants()
    private init() {}
    private var _baseUrl: URLEnvironment!
    private var customUrls = [String: URLEnvironment]()

    public func configure(baseUrl: URLEnvironment) {
        _baseUrl = baseUrl
    }
    
    public var baseUrl: URLEnvironment {
        return _baseUrl
    }

    public func registerCustomUrlFor<T: Endpoint>(endpoint: T, url: URLEnvironment) {
        customUrls[T.identifier] = url
    }

    public func urlFor<T: Endpoint>(endpoint: T) -> URLEnvironment {
        return customUrls[T.identifier, default: baseUrl]
    }
}
