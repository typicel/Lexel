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
    //    @Published var selectedParagraphIndex: Int? = nil
    @Published var translatedWord: String? = nil
    
    // Popover state vars
    @Published var showSettingsPopover: Bool = false
    @Published var showFamiliarPopover: Bool = false
    
    @Published var dataManager: DataManager
    var anyCancellable: AnyCancellable?
    
    init(story: Story, dataManager: DataManager = .preview) {
        self.story = story
        self.dataManager = dataManager
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.dataManager.objectWillChange.send()
        }
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
    
    func word(for token: Token) -> String {
        if let text = story.rawText {
            let start = text.index(text.startIndex, offsetBy: Int(token.startIndex))
            let end = text.index(start, offsetBy: Int(token.length))
            return String(text[start..<end])
        } else {
            return ""
        }
    }
    
    func handleTapGesture(for token: Token) async {
        self.selectedWord = token
        self.selectedWordIndex = Int(token.position)
        
        self.translatedWord = await NLPService.shared.translate(word: token.value!.lowercased(), from: story.language!)
        
        TTSService.shared.speak(text: token.value!, lang: story.language!) // should be bcp47 format
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

