//
//  Constants.swift
//  MarvelAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

struct Constants {
    static let baseUrl = "http://gateway.marvel.com/v1/public/"
    static let marvelApiPrivateKeyPath = "MARVEL_API_PRIVATE_KEY"
    static let marvelApiPublicKeyPath = "MARVEL_API_PUBLIC_KEY"
    
    enum Parameters {
        static let characterId = "characterId"
        static let offset = "offset"
        static let count = "count"
        static let ts = "ts"
        static let hash = "hash"
        static let apiKey = "apikey"
    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}
