//
//  PersistentStore.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//

import Foundation
import CoreData

struct PersistentStore {
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LexelData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                NSLog("Unresolved error: \(error.localizedDescription)")
            }
        }
    }
}
