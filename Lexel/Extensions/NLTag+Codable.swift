//
//  NLTag+Codable.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/21/24.
//

import NaturalLanguage

extension NLTag: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let tag = NLTag(rawValue: rawValue)
        
        self = tag
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
