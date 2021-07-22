//
//  APIKit+extension.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import APIKit

extension Request where Response: Decodable {
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
        
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

struct OriginalDataParser: DataParser {
    var contentType: String? = "application/json"
    
    func parse(data: Data) throws -> Any {
        return data
    }
}
