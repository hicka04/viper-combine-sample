//
//  ArticleEntity.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation

struct ArticleEntity: Decodable {
    let id: String
    let title: String
    let body: String
    
    func translate() -> ArticleModel {
        ArticleModel(
            id: .init(rawValue: id),
            title: title,
            body: body
        )
    }
}
