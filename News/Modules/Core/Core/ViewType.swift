//
//  ControllerType.swift
//  Core
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ViewType {
    var disposeBag: DisposeBag { get }
    associatedtype ViewModelType
    func configViewModel(viewModel: ViewModelType)
    func setupAll()
    func setupViews()
    func bindViewModel()
    func showLoading()
    func hideLoading()
    func showError(error: Error)
}

public extension ViewType {
    func setupAll() {
        setupViews()
        bindViewModel()
    }
    
    func showLoading() {
    }
    
    func hideLoading() {
    }
    
    func showError(error: Error) {
        let description: String
        let title: String
        if let error = error as? APIError {
            title = error.code
            description = error.message
        } else {
            title = "Unknown Error"
            description = error.localizedDescription
        }
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .actionSheet
        )
        let closeAction = UIAlertAction(title: "Close", style: .destructive)
        closeAction.isEnabled = true
        alertController.addAction(closeAction)
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true)
    }
}
