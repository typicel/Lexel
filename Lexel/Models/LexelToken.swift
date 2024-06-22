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
    
    /// The raw token as it appears in the story. May include
    var rawValue: String
    
    /// What type of token this is (word, punctuation, whitespace, newline)
    var tokenType: NLTag
    
    /// The word stripped of any punctuation and all lowercase
    var normalizedWord: String
    
    /// The lemma associated with normalizedWord, if any. If this word is the base lemma, lemma == normalizedWord
    var lemma: Lemma
    
    init(rawValue: String, tokenType: NLTag) {
        self.rawValue = rawValue
        self.tokenType = tokenType
        let n = rawValue.stripPunctuation().lowercased()
        self.lemma = NLPService(lang: .english).lemmatize(word: n)
        self.normalizedWord = n
    }
    
}

extension LexelToken {
    func toJSON() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func fromJSONArray(_ data: Data) -> [[LexelToken]]? {
        return try? JSONDecoder().decode([[LexelToken]].self, from: data)
    }
    
    static func toJSONArray(_ tokens: [[LexelToken]]) -> Data? {
        return try? JSONEncoder().encode(tokens)
    }
    
    func fromJSON(_ data: Data) -> LexelToken? {
        return try? JSONDecoder().decode(LexelToken.self, from: data)
    }
}
