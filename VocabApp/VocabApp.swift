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
    
    let container: ModelContainer = {
        let schema = Schema([Story.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
