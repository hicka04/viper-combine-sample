//
//  ArticleSearchViewController.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine

class ArticleSearchViewController: UITableViewController {
    var presenter: ArticleSearchPresenter!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ArticleModel>(tableView: tableView) { tableView, indexPath, article -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = article.title
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = dataSource
        clearsSelectionOnViewWillAppear = true
        
        presenter.$articles
            .sink { [weak self] articles in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ArticleModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(articles, toSection: 0)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
        
        presenter.$articleSearchError
            .compactMap { $0 }
            .sink { [weak self] error in
                let alert = UIAlertController(title: "記事の取得に失敗しました", message: "時間をおいて再度お試しください", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }.store(in: &cancellables)
        
        presenter.viewEventSubject.send(.viewDidLoad)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.viewEventSubject.send(.didSelect(article: presenter.articles[indexPath.row]))
    }
}
