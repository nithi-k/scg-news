//  ArticleDetailViewModel.swift
//  Created by Nithi Kulasiriswatdi

import Core
import RxCocoa
import RxSwift
import Utils
import APILayer

class ArticleDetailViewModel: ViewModelType {
    var input: Input
    var output: Output
    private let disposeBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
  
    // input&output
    private let display = BehaviorSubject<ArticleDisplayModel?>(value: nil)
    
    struct Input {
        let article: AnyObserver<ArticleDisplayModel?>
    }
    
    struct Output {
        let display: Driver<ArticleDisplayModel>
    }
    
    init() {
        input = Input(article: display.asObserver())
        output = Output(display: display.compactMap { $0 }.asDriverOnErrorJustComplete())
    }
}
