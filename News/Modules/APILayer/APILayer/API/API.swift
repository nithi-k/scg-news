//
//  API.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi on 11/5/2564 BE.
//

import RxSwift
import Networking
import Core

struct EmptyResponse: Codable, AppResponse {
    var status: String?
    var code: String?
    var message: String?
}

protocol AppResponse: Codable {
    var status: String? { get set }
    var code: String? { get set }
    var message: String? { get set }
}

final class API {
    static private var networks = [String: Networking]()
    static private func networkFor<T: Endpoint>(endpoint: T) -> Networking {
        let urlEnv = APIConstants.shared.urlFor(endpoint: endpoint)
        if let network = networks[urlEnv.identifier] {
            return network
        }
        let url = urlEnv.url
        let session = URLSessionConfiguration.default
        session.timeoutIntervalForRequest = 60
        let network = Networking(
            baseURL: url,
            configuration: session)
        networks[urlEnv.identifier] = network
        
        return network
    }

    public init() {}

    static func registerFake<Request: Endpoint>(endpoint: Request, withFile fileName: String, bundle: Bundle) {
        let network = networkFor(endpoint: endpoint)
        switch endpoint.method {
        case .get:
            network.fakeGET(endpoint.path, fileName: fileName, bundle: bundle)
        case .post:
            network.fakePOST(endpoint.path, fileName: fileName, bundle: bundle)
        case .put:
            network.fakePUT(endpoint.path, fileName: fileName, bundle: bundle)
        case .patch:
            network.fakePATCH(endpoint.path, fileName: fileName, bundle: bundle)
        case .delete:
            network.fakeDELETE(endpoint.path, fileName: fileName, bundle: bundle)
        }
    }
    
    private static func generateHeaders(requestHeaders: [String: String]?) -> [String: String] {
        var headers: [String: String] = [:]
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        if let requestHeaders = requestHeaders {
            for key in requestHeaders.keys {
                headers[key] = requestHeaders[key]
            }
        }
        return headers
    }
    
    private static func handleResponseError(response: AppResponse) -> Error {
        return APIError(code: response.code ?? "Unknown code", message: response.message ?? "Unknown message")
    }

    static func call<Request: Endpoint, Response: Codable>(endpoint: Request, parameters: Any?) -> Observable<Response> {
        let network = networkFor(endpoint: endpoint)
        return Observable.create { observer -> Disposable in
            network.headerFields = generateHeaders(requestHeaders: endpoint.headers)
            let completion: (_ result: JSONResult) -> Void = { result in
                let decoder = JSONDecoder()
                switch result {
                case .success(let response):
                    do {
                        let checkError = try decoder.decode(EmptyResponse.self, from: response.data)
                        guard checkError.status != "error" else {
                            let error = handleResponseError(response: checkError)
                            observer.onError(error)
                            return
                        }
                        let resp = try decoder.decode(Response.self, from: response.data)
                        observer.onNext(resp)
                    } catch let error {
                        let status = (error as NSError).code
                        let message = error.localizedDescription
                        let appError = APIError(code: "\(status)", message: message)
                        observer.onError(appError)
                    }

                case .failure(let response):
                    print("debug error", response)
                    let status = (response.error as NSError).code
                    let message = response.error.localizedDescription
                    let appError = APIError(code: "\(status)", message: message)
                    observer.onError(appError)
                }
            }
            let requestId: String
            switch endpoint.method {
            case .get:
                requestId = network.get(endpoint.path, parameters: parameters, completion: completion)
            case .post:
                requestId = network.post(endpoint.path, parameters: parameters, completion: completion)
            case .put:
                requestId = network.put(endpoint.path, parameters: parameters, completion: completion)
            case .patch:
                requestId = network.patch(endpoint.path, parameters: parameters, completion: completion)
            case .delete:
                requestId = network.delete(endpoint.path, parameters: parameters, completion: completion)
            }

            return Disposables.create(with: {
                network.cancel(requestId)
            })
        }
    }
}
