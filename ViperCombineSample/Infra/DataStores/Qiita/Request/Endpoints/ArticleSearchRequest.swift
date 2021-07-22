//
//  ArticleSearchRequest.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import APIKit

struct ArticleSearchRequest: PaginableQiitaRequest {
    typealias Item = ArticleEntity
    
    let method: HTTPMethod = .get
    let path = "items"
    var queryParameters: [String : Any]? {
        ["query": keyword]
    }
    
    let keyword: String
    var page: Int = 1
    let pageSize: Int
}
