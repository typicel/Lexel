//
//  ModelContainer.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/12/24.
//

import Foundation
import SwiftData

public func ConfigureModelContainer() -> ModelContext {
    do {
        let container = try ModelContainer(for: VocabWord.self, Story.self, migrationPlan: LexelMigrationPlan.self)
        
        let context = ModelContext(container)
        context.autosaveEnabled = true
        
        return context
    } catch {
        print(error.localizedDescription)
        fatalError("Failed to initialize model container")
    }
}
