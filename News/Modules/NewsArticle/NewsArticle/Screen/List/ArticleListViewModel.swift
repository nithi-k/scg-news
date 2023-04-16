//  ArticleListViewModel.swift
//  Created by Nithi Kulasiriswatdi

import Core
import RxCocoa
import RxSwift
import Utils
import APILayer

class ArticleListViewModel: ViewModelType {
    var input: Input
    var output: Output
    private let disposeBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    
    // Input
    private let pagination = BehaviorSubject<Int>(value: 0)
    private let onSearching = BehaviorSubject<String>(value: "")
    
    // Output
    private let display = BehaviorSubject<[ArticleDisplayModel]>(value: [])
    
    // Input and Output
    private let selectedArticle = PublishSubject<ArticleDisplayModel>()

    struct Input {
        let pagination: AnyObserver<Int>
        let onSearching: AnyObserver<String>
        let selectedArticle: AnyObserver<ArticleDisplayModel>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let display: Driver<[ArticleDisplayModel]>
        let didSelecteArticle: Observable<ArticleDisplayModel>
        let currentPage: Observable<Int>
        let error: Observable<Error>
    }
    
    init() {
        input = Input(
            pagination: pagination.asObserver(),
            onSearching: onSearching.asObserver(),
            selectedArticle: selectedArticle.asObserver())
        output = Output(
            loading: activityIndicator.asDriver(onErrorJustReturn: false).asObservable(),
            display: display.asDriverOnErrorJustComplete(),
            didSelecteArticle: selectedArticle.asObservable(),
            currentPage: pagination.asObservable(),
            error: errorTracker.asObservable())
        observeInput()
    }
    
    private func observeInput() {
        disposeBag.insert([
            onSearching
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in
                    self?.display.onNext([]) // Clear display array
                    self?.pagination.onNext(1) // Reset pagination when starting seach
                }),
            pagination
                .filter { $0 > 0 }
                .withLatestFrom(onSearching) { ($0, $1) }
                .subscribe(onNext: { [weak self] page, search in
                    self?.sendRequest(search: search, page: page)
                })
        ])
    }
    
    private func sendRequest(search: String, page: Int) {
        let defaultSeach = "Today" // Default keyword as 'Today'
        let search = search.isEmpty ? defaultSeach : search
        let requst = NewsArticleEndpoint.Request(search: search, page: page)
        NewsArticleEndpoint
            .service
            .request(parameters: requst)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .catchErrorJustComplete()
            .compactMap { $0.articles }
            .map { articles in
                var display = articles.map {
                    ArticleDisplayModel(
                        title: $0.title ?? "",
                        imageURL: $0.urlToImage ?? "",
                        date: $0.publishedAt ?? "",
                        author: $0.author ?? "",
                        sourceURL: $0.source?.name ?? "",
                        description: $0.description ?? "",
                        articleURL: $0.url ?? "",
                        content: $0.content ?? "")
                }
                // Clean up data
                display.removeAll(where: { $0.imageURL.isEmpty || $0.author.isEmpty })
                return display
            }
            .map {
                Array(Set($0))
            }
            .withLatestFrom(display) { ($0, $1) }
            .map {
                // Append new data
                return $0.1 + $0.0
            }
            .bind(to: display)
            .disposed(by: disposeBag)
    }
}
