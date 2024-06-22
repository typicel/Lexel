//
//  ModelContainer.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/12/24.
//

import Foundation
import SwiftData
import OSLog

public func ConfigureModelContext() -> ModelContext {
    do {
        var inMemory = false
        
#if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            inMemory = true
        }
#endif
        
        let config = ModelConfiguration(for: VocabWord.self, Story.self, isStoredInMemoryOnly: inMemory)
        let container = try ModelContainer(for: VocabWord.self, Story.self, migrationPlan: LexelMigrationPlan.self, configurations: config)
        
        let context = ModelContext(container)
        context.autosaveEnabled = true
        
        return context
    } catch {
        os_log("\(error.localizedDescription)")
        fatalError("Failed to initialize model container")
    }
}
