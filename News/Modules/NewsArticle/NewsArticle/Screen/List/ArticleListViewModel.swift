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
    
    // Scheduler
    private let observationScheduler: SchedulerType
    
    // Input
    private let pagination = BehaviorSubject<Int>(value: 0)
    private let onSearching = BehaviorSubject<String>(value: "")
    private let reachedBottom = PublishSubject<Void>()
    private let searchButtonClicked = PublishSubject<Void>()
    
    // Output
    private let display = BehaviorSubject<[ArticleDisplayModel]>(value: [])
    
    // Input and Output
    private let selectedArticle = PublishSubject<ArticleDisplayModel>()
    private let selectItemAtIndex = PublishSubject<Int>()
    
    struct Input {
        let pagination: AnyObserver<Int>
        let onSearching: AnyObserver<String>
        let selectedArticle: AnyObserver<ArticleDisplayModel>
        let reachedBottom: AnyObserver<Void>
        let searchButtonClicked: AnyObserver<Void>
        let selectItemAtIndex: AnyObserver<Int>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let display: Driver<[ArticleDisplayModel]>
        let didselectItemAtIndex: Observable<Int>
        let didSelecteArticle: Observable<ArticleDisplayModel>
        let currentPage: Observable<Int>
        let error: Observable<Error>
    }
    
    
    /// Init ViewModel
    /// - Parameter observationScheduler: Observable SchedulerType (default as MainScheduler.instance)
    init(observationScheduler: SchedulerType = MainScheduler.instance) {
        self.observationScheduler = observationScheduler
        
        input = Input(
            pagination: pagination.asObserver(),
            onSearching: onSearching.asObserver(),
            selectedArticle: selectedArticle.asObserver(),
            reachedBottom: reachedBottom.asObserver(),
            searchButtonClicked: searchButtonClicked.asObserver(),
            selectItemAtIndex: selectItemAtIndex.asObserver()
        )
        
        output = Output(
            loading: activityIndicator.asDriver(onErrorJustReturn: false).asObservable(),
            display: display.asDriverOnErrorJustComplete(),
            didselectItemAtIndex: selectItemAtIndex.asObservable(),
            didSelecteArticle: selectedArticle.asObservable(),
            currentPage: pagination.asObservable(),
            error: errorTracker.asObservable()
        )
        observeInput()
    }
    
    /// Observe Input
    private func observeInput() {
        disposeBag.insert([
            // When search button is clicked, get the first article from the display array and bind it to selectedArticle input
            searchButtonClicked
                .map { 0 }
                .bind(to: selectItemAtIndex),
            
            // When tableView reaches bottom, get the current page from output and increment it by 1, then bind it to pagination input
            reachedBottom
                .withLatestFrom(output.display)
                .filter { !$0.isEmpty }
                .withLatestFrom(output.loading)
                .filter { !$0 }
                .withLatestFrom(output.currentPage)
                .map { $0 + 1 }
                .bind(to: input.pagination),
            
            selectItemAtIndex
                .delay(.milliseconds(100), scheduler: observationScheduler)
                .withLatestFrom(output.display) { ($0, $1) }
                .filter { index, display in
                    0 ..< display.count ~= index // check if index is in range
                }
                .map { index, display in display[index] }
                .bind(to: input.selectedArticle),
            
            onSearching
                .debounce(.milliseconds(300), scheduler: observationScheduler)
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
    
    /// send NewsArticleEndpoint.Request request
    /// - Parameters:
    ///   - search: search string
    ///   - page: pagination
    private func sendRequest(search: String, page: Int) {
        let defaultSeach = "Today" // Default keyword as 'Today'
        let search = search.isEmpty ? defaultSeach : search
        let requst = NewsArticleEndpoint.Request(search: search, page: page)
        NewsArticleEndpoint
            .service
            .request(parameters: requst)
            .observe(on: observationScheduler)
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
            .subscribe(onNext: { [weak self] in
                self?.display.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
