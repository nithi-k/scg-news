//
//  NewsArticleCoordinator.swift
//  Camera
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import Core
import RxSwift

public class NewsArticleCoordinator: Coordinator {
    public var navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        navigateToArticleList()
    }
}

// MARK: private
extension NewsArticleCoordinator {
    private func navigateToArticleList() {
        let viewModel = ArticleListViewModel()
        let viewController = ArticleListViewController()
        viewController.configViewModel(viewModel: viewModel)
        
        let output = viewModel.output
        disposeBag.insert([
            output
                .didSelecteArticle
                .subscribe(onNext: { [weak self] in
                    self?.navigateToArticleDetail($0, rootViewController: viewController)
                })
        ])
        
        pushTo(viewController: viewController)
    }
    
    private func navigateToArticleDetail(_ selectedArticle: ArticleDisplayModel, rootViewController: ArticleListViewController) {
        let viewModel = ArticleDetailViewModel()
        viewModel.input.article.onNext(selectedArticle)
        let viewController = ArticleDetailViewController()
        viewController.configViewModel(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        viewController.transitioningDelegate = rootViewController
        rootViewController.present(viewController, animated: true)
    }
    
    private func navigateToSeach() {
        print("navigateToSeach")
    }
}
