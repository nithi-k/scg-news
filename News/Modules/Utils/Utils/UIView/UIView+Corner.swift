//
//  UIView+Corner.swift
//  Utils
//
//  Created by Nithi Kulasiriswatdi on 16/4/2566 BE.
//

import Foundation
public extension UIView {
    func dropShadow(
        scale: Bool = true,
        alpha: CGFloat = 0.25,
        opacity: Float = 1,
        offset: CGSize = .zero,
        radius: CGFloat = 2
    ) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(alpha).cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        var arr: CACornerMask = []
        let allCorners: [UIRectCorner] = [.topLeft, .topRight, .bottomLeft, .bottomRight, .allCorners]
        
        for corn in allCorners {
            if corners.contains(corn) {
                switch corn {
                case .topLeft:
                    arr.insert(.layerMinXMinYCorner)
                    
                case .topRight:
                    arr.insert(.layerMaxXMinYCorner)
                    
                case .bottomLeft:
                    arr.insert(.layerMinXMaxYCorner)
                    
                case .bottomRight:
                    arr.insert(.layerMaxXMaxYCorner)
                    
                case .allCorners:
                    arr.insert(.layerMinXMinYCorner)
                    arr.insert(.layerMaxXMinYCorner)
                    arr.insert(.layerMinXMaxYCorner)
                    arr.insert(.layerMaxXMaxYCorner)
                    
                default:
                    break
                }
            }
        }
        self.layer.maskedCorners = arr
    }
}
