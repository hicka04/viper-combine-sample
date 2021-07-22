//
//  PageResponse.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/07/22.
//

import Foundation

struct PageResponse<Item> {
    let total: Int
    let firstPageIndex: Int
    let lastPageIndex: Int
    let nextPageIndex: Int?
    let prevPageIndex: Int?
    let items: [Item]
}
