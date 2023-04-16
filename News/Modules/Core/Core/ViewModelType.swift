//
//  ViewModelType.swift
//  NewsArticle
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
