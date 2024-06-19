//
//  LexelApp.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData

@main
struct LexelApp: App {
    let context = ConfigureModelContainer()
    
    var body: some Scene {
        WindowGroup {
            LibraryView()
        }
        .modelContext(self.context)
        .environmentObject(ThemeService())
        .environmentObject(MLModelManager())
    }
}
