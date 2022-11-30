//
//  String+.swift
//  MarvelAssignment
//
//  Created by omaestra on 29/11/22.
//

import Foundation


// MARK: - Date extensions

extension String {
    func toISO8601Date() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        
        return dateFormatter.date(from: self)
    }

    func toAbbreviatedDateFormat() -> String {
        guard let date = self.toISO8601Date() else { return "N/A" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
