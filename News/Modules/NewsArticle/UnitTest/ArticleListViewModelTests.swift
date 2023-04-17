//
//  ArticleListViewModelTests.swift
//  NewsArticle
//
//  Created by Nithi Kulasiriswatdi on 16/4/2566 BE.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import APILayer
import Core
@testable import NewsArticle

class ArticleListViewModelTests: XCTestCase {
    var viewModel: ArticleListViewModel?
    var disposeBag: DisposeBag?
    var scheduler: TestScheduler?
    
    var environment: APILayer.URLEnvironment? = {
        let environment = APILayer.URLEnvironment(
            url: "MOCK",
            cert: "MOCK",
            name: "MOCK",
            version: "MOCK",
            apiKey: "MOCK",
            debugMode: true)
        APIConstants.shared.configure(baseUrl: environment)
        return environment
    }()
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        viewModel = ArticleListViewModel(observationScheduler: scheduler ?? MainScheduler.instance)
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        environment = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testOnSearching() throws {
        guard
            let disposeBag = disposeBag,
            let scheduler = scheduler,
            let input = viewModel?.input,
            let output = viewModel?.output else {
            return
        }
        // Given
        let expectedResult = 1
        registerSuccessMockAPI()
        
        let page = scheduler.createObserver(Int.self)
        disposeBag.insert([
            // bind the result
            output.currentPage
                .bind(to: page),
            
            // When
            scheduler.createColdObservable(
                [
                    .next(5, ())
                ])
                .bind(to: input.reachedBottom),
            
            scheduler.createColdObservable(
                [
                    .next(10, "keyword")
                ])
                .bind(to: input.onSearching)
        ])
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(
            page.events, [
                .next(0, 0), // behavior value
                .next(1, 1), // update from default serach (wait for debounce)
                .next(5, 2), // update count from pagination
                .next(11, expectedResult) // clear page count when start searching
            ])
    }
    
    func testReachedBottom() {
        guard
            let disposeBag = disposeBag,
            let scheduler = scheduler,
            let input = viewModel?.input,
            let output = viewModel?.output else {
            return
        }
        // Given
        let page = scheduler.createObserver(Int.self)
        let expectedResult = 2
        registerSuccessMockAPI()

        disposeBag.insert([
            /// bind the result
            output.currentPage
                .bind(to: page),
            // When
            scheduler.createColdObservable([.next(10, ())])
                .bind(to: input.reachedBottom)
        ])
        scheduler.start()
        
        // Then
        XCTAssertEqual(
            page.events, [
                .next(0, 0), // behavior value
                .next(1, 1), // update from default serach (wait for debounce)
                .next(10, expectedResult) // reaach buttom and load next page
            ])
    }
    
    func testPressSearch() throws {
        guard
            let disposeBag = disposeBag,
            let scheduler = scheduler,
            let input = viewModel?.input,
            let output = viewModel?.output else {
            return
        }
        // Given
        let expectedResult = true
        registerSuccessMockAPI()
        
        let didSelecteArticle = scheduler.createObserver(Bool.self)
        
        disposeBag.insert([
            // bind the result
            output.didSelecteArticle
                .map { _ in return true }
                .bind(to: didSelecteArticle),
            
            // When
            scheduler.createColdObservable(
                [
                    .next(10, ())
                ])
                .bind(to: input.searchButtonClicked)
        ])
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(
            didSelecteArticle.events, [
                .next(10, expectedResult) // didSelecteArticle got trigged when searchButtonClicked
            ])
    }
    
    func testErrorResponse() throws {
        guard
            let disposeBag = disposeBag,
            let scheduler = scheduler,
            let output = viewModel?.output else {
            return
        }
        // Given
        let expectedResult = APIError(
            code: "Error Code",
            message: "Error message",
            httpError: nil
        )
        registerFailMockAPI()
        
        let receiveError = scheduler.createObserver(APIError.self)
        
        disposeBag.insert([
            // bind the result
            output.error.compactMap { $0 as? APIError }.bind(to: receiveError)
        ])
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(
            receiveError.events, [
                .next(2, expectedResult)
            ])
    }
    
    // TODO: Add more cases in the future
}

// MARK: Mock functions
extension ArticleListViewModelTests {
    private func registerSuccessMockAPI() {
        NewsArticleEndpoint.service.registerFake(withResponseFile: "success_mock.json" )
    }
    
    private func registerFailMockAPI() {
        NewsArticleEndpoint.service.registerFake(withResponseFile: "fail_invalid_input.json" )
    }
}
