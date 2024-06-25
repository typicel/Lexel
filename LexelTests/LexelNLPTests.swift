//
//  LexelNLPTests.swift
//  LexelTests
//
//  Created by Tyler McCormick on 6/24/24.
//

import Testing
@testable import Lexel

struct LexelNLPTests {

    @Test func testTranslate() async throws {
        let nlp = NLPService(lang: .german)
        let word = "deutsch"
        
        let result = await nlp.translate(word: word)
        
        #expect(result == "german")
    }
    
//    @Test func testLemmatizeSuccess() async throws {
//        let nlp = NLPService(lang: .german)
//        let token = "eine"
//        
//        let result = nlp.lemmatize(word: token)
//        
//        #expect(result == "ein")
//    }

}
