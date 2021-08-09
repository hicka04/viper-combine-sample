//
//  ArticleDetailViewController.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/07/18.
//

import UIKit

class ArticleDetailViewController: UICollectionViewController {
    var presenter: ArticleDetailPresenter!
    
    private let layout: UICollectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, envirinment in
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, String> = .init(collectionView: collectionView) { collectionView, indexPath, content in
        guard let section = Section(rawValue: indexPath.section) else {
            return nil
        }
        
        switch section {
        case .title:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleTitleCell", for: indexPath) as! ArticleTitleCell
            cell.setTitle(content)
            return cell
            
        case .body:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleBodyCell", for: indexPath) as! ArticleBodyCell
            cell.setBody(content)
            return cell
        }
    }
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(UINib(nibName: "ArticleTitleCell", bundle: nil), forCellWithReuseIdentifier: "ArticleTitleCell")
        collectionView.register(UINib(nibName: "ArticleBodyCell", bundle: nil), forCellWithReuseIdentifier: "ArticleBodyCell")
        
        collectionView.dataSource = dataSource
        
        let snapshot: NSDiffableDataSourceSnapshot<Section, String> = {
            var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems([presenter.article.title], toSection: .title)
            snapshot.appendItems([presenter.article.body], toSection: .body)
            return snapshot
        }()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ArticleDetailViewController {
    enum Section: Int, CaseIterable {
        case title
        case body
    }
}
