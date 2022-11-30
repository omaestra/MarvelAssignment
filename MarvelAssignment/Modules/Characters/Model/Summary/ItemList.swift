//
//  ItemList.swift
//  MarvelAssignment
//
//  Created by omaestra on 29/11/22.
//

import Foundation

struct ItemList<T>: Decodable where T: Decodable {
    let available: Int
    let returned: Int
    let items: [T]
}

class ItemSummary: Decodable {
    let resourceURI: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resourceURI = try container.decode(String.self, forKey: .resourceURI)
        name = try container.decode(String.self, forKey: .name)
    }
}
