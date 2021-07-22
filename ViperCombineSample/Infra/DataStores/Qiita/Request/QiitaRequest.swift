//
//  QiitaRequest.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import APIKit

protocol QiitaRequest: Request {}

extension QiitaRequest {
    var baseURL: URL {
        URL(string: "https://qiita.com/api/v2/")!
    }
}

protocol PaginableQiitaRequest: QiitaRequest where Response == PageResponse<Item> {
    associatedtype Item
    
    var page: Int { get set }
    var pageSize: Int { get }
}

extension PaginableQiitaRequest where Item: Decodable {
    var dataParser: DataParser {
        OriginalDataParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        guard (200 ..< 300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        
        guard let total = urlResponse.value(forHTTPHeaderField: "Total-Count"),
              let linkHeader = urlResponse.value(forHTTPHeaderField: "Link"),
              let regex = try? NSRegularExpression(pattern: "<(.+)>; rel=\"(.+)\"")
        else {
            throw ResponseError.nonHTTPURLResponse(urlResponse)
        }
        
        let pageInfo = linkHeader
            .components(separatedBy: ",")
            .reduce(into: [String: Int]()) { dictionary, linkHeaderComponents in
                guard let result = regex.firstMatch(in: linkHeaderComponents, range: NSRange(0 ..< linkHeaderComponents.count)) else {
                    return
                }
                let url = URL(string: (linkHeaderComponents as NSString).substring(with: result.range(at: 1)))!
                let page = URLComponents(url: url, resolvingAgainstBaseURL: true)?
                    .queryItems?
                    .first { $0.name == "page" }?
                    .value
                    .map { Int($0)! }
                let tag = (linkHeaderComponents as NSString).substring(with: result.range(at: 2))
                dictionary[tag] = page
            }
        let items = try JSONDecoder().decode([Item].self, from: data)
        return PageResponse(
            total: Int(total)!,
            firstPageIndex: pageInfo["first"]!,
            lastPageIndex: pageInfo["last"]!,
            nextPageIndex: pageInfo["next"],
            prevPageIndex: pageInfo["prev"],
            items: items
        )
    }
}
