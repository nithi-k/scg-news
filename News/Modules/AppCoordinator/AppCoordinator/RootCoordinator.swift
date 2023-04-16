//
//  RootCoordinator.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import Foundation
import Core
import NewsArticle

public class RootCoordinator: Coordinator {
    public var navigationController: UINavigationController
    // Coordinators
    private var newsArticleCoordinator: NewsArticleCoordinator?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        self.navigateToNewsArtical()
    }
}
// MARK: private
extension RootCoordinator {
    private func navigateToNewsArtical() {
        newsArticleCoordinator = NewsArticleCoordinator(navigationController: navigationController)
        newsArticleCoordinator?.start()
    }
}
