//
//  Image.swift
//  MarvelAssignment
//
//  Created by omaestra on 27/11/22.
//

import Foundation

struct Image: Decodable {
    let path: String
    let pathExtension: String
    
    var url: String {
        return "\(path).\(pathExtension)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case path
        case pathExtension = "extension"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        pathExtension = try container.decode(String.self, forKey: .pathExtension)
    }
}
