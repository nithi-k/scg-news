//  ArticleDetailViewController.swift
//  ArticleDetail
//
//  Created by Nithi Kulasiriswatdi on 10/5/2564 BE.
//

import UIKit
import RxSwift
import RxCocoa
import Core
import CoreUI
import SnapKit

class ArticleDetailViewController: ContentStackViewController, ViewType {
    var disposeBag = DisposeBag()
    
    // Views - Components
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.medium(ofSize: 16)
        label.textColor = CUIStyler.color.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.book(ofSize: 12)
        label.textColor = CUIStyler.color.black
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.book(ofSize: 12)
        label.textColor = CUIStyler.color.black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.light(ofSize: 14)
        label.textColor = CUIStyler.color.white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CUIStyler.color.darkGray
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(CUIStyler.layout.standardSpace)
            make.top.equalTo(CUIStyler.layout.mediumSpace)
            make.right.equalTo(-CUIStyler.layout.standardSpace)
            make.bottom.equalTo(-CUIStyler.layout.mediumSpace)
        }
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.medium(ofSize: 14)
        label.textColor = CUIStyler.color.black
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var articleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = CUIStyler.color.lightGray
        view.roundCorners(radius: CUIStyler.layout.standardSpace, corners: [.topLeft, .topRight])
        view.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return view
    }()
    
    private(set) lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.image(named: "white_back_arrow"), for: .normal)
        button.backgroundColor = CUIStyler.color.black
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private var viewModel: ArticleDetailViewModel?
    typealias ViewModelType = ArticleDetailViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CUIStyler.layout.largeSpace)
            make.left.equalTo(CUIStyler.layout.standardSpace)
        }
        addContent(view: articleImageView, leftPadding: .zero, rightPadding: .zero)
        addContent(view: descriptionContainerView, leftPadding: .zero, rightPadding: .zero, topPadding: .zero)
        addContent(view: titleLabel)
        addContent(view: authorLabel, topPadding: CUIStyler.layout.mediumSpace)
        addContent(view: dateLabel, topPadding: CUIStyler.layout.mediumSpace)
        addContent(view: contentLabel)
        addContent(view: UIView()) // add spacer
        showBackButton()
    }
    
    func bindViewModel() {
        guard
            let output = viewModel?.output else {
            return
        }
        
        disposeBag.insert([
            dismissButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }),
            output.display.drive(onNext: { [weak self] in
                self?.setupDisplay($0)
            })
        ])
    }
    
    func configViewModel(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
    }
    
    /// SetupDisplay
    /// - Parameter display: ArticleDisplayModel
    private func setupDisplay(_ display: ArticleDisplayModel) {
        titleLabel.text = display.title
        titleLabel.setLineSpacing(lineSpacing: 1.5)
        
        dateLabel.text = display.displayDate
        authorLabel.text = display.author.isEmpty ? "" : "By " + display.author
        
        contentLabel.text = display.content
        contentLabel.setLineSpacing(lineSpacing: 1.75)
        
        descriptionLabel.text = display.description
        descriptionLabel.setLineSpacing(lineSpacing: 1.5)
       
        articleImageView.image = nil
        guard let imageURL = URL(string: display.imageURL) else {
            return
        }
        articleImageView.kf.setImage(with: .network(imageURL))
    }
}
