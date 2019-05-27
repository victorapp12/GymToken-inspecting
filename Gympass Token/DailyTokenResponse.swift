//
//  DailyTokenResponse.swift
//  Gympass Token
//
//  Created by Victor Palhares on 26/05/2019.
//  Copyright © 2019 Victor Palhares. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLError: Error {
    case badInnerHTML
}

struct DailyTokenResponse {
    let token: String
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
        let doc = try SwiftSoup.parse(htmlString)
        let tokenDiv = try doc.getElementsByClass("sc-bxivhb fpHaYD")
        self.token = try tokenDiv.text()
    }
    
}
