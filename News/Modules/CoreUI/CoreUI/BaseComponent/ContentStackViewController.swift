//
//  ContentStackViewController.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 15/4/2566 BE.
//

import UIKit
import SnapKit

open class ContentStackViewController: UIViewController {
    // Views - Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = .zero
        return stackview
    }()
    
    private func initComponents() {
        view.addSubview(scrollView)
        view.backgroundColor = CUIStyler.color.white
        
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.bottom.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.height)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
    }
    
    public func addContent(
        view: UIView,
        leftPadding: CGFloat = CUIStyler.layout.standardSpace,
        rightPadding: CGFloat = CUIStyler.layout.standardSpace,
        topPadding: CGFloat = CUIStyler.layout.standardSpace
    ) {
        let containerView = UIView()
        containerView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(topPadding)
            make.bottom.equalToSuperview()
            make.left.equalTo(leftPadding)
            make.right.equalTo(-rightPadding)
        }
        contentStackView.addArrangedSubview(containerView)
    }
}
