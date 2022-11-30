//
//  Character.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    var description: String? = nil
    var thumbnail: Image? = nil
    let modified: String?
    var urls: [MarvelURL]?
    var comics: ItemList<ComicSummary>?
    var events: ItemList<EventSummary>?
    var series: ItemList<SerieSummary>?
    var stories: ItemList<StorySummary>?
}
