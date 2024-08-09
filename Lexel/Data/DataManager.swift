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
    
    var insertMockData: Bool = false
    
    init(type: DataManagerType) {
        
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
            
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            
            // insert mock data
            insertMockData = true

        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let storyFR = Story.fetchRequest()
        storyFR.sortDescriptors = [NSSortDescriptor(key: "lastOpened", ascending: true)]
        storyFRC = NSFetchedResultsController(fetchRequest: storyFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let deFR = DictionaryEntry.fetchRequest()
        deFR.sortDescriptors = [NSSortDescriptor(key: "word", ascending: false)]
        deFRC = NSFetchedResultsController(fetchRequest: deFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        if insertMockData {
            insertStory(title: "Mein Bruder", text: "Hallo Leute dass ist ein Test jaja", language: "de-DE")
            insertStory(title: "Mein Bruder 2", text: "Sehr gut. Eine sequel", language: "de-DE")
            insertStory(title: "Mein Bruder 3", text: "Sehr gut. Eine sequel", language: "de-DE")
            insertStory(title: "Mein Bruder 4", text: "Sehr gut. Eine sequel", language: "de-DE")
        }
        
        storyFRC.delegate = self
        refreshStories()
        
        deFRC.delegate = self
        refreshDictEntries()
    }
    
    func save() {
        try? managedObjectContext.save()
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
        story.lastOpened = .now
        
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
            
            switch tag {
            case .word:
                token.tappable = true
            default:
                token.tappable = false
            }
            
            // search for dict entry
            if tag == .word {
                if let dict = self.fetchDictEntry(for: token.value.lowercased()) {
                    token.dictionaryEntry = dict
                }
            }
            
            tokens.append(token)
            return true
        }
        
        story.tokens = NSOrderedSet(array: tokens)
        save()
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
    
    func refreshStories() {
        try? storyFRC.performFetch()
        if let newStories = storyFRC.fetchedObjects {
            self.stories = newStories
        }
    }
}

extension DataManager {
    func fetchDictEntry(for word: String) -> DictionaryEntry? {
        let dictFR = NSFetchRequest<DictionaryEntry>(entityName: "DictionaryEntry")
        dictFR.predicate = NSPredicate(format: "word == %@", word)
        dictFR.sortDescriptors = [NSSortDescriptor(key: "word", ascending: false)]
        dictFR.fetchLimit = 1
        
        let dictFRC = NSFetchedResultsController(fetchRequest: dictFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        try? dictFRC.performFetch()
        
        
        if let dict = dictFRC.fetchedObjects?.first {
            return dict
        }
        
        return nil
    }
    
    func insertDictEntry(for token: Token, definition: String, language: String) {
        let dict = DictionaryEntry(context: managedObjectContext)
        dict.id = UUID()
        dict.word = token.value.lowercased()
        dict.definition = definition
        dict.familiarity = 1
        dict.language = language
        dict.parent = nil
        token.dictionaryEntry = dict
        
        save()
    }
    
    func deleteDictEntry(_ dict: DictionaryEntry) {
        // need to fetch all tokens with this dict as its dict entry
        let tokensFR = NSFetchRequest<Token>(entityName: "Token")
        tokensFR.predicate = NSPredicate(format: "dictionaryEntry.id == %@", dict.id as CVarArg)
        tokensFR.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        let tokenFRC = NSFetchedResultsController(fetchRequest: tokensFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try tokenFRC.performFetch()
        } catch {
            print("That's fucked: \(error.localizedDescription)")
        }
        
        if let tokens = tokenFRC.fetchedObjects {
            for token in tokens {
                token.dictionaryEntry = nil
            }
        }

        managedObjectContext.delete(dict)
        save()
        
        // refresh
        refreshDictEntries()
        refreshStories()
    }
    
    func refreshDictEntries() {
        try? deFRC.performFetch()
        dictionaryEntries = deFRC.fetchedObjects ?? dictionaryEntries
    }
    
}

enum DataManagerError: Error {
    case badUUID(String)
    case uuidWasNil(String)
}
