//
//  String+Strip.swift
//  Lexel
//
//  Created by enzo on 6/18/24.
//

import Foundation

extension String {
    func stripPunctuation() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
