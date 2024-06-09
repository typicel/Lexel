//
//  LexelApp.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData

typealias VocabWord = LexelSchemaV1.VocabWord
typealias Story = LexelSchemaV1.Story

@main
struct LexelApp: App {
    let container: ModelContainer
    
    init() {
        do {
            self.container = try ModelContainer(
                for: VocabWord.self, Story.self,
                migrationPlan: LexelMigrationPlan.self
            )
        } catch {
            fatalError("Failed to initialize model container")
        }

    }
    
    var body: some Scene {
        WindowGroup {
            LibraryView()
        }
        .modelContainer(self.container)
    }
}
