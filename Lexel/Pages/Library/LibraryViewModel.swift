//
//  LibraryViewModel.swift
//  Lexel
//
//  Created by Tyler McCormick on 7/28/24.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var selectedStory: Story? = nil
    @Published var isShowingAddStorySheet: Bool = false
    @Published var isShowingEditStorySheet: Bool = false
    @Published var editingStory: Story? = nil
    @Published var showModelSheet: Bool = false
    
    @Published private var dataManager: DataManager
    
    var stories: [Story] {
        dataManager.stories
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init(dataManager: DataManager = .preview) {
        self.dataManager = dataManager
        
//        dataManager
//            .objectWillChange
//            .sink(receiveValue: { [weak self] (_) in self?.objectWillChange.send() })
//            .store(in: &cancellables)
        
//        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
//            self?.objectWillChange.send()
//        }
    }
    
    
    func showSheet() { isShowingAddStorySheet = true }
//    private func deleteItem(_ item: Story) { context.delete(item) }
    func editItem(_ item: Story) { self.editingStory = item }
    func reset() { self.editingStory = nil }
}

