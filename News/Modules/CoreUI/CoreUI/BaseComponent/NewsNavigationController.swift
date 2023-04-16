//
//  NewsNavigationController.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 15/4/2566 BE.
//

import UIKit

public class NewsNavigationController: UINavigationController {
    public var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initUIComponents()
    }
    
    private func initUIComponents() {
        navigationBar.tintColor = .white
        navigationBar.barTintColor = CUIStyler.color.white
        navigationBar.titleTextAttributes = [
            .foregroundColor: CUIStyler.color.black,
            .font: CUIStyler.font.bold(ofSize: 18)
        ]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
