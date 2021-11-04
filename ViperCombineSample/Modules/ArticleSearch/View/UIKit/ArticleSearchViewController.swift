//
//  ArticleSearchViewController.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine
import CombineCocoa

class ArticleSearchViewController: UICollectionViewController {
    private let presenter: ArticleSearchPresenter
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, ArticleModel>(collectionView: collectionView) { collectionView, indexPath, article -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ArticleCell
        cell.set(article: article)
        return cell
    }
    
    init(presenter: ArticleSearchPresenter) {
        self.presenter = presenter
        super.init(
            collectionViewLayout: UICollectionViewCompositionalLayout { section, environment in
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(44)
                    )
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(44)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                return section
            }
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Articles"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
        collectionView.refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.controlEventPublisher(for: .valueChanged)
                .map { _ in .refreshControlValueChanged }
                .subscribe(presenter.viewEventSubject)
                .store(in: &cancellables)
            return refreshControl
        }()
        clearsSelectionOnViewWillAppear = true
        
        presenter.$articles
            .sink { [weak self] articles in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ArticleModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(articles, toSection: 0)
                self?.dataSource.apply(snapshot, animatingDifferences: true) {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            }.store(in: &cancellables)
        
        presenter.$articleSearchError
            .compactMap { $0 }
            .sink { [weak self] error in
                let alert = UIAlertController(
                    title: error.errorDescription,
                    message: error.recoverySuggestion,
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true) {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            }.store(in: &cancellables)
        
        presenter.viewEventSubject.send(.viewDidLoad)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.viewEventSubject.send(.didSelect(article: presenter.articles[indexPath.row]))
    }
}
