//
//  ArticleCell.swift
//  NewsArticle
//
//  Created by Nithi Kulasiriswatdi on 13/4/2566 BE.
//

import UIKit
import CoreUI
import SnapKit
import Kingfisher
import Utils

class ArticleCell: UITableViewCell {
    // Views - Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.medium(ofSize: 14)
        label.textColor = CUIStyler.color.black
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = CUIStyler.font.book(ofSize: 12)
        label.textColor = CUIStyler.color.darkGray
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CUIStyler.layout.mediumSpace
        view.backgroundColor = CUIStyler.color.white
        view.layer.borderColor = CUIStyler.color.lightGray.cgColor
        view.layer.borderWidth = CUIStyler.layout.line
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var articleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = CUIStyler.color.lightGray
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupDisplay(_ display: ArticleDisplayModel) {
        titleLabel.text = display.title
        titleLabel.setLineSpacing(lineSpacing: 1.5)
        articleImageView.image = nil
        setupInfo(display)
        guard let imageURL = URL(string: display.imageURL) else {
            return
        }
        articleImageView.kf.setImage(with: .network(imageURL))
    }
}
// MARK: private
extension ArticleCell {
    private func setupInfo(_ display: ArticleDisplayModel) {
        var displayInfo = display.displayDate
        if !display.author.isEmpty {
            displayInfo += " | " + display.author
        }
        infoLabel.text = displayInfo
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(CUIStyler.layout.standardSpace)
            make.right.bottom.equalTo(-CUIStyler.layout.standardSpace)
        }
        
        [titleLabel, articleImageView, infoLabel].forEach {
            containerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(CUIStyler.layout.mediumSpace)
            make.right.equalTo(articleImageView.snp.left).offset(-CUIStyler.layout.standardSpace)
        }
        
        articleImageView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(90)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.bottom.equalTo(-CUIStyler.layout.mediumSpace)
        }
    }
}
