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
    
    var body: some Scene {
        WindowGroup {
            LibraryView()
        }
        .modelContainer(for: [Story.self, VocabWord.self])
    }
}
