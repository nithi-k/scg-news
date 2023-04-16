//  Created by Nithi Kulasiriswatdi on 24/11/2563 BE.

import Foundation
import RxCocoa
import RxSwift

public class ActivityIndicator: SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    public init() {
        _loading = _behavior.asDriver()
            .distinctUntilChanged()
    }
    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    func trackActivityOfSingle<O: PrimitiveSequenceType>(_ source: O) -> Single<O.Element> where O.Trait == SingleTrait {
        return source
            .do(onSuccess: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    private func subscribed() {
        _lock.lock()
        _behavior.accept(true)
        _lock.unlock()
    }
    private func sendStopLoading() {
        _lock.lock()
        _behavior.accept(false)
        _lock.unlock()
    }
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Single<Element> {
        return activityIndicator.trackActivityOfSingle(self)
    }
}
