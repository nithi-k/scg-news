//
//  Endpoint.swift
//  Core
//
//  Created by Nithi Kulasiriswatdi on 11/5/2564 BE.
//

import Foundation
import RxSwift
import Networking

public enum RequestType: String {
    case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE"
}

public protocol Endpoint {
    associatedtype Request: Codable
    associatedtype Response: Codable
    
    static var identifier: String { get }
    var path: String { get }
    var method: RequestType { get }
    var headers: [String: String]? { get }
}

public extension Endpoint {
    static var identifier: String {
        return String(describing: self)
    }
    
    func registerFake(withResponseFile fileName: String) {
        API.registerFake(endpoint: self, withFile: fileName, bundle: Bundle.apiLayerResourceBundle())
    }
    
    func request(parameters: Request) -> Observable<Response> {
        var params = [String: Any]()
        do { params = try parameters.asDictionary() } catch {}
        params["apiKey"] = APIConstants.shared.baseUrl.apiKey
        return API.call(endpoint: self, parameters: params)
    }
    
    func request(parameters: [Request]) -> Observable<Response> {
        var params = [[String: Any]]()
        do { params = try parameters.map { request in
            return try request.asDictionary()
        } } catch {}
        params.append(["apiKey": APIConstants.shared.baseUrl.apiKey])
        return API.call(endpoint: self, parameters: params)
    }
}
