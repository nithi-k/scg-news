//  TopHeadLinesEndpoint.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi


import Foundation
import Networking

public struct NewsArticleEndpoint: Endpoint {
    public static let service = NewsArticleEndpoint()
    private init() {}

    public let path: String = "/everything"
    public let method: RequestType = .get
    public var headers: [String: String]?

    public struct Request: Codable {
        let search: String
        // static value
        var from = "2023-04-00"     // TODO: can be improve to dynamic timerange
        var sortBy = "publishedAt"
        let page: Int
        var pageSize = 20
        
        private enum CodingKeys: String, CodingKey {
            case search = "q", from, sortBy, page, pageSize
        }
        
        public init(search: String, page: Int) {
            self.search = search
            self.page = page
        }
    }
    public struct Response: Codable {
        public let status: String?
        public let articles: [NewsArticle]?
        public let message: String?
    }
}

public struct NewsArticle: Codable {
    public struct Source: Codable {
        public let id: String?
        public let name: String?
    }
    public let source: Source?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?
}
