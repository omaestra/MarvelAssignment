//
//  StorySummary.swift
//  MarvelAssignment
//
//  Created by omaestra on 29/11/22.
//

import Foundation

class StorySummary: ItemSummary {
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        try super.init(from: decoder)
    }
}
