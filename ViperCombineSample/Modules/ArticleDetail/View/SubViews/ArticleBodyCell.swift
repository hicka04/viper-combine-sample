//
//  ArticleBodyCell.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/08/09.
//

import UIKit

class ArticleBodyCell: UICollectionViewCell {
    @IBOutlet private weak var bodyLabel: UILabel!
    
    func setBody(_ body: String) {
        bodyLabel.attributedText = try? NSAttributedString(markdown: body, baseURL: URL(string: "https://qiita.com"))
    }
}
