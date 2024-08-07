//
//  Story+Typed.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//

import Foundation

extension Story {
    var typedTokens: [Token] {
        return (tokens.array as? [Token] ?? [])
    }
}
