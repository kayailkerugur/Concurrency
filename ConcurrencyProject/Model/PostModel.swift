//
//  PostModel.swift
//  ConcurrencyProject
//
//  Created by İlker Kaya on 28.01.2023.
//

import Foundation

struct PostModel: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

