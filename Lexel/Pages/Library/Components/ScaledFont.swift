//
//  ScaledFont.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/6/24.
//

import SwiftUI

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: Double
    
    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        switch name {
        case "New York":
            return content.font(.system(size: scaledSize, design: .serif))
        case "San Francisco":
            return content.font(.system(size: scaledSize, design: .default))
        default:
            return content.font(.custom(name, size: scaledSize))
        }
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func scaledFont(name: String, size: Double) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}
