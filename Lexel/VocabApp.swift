//
//  VocabAppApp.swift
//  VocabApp
//
//  Created by Tyler McCormick on 5/24/24.
//

import SwiftUI
import SwiftData

@main
struct VocabApp: App {
    
    var body: some Scene {
        WindowGroup {
            LibraryView()
        }
        .modelContainer(for: [Story.self, VocabWord.self])
    }
}
