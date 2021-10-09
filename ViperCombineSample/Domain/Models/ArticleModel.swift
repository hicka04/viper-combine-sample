//
//  ArticleModel.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation

struct ArticleModel: Hashable, Identifiable {
    let id: ID
    let title: String
    let body: String
}

extension ArticleModel {
    struct ID: RawRepresentable, Hashable {
        let rawValue: String
    }
}
