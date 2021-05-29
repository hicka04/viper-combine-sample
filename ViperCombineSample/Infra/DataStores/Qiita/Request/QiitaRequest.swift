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
