//
//  ArticleSearchRequest.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import APIKit

struct ArticleSearchRequest: QiitaRequest {
    typealias Response = [ArticleEntity]
    
    let method: HTTPMethod = .get
    let path = "items"
    var queryParameters: [String : Any]? {
        ["query": keyword]
    }
    
    let keyword: String
}
