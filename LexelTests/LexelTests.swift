//
//  LexelTests.swift
//  LexelTests
//
//  Created by Tyler McCormick on 6/23/24.
//

import Testing
@testable import Lexel

struct LexelTests {

    @Test func testInitStory() async throws {
        let story = Story(title: "Der Hund", text: "Hallo", language: LexelLanguage("German", "de-DE"))
        
        #expect(story.title == "Der Hund")
        #expect(story.text == "Hallo")
    }
    
    @Test func testInitLexelLanguage() async throws {
        let lang = LexelLanguage("German", "de-DE")
        
        #expect(lang.displayName == "German")
        #expect(lang.bcp47 == "de-DE")
        #expect(lang.shortName == "DE")
        #expect(lang.mlLanguage == .german)
    }
    
    @Test func testInitVocabWord() async throws {
        let vw = VocabWord(word: "laufen", language: "de-DE", def: "to walk")
        
        #expect(vw.word == "laufen")
        #expect(vw.language == "de-DE")
        #expect(vw.definition == "to walk")
        #expect(vw.lexeme.isEmpty)
    }
    
    @Test func testInitLexelToken() async throws {
        let token = LexelToken(rawValue: "Hello,", tokenType: .word)
        
        #expect(token.rawValue == "Hello,")
        #expect(token.tokenType == .word)
        
        #expect(token.normalizedWord == "hello")
        #expect(token.lemma == "hello")
    }
    
    @Test func testInitThemeService() async throws {
        let theme = ThemeService()
        
        #expect(theme.selectedTheme.name == "clear")
        #expect(theme.selectedFont.name == "New York")
    }
  

}
