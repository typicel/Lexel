//
//  LexelTests.swift
//  LexelTests
//
//  Created by Tyler McCormick on 6/23/24.
//

import Testing
import Foundation
@testable import Lexel

struct LexelTests {

    @Test func testContextCreate() async throws {
        let dataManager = DataManager(type: .testing)
        
        #expect(dataManager.stories.count == 0)
        #expect(dataManager != nil)
    }
    
    @Test func testAddStory() async throws {
        let dataManager = DataManager(type: .testing)
        dataManager.insertStory(title: "Lexel", text: "Here's some text yes yes yes", language: "English")
        #expect(dataManager.stories.count == 1)
    }
    
    @Test func testAddStoryWithEmptyText() async throws {
        let dataManager = DataManager(type: .testing)
        
        dataManager.insertStory(title: "Empty", text: "", language: "English")
        #expect(dataManager.stories[0].rawText!.isEmpty)
        #expect(dataManager.stories[0].tokens!.count == 0)
    }
    
    @Test func testAddStoryWithTokens() async throws {
        let dataManager = DataManager(type: .testing)
        
        dataManager.insertStory(title: "Test", text: "This should be 10 tokens.", language: "English")
        #expect(dataManager.stories[0].tokens!.count == 10)
    }
    
    @Test func testGetTokensbyID() async throws {
        let dm = DataManager(type: .testing)
        
        dm.insertStory(title: "Test", text: "This should be 10 tokens.", language: "English")
        let result = dm.fetchTokensForStory(with: dm.stories[0].id)
        
        switch result {
        case .success(let tokens):
            print(tokens)
            try #require(tokens.count == 10)
            #expect(tokens[0].value == "This")
            #expect(tokens[1].value == " ")
            #expect(tokens[2].value == "should")

        case .failure:
            #expect(1 == 0) // something went wrong, should never get here
        }
    }
    
    @Test func testGetTokensWithBadId() async throws {
        let dm = DataManager(type: .testing)
        let result = dm.fetchTokensForStory(with: UUID())
        
        switch result {
        case .success(let tokens):
            #expect(tokens.count == 0)
        case .failure:
            #expect(1 == 0)
        }
    }

    @Test func testInitThemeService() async throws {
        let theme = ThemeService()
        
        #expect(theme.selectedTheme.name == "clear")
        #expect(theme.selectedFont.name == "New York")
    }
  

}
