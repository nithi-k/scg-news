//
//  UIViewController + Navigation.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 15/4/2566 BE.
//

import UIKit

public extension UIViewController {
    func showBackButton() {
        let backBtn = UIBarButtonItem(
            image: UIImage.image(named: "back-arrow"),
            style: .plain,
            target: self,
            action: #selector(onBackPressed)
        )
        navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc private func onBackPressed() {
        navigationController?.popViewController(animated: true)
    }
}
