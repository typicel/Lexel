//
//  StoryViewModel.swift
//  Lexel
//
//  Created by Tyler McCormick on 7/28/24.
//

import Foundation
import SwiftUI
import Combine

class StoryViewModel: ObservableObject {
    @Published var story: Story!
    @Published var tokens: [Token]!
    
    // State relating to the currently selected word and its translation
    @Published var selectedWord: Token? = nil
    @Published var selectedWordIndex: Int? = nil
    @Published var translatedWord: String? = nil
    
    // Popover state vars
    @Published var showSettingsPopover: Bool = false
    @Published var showFamiliarPopover: Bool = false
    
    @Published var dataManager: DataManager
    var cancellables =  Set<AnyCancellable>()
    
    init(story: Story, dataManager: DataManager = .shared) {
        self.story = story
        
        
        self.dataManager = dataManager
    }
    
    func updateStory(with story: Story) {
        self.story = story
        self.selectedWord = nil
        self.selectedWordIndex = nil
        self.translatedWord = nil
        self.showSettingsPopover = false
        self.showFamiliarPopover = false
    }
    
    func fetchTokens() {
        let result = dataManager.fetchTokensForStory(with: story.id)
        switch result {
        case .success(let tokens):
            self.tokens = tokens
        case .failure(let error):
            print(error.localizedDescription)
            self.tokens = []
        }
    }
    
    func backgroundColor(for token: Token) -> Color {
        // If word is selected, should be yellow highlight no matter what
        if let index = selectedWordIndex {
            if token.position == index {
                return Color.yellow
            }
        }
        
        // If there's a valid dict entry, should be highlighted with the right color
        if let dict = token.dictionaryEntry {
            return Constants.familiarityColors[Int(dict.familiarity)-1]
        }
        
        // If neither are true, just be clear
        return Color.clear
    }
    
    @MainActor
    func handleTapGesture(for token: Token) async {
        guard token.tappable else { return }
        
        self.translatedWord = await NLPService.shared.translate(word: token.value.lowercased(), from: story.language)
        self.selectedWord = token
        self.selectedWordIndex = Int(token.position)
        self.showSettingsPopover = true
        TTSService.shared.speak(text: token.value) // should be bcp47 format
    }
    
    /// Returns a binding that represents if the word at the given indicies is currently selected
    ///
    /// - Parameters
    ///     - wordIndex: Index of the word in each paragraph
    ///     - paragraphIndex: Index representing the paragraph the word is in
    /// - Returns: A binding representing if the word is selected
    func makeIsPresented(wordIndex: Int) -> Binding<Bool> {
        return .init(get: { [weak self] in
            return wordIndex == self?.selectedWordIndex
        }, set: { [weak self] _ in
            self?.selectedWordIndex = nil
            //            self?.selectedParagraphIndex = nil
        })
    }
}

