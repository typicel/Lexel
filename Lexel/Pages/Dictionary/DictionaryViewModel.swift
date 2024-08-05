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
    
    init(dataManager: DataManager = .preview) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    
    var words: [DictionaryEntry] {
        dataManager.dictionaryEntries
    }
}
