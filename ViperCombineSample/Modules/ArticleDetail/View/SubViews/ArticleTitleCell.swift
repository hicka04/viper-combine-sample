//
//  ArticleTitleCell.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/08/09.
//

import UIKit

class ArticleTitleCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
