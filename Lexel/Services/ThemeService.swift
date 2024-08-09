//
//  ThemeService.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import SwiftUI

protocol ReaderTheme {
    var name: String { get }
    var readerColor: Color { get }
    var readerSidebarColor: Color { get }
    var readerColorBG: Color { get }
    var textColor: Color? { get }
}

protocol ReaderFont {
    var name: String { get }
    var readerFont: Font { get }
    func readerFontWithSize(_ size: CGFloat) -> Font
}


@Observable class ThemeService {
    
    static let shared = ThemeService()
    
    var selectedTheme: ReaderTheme
    var selectedFont: ReaderFont
    var fontSize: CGFloat
    
    init() {
        if let theme = UserDefaults.standard.value(forKey: "readerTheme") as? String {
            switch theme {
            case "clear":
                selectedTheme = Clear()
            case "sepia":
                selectedTheme = Sepia()
            case "blue":
                selectedTheme = Blue()
            case "gray":
                selectedTheme = Gray()
            case _ :
                selectedTheme = Clear()
            }
        } else {
            selectedTheme = Clear()
        }
        
        if let font = UserDefaults.standard.value(forKey: "readerFont") as? String {
            switch font {
            case "San Francisco":
                selectedFont = SanFrancisco()
            case "New York":
                selectedFont = NewYork()
            case "AtkinsonHyperlegible-Reader":
                selectedFont = Atkinson()
            case _:
                selectedFont = NewYork()
            }
        } else {
            selectedFont = Atkinson()
        }
        
        if let fontSize = UserDefaults.standard.value(forKey: "fontSize") as? CGFloat {
            self.fontSize = fontSize
        } else {
            self.fontSize = 28.0
        }
    }
    
    func setTheme(_ theme: ReaderTheme) {
        selectedTheme = theme
        UserDefaults.standard.setValue(theme.name, forKey: "readerTheme")
    }
    
    func setFont(_ font: ReaderFont) {
        selectedFont = font
        UserDefaults.standard.setValue(font.name, forKey: "readerFont")
    }
    
    func setFontSize(_ size: CGFloat) {
        self.fontSize = size
        UserDefaults.standard.setValue(size, forKey: "fontSize")
    }
}

// MARK: - Reader Color Themes

struct Clear: ReaderTheme {
    var readerSidebarColor: Color { return .clear }
    
    var name: String { return "clear" }
    var readerColor: Color { return .clear }
    var readerColorBG: Color { return .clear }
    var textColor: Color? { return nil }
}

struct Sepia: ReaderTheme {
    var readerSidebarColor: Color { return .readerBeigeSidebar }
    
    var name: String { return "sepia" }
    var readerColor: Color { return .readerBeige }
    var readerColorBG: Color { return .readerBeigeBG }
    var textColor: Color? { return .readerBeigeText }
}

struct Blue: ReaderTheme {
    var readerSidebarColor: Color { return .readerBlueSidebar }
    
    var name: String { return "blue" }
    var readerColor: Color { return .readerBlue }
    var readerColorBG: Color { return .readerBlue }
    var textColor: Color? { return .black }
}

struct Gray: ReaderTheme {
    var readerSidebarColor: Color { return .readerGraySidebar }
    
    var name: String { return "gray" }
    var readerColor: Color { return .readerGray }
    var readerColorBG: Color { return .readerBlue }
    var textColor: Color? { return .readerGrayText }
}

// MARK: - Reader Fonts

struct SanFrancisco: ReaderFont, Equatable, Hashable {
    var name: String { return "San Francisco" }
    var readerFont: Font { return .system(.title, design: .default)}
    
    func readerFontWithSize(_ size: CGFloat) -> Font {
        return .system(size: size, design: .default)
    }
}

struct NewYork: ReaderFont, Equatable, Hashable {
    var name: String { return "New York" }
    var readerFont: Font { return .system(.title, design: .serif) }
    
    func readerFontWithSize(_ size: CGFloat) -> Font {
        return .system(size: size, design: .serif)
    }
}

struct Lora: ReaderFont {
    @Environment(\.sizeCategory) var sizeCategory
    
    var name: String { return "Lora" }
    var displayName: String { return "Lora" }
    var readerFont: Font {
        return .custom("Lora", size: UIFontMetrics.default.scaledValue(for: ThemeService.shared.fontSize))
    }
    
    func readerFontWithSize(_ size: CGFloat) -> Font {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return .custom("Lora", size: scaledSize)
    }
}

struct Atkinson: ReaderFont {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String { return "AtkinsonHyperlegible-Regular" }
    var displayName: String { return "Atkinson" }
    var readerFont: Font {
        return .custom("AtkinsonHyperlegible-Regular", size: UIFontMetrics.default.scaledValue(for: ThemeService.shared.fontSize))
    }
    
    func readerFontWithSize(_ size: CGFloat) -> Font {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return .custom("AtkinsonHyperlegible-Regular", size: scaledSize)
    }
}
