//
//  ThemeManager.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import SwiftUI

protocol ReaderTheme {
    var readerColor: Color { get }
    var textColor: Color? { get }
}

class ThemeService: ObservableObject {
    @Published var selectedTheme: ReaderTheme = Clear()
    
    func setTheme(_ theme: ReaderTheme) {
        selectedTheme = theme
    }
}

struct Clear: ReaderTheme {
    var readerColor: Color { return .clear }
    var textColor: Color? { return nil }
}

struct Sepia: ReaderTheme {
    var readerColor: Color { return .readerBeige }
    var textColor: Color? { return .black }
}

struct Blue: ReaderTheme {
    var readerColor: Color { return .readerBlue }
    var textColor: Color? { return .black }
}

struct Gray: ReaderTheme {
    var readerColor: Color { return .readerGray }
    var textColor: Color? { return .black }
}
