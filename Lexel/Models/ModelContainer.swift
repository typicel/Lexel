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
        
#if DEBUG
        if CommandLine.arguments.contains("populate") {
            let story = Story(title: "Der Hund", text: "Hallo, dieses ist mein Hund. Genau.", language: LexelLanguage("German","de-DE"))
            let story2 = Story(title: "Der Hund 2", text: "Das ist ein big sequel", language: LexelLanguage("German","de-DE"))

            context.insert(story)
            context.insert(story2)
            try! context.save()
        }
#endif
        
        return context
    } catch {
        os_log("\(error.localizedDescription)")
        fatalError("Failed to initialize model container")
    }
}
