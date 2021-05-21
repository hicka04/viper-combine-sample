//
//  ArticleSearchViewController.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine

class ArticleSearchViewController: UIViewController {
    var presenter: ArticleSearchPresentation!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ArticleModel>(tableView: tableView) { tableView, indexPath, article -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = article.title
        return cell
    }
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.articlesSubject
            .sink { articles in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ArticleModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(articles, toSection: 0)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
        
        presenter.viewDidLoad()
    }
}
