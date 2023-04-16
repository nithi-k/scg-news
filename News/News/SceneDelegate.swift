//
//  SceneDelegate.swift
//  News
//
//  Created by Nithi Kulasiriswatdi on 12/4/2566 BE.
//

import UIKit
import Networking
import APILayer
import RxSwift
import AppCoordinator
import CoreUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var rootCoordinator: RootCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        AppFont.registerFonts
        configEnvironment()
        //        NewsArticleEndpoint.service.registerFake(withResponseFile: "success_mock.json" )
        //        NewsArticleEndpoint.service.registerFake(withResponseFile: "fail_invalid_input.json" )
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.backgroundColor = .white
        window?.tintColor = .white
        window?.overrideUserInterfaceStyle = .light
        
        rootCoordinator = RootCoordinator(navigationController: NewsNavigationController())
        window?.rootViewController = rootCoordinator?.navigationController
        window?.makeKeyAndVisible()
        rootCoordinator?.start()
    }
}

// MARK: confignetwork
extension SceneDelegate {
    private func configEnvironment() {
        let environment = APILayer.URLEnvironment(
            url: "https://newsapi.org/v2",
            name: "news",
            version: "0.0.1",
            apiKey: "821f13277bf54e2d8adf1fc57db05a26", // paste your api here
            debugMode: true)
        APIConstants.shared.configure(baseUrl: environment)
    }
}
