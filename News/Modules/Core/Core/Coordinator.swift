//
//  Coordinator.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
    func pushTo(viewController: UIViewController)
    func pop()
}

public extension Coordinator {
    func pushTo(viewController: UIViewController) {
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
}
