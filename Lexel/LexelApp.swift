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
    let context = ConfigureModelContext()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContext(self.context)
        .environmentObject(ThemeService())
        .environmentObject(MLModelManager())
    }
}
