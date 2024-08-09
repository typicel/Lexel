//
//  DictionaryViewModel.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
    
    @Published var dataManager: DataManager
    var anyCancellable: AnyCancellable?
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func delete(_ word: DictionaryEntry) {
        dataManager.deleteDictEntry(word)
    }
    
    
    var words: [DictionaryEntry] {
        dataManager.dictionaryEntries
    }
}
