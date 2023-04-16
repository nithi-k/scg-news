//  ArticleListViewController.swift
//  ArticleList
//
//  Created by Nithi Kulasiriswatdi on 10/5/2564 BE.
//

import UIKit
import RxSwift
import RxCocoa
import Core
import CoreUI
import SnapKit

class ArticleListViewController: UIViewController, ViewType {
    var disposeBag = DisposeBag()
    
    // Views - Components
    private lazy var tableView: UITableView = {
        // Create and configure a UITableView instance
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.register(
            ArticleCell.self,
            forCellReuseIdentifier: String(describing: ArticleCell.self))
        tableView.tableFooterView = footerView
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(
            top: CUIStyler.layout.standardSpace,
            left: .zero,
            bottom: CUIStyler.layout.standardSpace,
            right: .zero
        )
        
        return tableView
    }()
    
    private lazy var footerView: ArticleLoadingView = {
        // Create and configure an ArticleLoadingView instance
        let view = ArticleLoadingView()
        view.frame.size.height = 60
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        // Create and configure a UISearchBar instance
        let searchBar = UISearchBar()
        searchBar.searchTextField.font = CUIStyler.font.book(ofSize: 16)
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = CUIStyler.color.black
        searchBar.placeholder = "Seach"
        return searchBar
    }()
    
    // Custom transition
    var selectedCell: ArticleCell?
    var selectedCellImageViewSnapshot: UIView?
    var animator: Animator?

    private var viewModel: ArticleListViewModel?
    typealias ViewModelType = ArticleListViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.resignFirstResponder()
    }
    
    func setupViews() {
        view.backgroundColor = CUIStyler.color.white
        [searchBar, tableView].forEach { view.addSubview($0) }
    
        // Setup constraints for searchBar and tableView
        searchBar.snp.makeConstraints { make in
            make.left.equalTo(CUIStyler.layout.standardSpace)
            make.right.equalTo(-CUIStyler.layout.standardSpace)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func bindViewModel() {
        guard
            let output = viewModel?.output,
            let input = viewModel?.input  else {
            print("Please config viewModel to the controller")
            return
        }

        disposeBag.insert([
            // MARK: Input
            // When search button is clicked, get the first article from the display array and bind it to selectedArticle input
            searchBar.rx.searchButtonClicked
                .withLatestFrom(output.display)
                .compactMap { $0.first }
                .bind(to: input.selectedArticle),
            
            // When text changes in the searchBar, bind it to onSearching input
            searchBar.rx.text.compactMap { return $0 ?? "" }
                .bind(to: input.onSearching),
            
            // When tableView reaches bottom, get the current page from output and increment it by 1, then bind it to pagination input
            tableView.rx.reachedBottom()
                .skip(2)
                .withLatestFrom(output.currentPage)
                .map { $0 + 1 }
                .bind(to: input.pagination),
            
            tableView.rx.itemSelected
                .subscribe(onNext: { [weak self] in
                    // When an item is selected in the table view:
                    // 1. Store the selected cell in `selectedCell` property
                    self?.selectedCell = self?.tableView.cellForRow(at: $0) as? ArticleCell
                    // 2. Take a snapshot of the article image view in the selected cell
                    let articleImageView = self?.selectedCell?.articleImageView
                    self?.selectedCellImageViewSnapshot = articleImageView?.snapshotView(afterScreenUpdates: false)
                }),
            
            tableView.rx.itemSelected
                .delay(.milliseconds(100), scheduler: MainScheduler.instance)
                .withLatestFrom(output.display) { ($0, $1) }
                .map { index, display in display[index.row] }
                .bind(to: input.selectedArticle),
         
            // MARK: Output
            output.display
                .drive(onNext: { [weak self] _ in
                    // When the display output updates:
                    // Reload the table view offset
                    self?.reloadTableViewOffset()
                }),
            
            output.display
                .drive(tableView.rx.items(
                    cellIdentifier: String(describing: ArticleCell.self),
                    cellType: ArticleCell.self)) { _, target, cell in cell.setupDisplay(target) },
            
            output.loading
                .subscribe(onNext: { [weak self] in
                    // When the loading output updates:
                    // Update the footer view's loading status
                    self?.footerView.isLoading = $0
                }),
            
            output.error
                .subscribe(onNext: { [weak self] in
                    self?.showError(error: $0)
                })
        ])
    }
    
    func configViewModel(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: private
extension ArticleListViewController {
    private func reloadTableViewOffset() {
        let contentOffset = self.tableView.contentOffset
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableView.setContentOffset(contentOffset, animated: false)
    }
}

// Cutom Transition
extension ArticleListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // When a view controller is being presented:
        // 1. Check if the presenting view controller is a UINavigationController
        // 2. Get the root view controller of the UINavigationController
        // 3. Get the presented view controller as ArticleDetailViewController
        // 4. Get the snapshot of the selected cell's image view
        // 5. Create an instance of the Animator class with relevant parameters
        guard
            let navigationController = presenting as? UINavigationController,
            let rootViewController = navigationController.viewControllers.first as? ArticleListViewController,
            let secondViewController = presented as? ArticleDetailViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(
            type: .present,
            rootViewController: rootViewController,
            destinationViewController: secondViewController,
            cellImageSnapShot: selectedCellImageViewSnapshot
        )
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // When a presented view controller is being dismissed:
        // 1. Get the dismissed view controller as ArticleDetailViewController
        // 2. Get the snapshot of the selected cell's image view
        // 3. Create an instance of the Animator class with relevant parameters
        guard let secondViewController = dismissed as? ArticleDetailViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(
            type: .dismiss,
            rootViewController: self,
            destinationViewController: secondViewController,
            cellImageSnapShot: selectedCellImageViewSnapshot)
        return animator
    }
}
