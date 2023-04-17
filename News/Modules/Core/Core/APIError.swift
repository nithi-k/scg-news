//
//  APIError.swift
//  Core
//
//  Created by Nithi Kulasiriswatdi on 16/4/2566 BE.
//

import Foundation
public struct APIError: LocalizedError, Hashable {
    public var code: String
    public var message: String
    public var httpError: Int?

    public init(code: String, message: String, httpError: Int? = nil) {
        self.code = code
        self.message = message
        self.httpError = httpError
    }
    
    public var errorCode: String {
        return code
    }

    public var errorDescription: String? {
        return message
    }
}
