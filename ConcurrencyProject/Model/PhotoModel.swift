//
//  PhotoModel.swift
//  ConcurrencyProject
//
//  Created by İlker Kaya on 27.01.2023.
//

import Foundation
import Alamofire

/*
 [
     {
         "albumId": 1,
         "id": 1,
         "title": "accusamus beatae ad facilis cum similique qui sunt",
         "url": "https://via.placeholder.com/600/92c952",
         "thumbnailUrl": "https://via.placeholder.com/150/92c952"
     }
 ]
 */



struct Photo: Codable {
    let albumID: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailURL = "thumbnailUrl"
    }
}


