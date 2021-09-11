//
//  ArticleCell.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/09/11.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    
    func set(article: ArticleModel) {
        label.text = article.title
    }
}
