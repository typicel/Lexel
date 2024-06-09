//
//  Story.swift
//  Lexel
//
//  Created by enzo on 5/28/24
//

import Foundation
import MLKit
import NaturalLanguage
import SwiftData

enum LexelSchemaV1: VersionedSchema {
    
    static var models: [any PersistentModel.Type] {
        [Story.self, VocabWord.self]
    }
    
    static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)
    
    @Model
    class Story: Identifiable {
        let id: String
        let title: String
        let tokens: [[String]]
        let language: String
        var notes: String
        var lastOpened: Date?
        
        var mlLanguage: TranslateLanguage {
            switch language {
            case "de-DE":
                return .german
            case "en-US":
                return .english
            case "ja-JP":
                return .japanese
            case "zh-CN":
                return .chinese
            case "ko-KR":
                return .korean
            case _:
                return .english
            }
        }
        
        init(title: String, text: String, language: String) {
            self.id = UUID().uuidString
            self.title = title
            self.language = language
            self.notes = ""
            self.lastOpened = nil
            
            var tokens: [[String]] = []
            let paragraphs = text.tokenize(unit: kCFStringTokenizerUnitParagraph)
            for p in paragraphs {
                let tokenizedWords = p.tokenize(unit: kCFStringTokenizerUnitWordBoundary)
                tokens.append(combinePunctuation(tokenizedWords))
            }
            
            tokens = processNewlines(in: tokens)
            self.tokens = tokens
            print(tokens)
            
        }
    }
    
    
    @Model
    class VocabWord {
        @Attribute(.unique) let word: String
        let language: String
        var familiarity: Familiarity
        var definition: String
        var timesTapped: Int
        
        init(word: String, language: String, def: String) {
            self.word = word
            self.language = language
            self.definition = def
            self.timesTapped = 0
            self.familiarity = .new
        }
        
        func setFamiliarity(to newFam: Familiarity) {
            self.familiarity = newFam
        }
        
        func setDefinition(to newDef: String) {
            self.definition = newDef
        }
    }
    
}

private func processNewlines(in array: [[String]]) -> [[String]] {
    var result: [[String]] = []
    
    for sublist in array {
        if sublist.count == 1 && sublist[0] == "\n" {
            // If the sublist is a single newline character and there's a previous sublist in the result
            if var lastSublist = result.popLast() {
                lastSublist.append("\n")
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
              language: "de-DE"),
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
              language: "ko-KR"),
        Story(title: "Susanne schreibt einen Brief (A1)",
              text: """
              Lieber Thomas!
              
              Jetzt bist du weit weg! Ich bin sehr unglücklich! Wie geht es dir in Hamburg? Hast du nette Kollegen in der Bank? Ist der Chef nett? Hast du schon eine Wohnung? Ist die Wohnung teuer? Ich arbeite schon zwei Wochen im Goethe-Gymnasium in München. Die Kollegen und Kolleginnen sind sehr freundlich. Die Schülerinnen und Schüler sind auch sehr nett. München ist schön! Das Wetter ist gut. Aber meine Katze \"Mimi\" ist krank! Das ist schrecklich. Heute Abend gehe ich ins Theater.
              
              Herzliche Grüße Deine Susanne Viele Grüße von Mimi!
              """,
              language: "de-DE"),
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
              language: "ja-JP"),
        Story(title: "汉字的魅力",
              text: """
                中国方块字以其独特的风貌与功能延续了几千年，让今人可以清晰地看懂古代时期的文字所表达的内容。如果心细，今人还能感受到古人的喜怒哀乐；汉字记录下来的历史真真切切，让我们对有文字以来的中华文明感慨，继而感激。
                  我们的感激来自殷商以来的甲骨文、金文的发明，来自稍加训练就可以看懂的大篆、小篆；两千年前的汉隶与今之文字已无大异，这是世界上任何一个民族都没有的便利，当然就是一种幸福。五千年汉字的一脉相承，让我们面对它时沾沾自喜，尽管我们不知古人的读音如何，但古人的所思所想我们会了然于心。与古人沟通，在中国人看来并非难事，无论是《诗经》的“关关睢鸠，在河之洲；窈窕淑女，君子好逑”，还是《论语》的“仁者乐山，智者乐水”，今天无论谁读来都会会心一笑。
                  其实，我们与古人相隔不远，因为有汉字。汉字一字一义乃至多义，为我们提供了信息传达的丰富与方便。人类文明的每一次进步，都是信息传递的结果。世界范围内影响人类文明进程的一百个人中就有东汉的蔡伦，纸张的发明不只是书写的便利，更在于信息的浓缩。这种浓缩依赖汉字的精辟。汉字，尤其古汉语，能将复杂的事物表达得极为简洁：“为山九仞，功亏一篑”(《尚书》)；也能表述得极富哲理：“有无相生，难易相成”(《老子》)；还能表述得极为优美：“投我以桃，报之以李”(《诗经》)；更能表述得极为通达：“见善则迁，有过则改”（《周易》）。汉字的优势，我们过去认知不深，曾有一段时间迷惘，
                """,
              language: "zh-CN"),
    ]
}
