//
//  APIResultWrapper.swift
//  MarvelAssignment
//
//  Created by omaestra on 26/11/22.
//

import Foundation

struct APIResultWrapper<T>: Decodable where T: Decodable {
    let code: Int
    let status: String
    let etag: String
    let data: APIDataWrapper<T>
}

struct APIDataWrapper<T>: Decodable where T: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    var results: T
}
