//
//  LexelSchema.swift
//  Lexel
//
//  Created by enzo on 5/28/24
//

import Foundation
import MLKit
import NaturalLanguage
import SwiftData
import OSLog

typealias VocabWord = LexelSchemaV1.VocabWord
typealias Story = LexelSchemaV1.Story

public enum LexelSchemaV1: VersionedSchema {
    
    public static var models: [any PersistentModel.Type] {
        [Story.self, VocabWord.self]
    }
    
    public static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    
    @Model
    class Story: Identifiable {
        var id: String
        var title: String
        var language: LexelLanguage
        var notes: String
        var lastOpened: Date?
        var text: String
//        
//        private var _tokens: [[LexelToken]]?
//       
//        var tokens: [[LexelToken]] {
//            if _tokens == nil {
//                var t: [[LexelToken]] = []
//                let paragraphs = text.nlTokenize(unit: .paragraph)
//                for p in paragraphs {
//                    let tokenizedWords = p.rawValue.nlTokenize(unit: .word)
//                    t.append(tokenizedWords)
//                }
//                _tokens = processNewlines(in: t)
//            }
//            
//            return _tokens!
//        }
        
//        @Lazy var tokens: [[LexelToken]]
        var tokens: [[LexelToken]]

        init(title: String, text: String, language: LexelLanguage) {
            self.id = UUID().uuidString
            self.title = title
            self.language = language
            self.notes = ""
            self.lastOpened = nil
            self.text = text
            
            var t: [[LexelToken]] = []
            let paragraphs = text.nlTokenize(unit: .paragraph)
            for p in paragraphs {
                let tokenizedWords = p.rawValue.nlTokenize(unit: .word)
                t.append(tokenizedWords)
            }
            self.tokens = processNewlines(in: t)
        }
    }
    
    @Model
    class VocabWord {
        @Attribute(.unique) let word: String
        let language: String
        var familiarity: Familiarity
        var definition: String
        var timesTapped: Int
        var lexeme: Set<String>
        
        init(word: String, language: String, def: String) {
            self.word = word
            self.language = language
            self.definition = def
            self.timesTapped = 0
            self.familiarity = .new
            self.lexeme = []
        }
        
        func appendChild(word: String) {
            lexeme.insert(word)
        }
        
        func setFamiliarity(to newFam: Familiarity) {
            self.familiarity = newFam
        }
        
        func setDefinition(to newDef: String) {
            self.definition = newDef
        }
    }
    
}

private func processNewlines(in array: [[LexelToken]]) -> [[LexelToken]] {
    var result: [[LexelToken]] = []
    
    for sublist in array {
        if sublist.count == 1 && sublist[0].rawValue == "\n" {
            // If the sublist is a single newline character and there's a previous sublist in the result
            if var lastSublist = result.popLast() {
                lastSublist.append(LexelToken(rawValue: "\n", tokenType: .otherWhitespace))
                result.append(lastSublist)
            }
        } else {
            result.append(sublist)
        }
    }
    
    return result
}

private func combinePunctuation(_ input: [String]) -> [String] {
    var result: [String] = []
    var previousWord: String? = nil
    
    for token in input {
        if token == " " {
            // Skip single spaces
            continue
        } else if (token.count == 1 && token[token.startIndex].isPunctuation) {
            // Combine punctuation with the previous word
            if let word = previousWord {
                result.append(word + token)
                previousWord = nil
            } else {
                result.append(token + input[0])
                previousWord = input[0]
            }
        } else {
            // If there's a previous word pending, add it to the result
            if let word = previousWord {
                result.append(word)
            }
            previousWord = token
        }
    }
    
    // Add the last word if it exists
    if let word = previousWord {
        result.append(word)
    }
    
    return result
}


extension Story {
    static let sampleData: [Story] =
    [
        Story(title: "Freundinnen",
              text: "Ricarda ist 21 Jahre alt und wohnt in Lübeck. Lübeck ist eine sehr schöne Stadt im Norden von Deutschland. Ricarda studiert Medizin an der Universität von Lübeck. Sie hat viele Freunde dort.",
              language: LexelLanguage("German", "de-DE")
              ),
              
        Story(title: "Test2",
              text: """
그러면 그냥 그냥 시작
자, 여기부터 한국말로! 저희들은 여기부터 한국말로 합니다
간단하게 이름 소개해주세요
안녕하세요 정하나입니다

정하나씨. 사실 여기는 저희 어머니 집입니다
마당인데... 여기 어머니 회사에서 일하고 계신 분
네 회사직원입니다. 사실은 오늘은, 오늘 주제는
강아지... 강아지 얘기를 하고싶어요

강아지 키우죠? 네 키우고 있습니다
언제부터 키웠어요? 9개월 정도 키웠습니다
강아지 키우니까 어때요? 뭐가 제일 좋아요? 집에 오면 반겨주는 게 너무 행복해요
""",
              language: LexelLanguage("Korean", "ko-KR")),
        Story(title: "Susanne schreibt einen Brief (A1)",
              text: """
              Lieber Thomas!
              
              Jetzt bist du weit weg! Ich bin sehr unglücklich! Wie geht es dir in Hamburg? Hast du nette Kollegen in der Bank? Ist der Chef nett? Hast du schon eine Wohnung? Ist die Wohnung teuer? Ich arbeite schon zwei Wochen im Goethe-Gymnasium in München. Die Kollegen und Kolleginnen sind sehr freundlich. Die Schülerinnen und Schüler sind auch sehr nett. München ist schön! Das Wetter ist gut. Aber meine Katze \"Mimi\" ist krank! Das ist schrecklich. Heute Abend gehe ich ins Theater.
              
              Herzliche Grüße Deine Susanne Viele Grüße von Mimi!
              """,
              language: LexelLanguage("German", "de-DE")),
        Story(title: "ウサギとカメ",
              text: """
              カメの足が遅いのを、ウサギがバカにして笑いました。
              
              「あなたは足が早くても、わたしの方が勝ちますよ」
              と、カメが言いました。
              
              　すると、ウサギは、
              「そんな事を言ったって、口先だけだ。では、競争しよう？　そうすれば、わかる」
              と、言い、
              「誰が場所を決めて、勝った者にほうびを出すのですか？」
              と、カメは言いました。
              「キツネが公平で利口だから、あれに頼もう」
              と、ウサギは言いました。
              
              　そこでキツネが、競争を始める合図をしました。
              
              　たちまち、足の早いウサギがカメを引き離しました。
              　しかし、カメはあきらめずに、休まず歩き続けました。
              
              　ウサギは足が早いと思って安心しているものですから、途中で大きな木を見つけると、その木かげでひと休みしました。
              
              　それからしばらくして、ウサギは起き上がりました。
              「あれ？　少し眠ってしまったか。・・・まあいい、どうせカメはまだ後ろにいるはず。あぁーあ」
              　ウサギは大きくのびをすると、そのままゴールに向かいました。
              
              「よーし、もうすぐゴールだ・・・と、・・・あれ？」
              　自分が勝ったと思っていたのに、何とカメが先にゴールしていたのです。
              
              　才能はあっても、いいかげんにやっていて駄目になる人はたくさんいます。
              　また、才能はなくても、真面目で辛抱強い人は、才能がある人に勝つ事もあるのです。
              
              おしまい
              """,
              language: LexelLanguage("Japanese", "ja-JP")),
    ]
}
