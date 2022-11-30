//
//  MarvelURL.swift
//  MarvelAssignment
//
//  Created by omaestra on 28/11/22.
//

import Foundation

struct MarvelURL: Decodable {
    enum MarvelURLType: String, Decodable {
        case detail, wiki, comiclink
    }
    
    let type: MarvelURLType
    let url: String
}
