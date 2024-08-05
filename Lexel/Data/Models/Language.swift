//
//  Language.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//

import Foundation

struct Language: Hashable {
    let name: String
    let bcp47: String
    
    init(_ name: String, _ bcp47: String) {
        self.name = name
        self.bcp47 = bcp47
    }
}
