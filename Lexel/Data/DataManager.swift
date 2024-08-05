//
//  DataManager.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//

import Foundation
import CoreData
import NaturalLanguage

enum DataManagerType {
    case normal
    case preview
    case testing
}

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)

    fileprivate var managedObjectContext: NSManagedObjectContext
    
    private let storyFRC: NSFetchedResultsController<Story>
    private let deFRC: NSFetchedResultsController<DictionaryEntry>

    @Published var stories: [Story] = []
    @Published var dictionaryEntries: [DictionaryEntry] = []
    
    init(type: DataManagerType) {
        
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
            
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context

        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let storyFR = Story.fetchRequest()
        storyFR.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        storyFRC = NSFetchedResultsController(fetchRequest: storyFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let deFR = DictionaryEntry.fetchRequest()
        deFR.sortDescriptors = [NSSortDescriptor(key: "word", ascending: false)]
        deFRC = NSFetchedResultsController(fetchRequest: deFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        storyFRC.delegate = self
        try? storyFRC.performFetch()
        if let newStories = storyFRC.fetchedObjects {
            self.stories = newStories
        }
        
        deFRC.delegate = self
        try? deFRC.performFetch()
        if let newWords = deFRC.fetchedObjects {
            self.dictionaryEntries = newWords
        }

    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let newStories = controller.fetchedObjects as? [Story] {
            self.stories = newStories
        } else if let newWords = controller.fetchedObjects as? [DictionaryEntry] {
            self.dictionaryEntries = newWords
        }
    }
}

// MARK: - Story Related Queries

extension DataManager {
    func insertStory(title: String, text: String, language: String) {
        let story = Story(context: managedObjectContext)
        story.id = UUID()
        story.title = title
        story.rawText = text
        story.language = language
        
        if text.isEmpty {
            story.tokens = []
            return
        }
        
        let tokenizer = NLTagger(tagSchemes: [.tokenType])
        tokenizer.string = text
        
        var tokens: [Token] = []
        var position: Int64 = 0
        tokenizer.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .tokenType) { tag, tokenRange in
            
            let token = Token(context: managedObjectContext)
            token.id = UUID()
            token.value = String(text[tokenRange])
            token.story = story
            token.position = position
            position += 1
            
            tokens.append(token)
            return true
        }
        
        story.tokens = NSSet(array: tokens)
    }
    
    func fetchTokensForStory(with id : UUID?) -> Result<[Token], DataManagerError> {
        guard let id = id else { return .failure(.uuidWasNil("The UUID provided for lookup was nil")) }
        
        let tokensFR = NSFetchRequest<Token>(entityName: "Token")
        tokensFR.predicate = NSPredicate(format: "story.id == %@", id as CVarArg)
        tokensFR.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        let tokenFRC = NSFetchedResultsController(fetchRequest: tokensFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try tokenFRC.performFetch()
        } catch {
            print("That's fucked: \(error.localizedDescription)")
        }
        
        if let tokens = tokenFRC.fetchedObjects {
            return .success(tokens)
        }
        
        return .failure(.badUUID("Could not find story with the given id"))
    }
}

enum DataManagerError: Error {
    case badUUID(String)
    case uuidWasNil(String)
}
