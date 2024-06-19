//
//  Collection+Enumerated.swift
//  Lexel
//
//  Created by enzo on 6/18/24.
//

import Foundation

extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        return Array(self.enumerated())
    }
}
