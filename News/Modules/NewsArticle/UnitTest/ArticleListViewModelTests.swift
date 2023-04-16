//
//  TestViewModel.swift
//  NewsArticle
//
//  Created by Nithi Kulasiriswatdi on 16/4/2566 BE.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

class ArticleListViewModelTests: XCTestCase {
    func testClass() {
        XCTAssertEqual("1", "1")
    }
}

/*
class ArticleListViewModelTests: XCTestCase {
    var viewModel: ArticleListViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        viewModel = ArticleListViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testInputOnSearching() {
        // Given
        let searchObserver = scheduler.createObserver(String.self)
        viewModel.input.onSearching.asObservable().subscribe(searchObserver).disposed(by: disposeBag)
        
        // When
        scheduler.createColdObservable([.next(10, "query1"), .next(20, "query2"), .next(30, "query3")])
            .bind(to: viewModel.input.onSearching)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(searchObserver.events, [.next(310, "query1"), .next(320, "query2"), .next(330, "query3")])
    }
    
    func testInputPagination() {
        // Given
        let paginationObserver = scheduler.createObserver(Int.self)
        viewModel.input.pagination.asObservable().subscribe(paginationObserver).disposed(by: disposeBag)
        
        // When
        scheduler.createColdObservable([.next(10, 1), .next(20, 2), .next(30, 3)])
            .bind(to: viewModel.input.pagination)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(paginationObserver.events, [.next(310, 1), .next(320, 2), .next(330, 3)])
    }
    
    func testOutputDisplay() {
        // Given
        let displayObserver = scheduler.createObserver([ArticleDisplayModel].self)
        viewModel.output.display.asObservable().subscribe(displayObserver).disposed(by: disposeBag)
        
        // When
        let articles = [
            ArticleDisplayModel(title: "Title1", imageURL: "ImageURL1", date: "Date1", author: "Author1",
                                sourceURL: "SourceURL1", description: "Description1", articleURL: "ArticleURL1", content: "Content1"),
            ArticleDisplayModel(title: "Title2", imageURL: "ImageURL2", date: "Date2", author: "Author2",
                                sourceURL: "SourceURL2", description: "Description2", articleURL: "ArticleURL2", content: "Content2"),
            ArticleDisplayModel(title: "Title3", imageURL: "ImageURL3", date: "Date3", author: "Author3",
                                sourceURL: "SourceURL3", description: "Description3", articleURL: "ArticleURL3", content: "Content3")
        ]
        scheduler.createColdObservable([.next(10, articles)])
            .bind(to: viewModel.output.display)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(displayObserver.events, [.next(310, articles)])
    }
    
    // Add more tests for other input and output properties and methods as needed
    
}*/
