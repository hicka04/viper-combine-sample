//
//  ArticleSearchViewController.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine

class ArticleSearchViewController<Presenter: ArticleSearchPresentation>: UIViewController {
    var presenter: Presenter!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.dataSource = dataSource
        }
    }
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ArticleModel>(tableView: tableView) { tableView, indexPath, article -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = article.title
        return cell
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        super.init(nibName: Self.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.articlesPublisher
            .sink { [weak self] articles in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ArticleModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(articles, toSection: 0)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
        
        presenter.viewEventSubject.send(.viewDidLoad)
    }
}
