//
//  Comic.swift
//  MarvelAssignment
//
//  Created by omaestra on 28/11/22.
//

import Foundation

struct Comic: Decodable {
    
    struct ComicPrice: Decodable {
        enum ComicPriceType: String, Decodable {
            case printPrice, digitalPurchasePrice
        }
        
        let type: ComicPriceType
        let price: Double
    }
    
    let id: Int?
    let title: String?
    let description: String?
    let pageCount: Int?
    let issueNumber: Int?
    let modified: String?
    let format: String?
    let thumbnail: Image?
    let images: [Image]?
    let prices: [ComicPrice]?
}
