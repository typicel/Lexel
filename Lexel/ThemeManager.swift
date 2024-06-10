//
//  ThemeManager.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/9/24.
//

import Foundation
import SwiftUI

protocol ReaderTheme {
    var readerColor: Color { get }
    var textColor: Color? { get }
}

class ThemeManager: ObservableObject {
    @Published var selectedTheme: ReaderTheme = ClearReaderTheme()
    
    func setTheme(_ theme: ReaderTheme) {
        selectedTheme = theme
    }
}

struct ClearReaderTheme: ReaderTheme {
    var readerColor: Color { return .clear }
    var textColor: Color? { return nil }
}

struct SepiaReaderTheme: ReaderTheme {
    var readerColor: Color { return .readerBeige }
    var textColor: Color? { return .black }
}

struct BlueReaderTheme: ReaderTheme {
    var readerColor: Color { return .readerBlue }
    var textColor: Color? { return .black }
}

struct GrayReaderTheme: ReaderTheme {
    var readerColor: Color { return .readerGray }
    var textColor: Color? { return .black }
}
