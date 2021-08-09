//
//  ArticleSearchViewController.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine
import CombineCocoa

class ArticleSearchViewController: UIViewController {
    var presenter: ArticleSearchPresenter!
    
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.delegate = self
            tableView.dataSource = dataSource
        }
    }
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ArticleModel>(tableView: tableView) { tableView, indexPath, article -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = article.title
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latestVisibleCellIndexPublisher = tableView.contentOffsetPublisher
            .compactMap { _ in self.tableView.indexPathsForVisibleRows?.max()?.row }
        let articlesCountPublisher = presenter.$articles.map { $0.count }
            
        Publishers.CombineLatest(latestVisibleCellIndexPublisher, articlesCountPublisher)
            .filter { (cellIndex: Int, articlesCount: Int) in
                articlesCount > 0 && cellIndex == articlesCount - 1
            }.removeDuplicates { previous, current in
                previous.1 == current.1
            }.print()
            .map { _ in .willReachLatestCell }
            .subscribe(presenter.viewEventSubject)
            .store(in: &cancellables)
        
        presenter.$articles
            .sink { [weak self] articles in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ArticleModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(articles, toSection: 0)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
        
        presenter.viewEventSubject.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension ArticleSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.viewEventSubject.send(.didSelect(article: presenter.articles[indexPath.row]))
    }
}
