//
//  LexelToken.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/21/24.
//

import NaturalLanguage

@propertyWrapper
struct Lazy<Value> {
    private var _value: Value?
    private let initializer: () -> Value

    init(initializer: @escaping () -> Value) {
        self.initializer = initializer
    }

    var wrappedValue: Value {
        mutating get {
            if _value == nil {
                _value = initializer()
            }
            return _value!
        }
    }
}

struct LexelToken: Encodable, Decodable {
    var rawValue: String
    var tokenType: NLTag
    var normalizedWord: String
    var lemma: String
    
    init(rawValue: String, tokenType: NLTag) {
        self.rawValue = rawValue
        self.tokenType = tokenType
        let n = rawValue.stripPunctuation().lowercased()
        self.lemma = NLPService(lang: .english).lemmatize(word: n)
        self.normalizedWord = n
    }
    
}
