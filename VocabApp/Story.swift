// VocabApp
// Created by enzo on 5/28/24

import Foundation
import MLKit
import NaturalLanguage

struct Story: Identifiable, Codable {
    let id: UUID
    let title: String
    let tokens: [Token]
    let language: String
    
    var ml_language: TranslateLanguage {
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
    
    enum Token: Codable {
        case word(String)
        case newLine
    }
    
    init(id: UUID = UUID(), title: String, text: String, language: String) {
        self.id = id
        self.title = title
        self.language = language
        
        var tokens: [Token] = []
        let paragraphTokenizer = NLTokenizer(unit: .paragraph)
        
        paragraphTokenizer.string = String(text)
        paragraphTokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { paragraphRange, _ in
            let paragraph = String(text[paragraphRange])
            
            let wordTokenizer = NLTokenizer(unit: .word)
            wordTokenizer.string = paragraph
            wordTokenizer.enumerateTokens(in: paragraph.startIndex..<paragraph.endIndex) { wordRange, _ in
                let token = Token.word(String(paragraph[wordRange]))
                tokens.append(token)
                return true
            }
            
            tokens.append(.newLine)
            return true
        }
        
        
        
        if !tokens.isEmpty {
            tokens.removeLast()
        }
        
        
        self.tokens = tokens
    }
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
        Story(title: "HSK 2 Practice Sentences (Traditional)",
              text: """
"我去火車站後面。
              星期二同學請我去飯館吃飯。
              星期日很冷。
              漂亮的女人是誰？
              我要買六七個椅子。
              餵？你請說話！
              他中午去飯館。
              魚真便宜！
              羊肉真好吃！
              媽媽笑了。
              生日快樂！
              姐姐喜歡打籃球。
              我家有媽媽、爸爸、妹妹和我。
              和弟弟跑步吧。
              穿紅衣服的是服務員。
              我賣了一百件衣服
              我穿過房間看見一個女人。
              坐公共汽車去上班。
              為什麼要幫助你？
              看完報紙休息。
              哥哥比弟弟高。
              我喜歡的運動是：游泳、踢足球。
              別唱歌了，跳舞吧。
              考試的時間很長。
              早上出公司。
              我去年去中國三次。
              我們準備一起再玩（兒）一小時。
              從家到學校很遠。
              讓大家起牀吧。
              但是我覺得您可以喝咖啡。
              雪是白的。
              電腦賣得貴。
              在機場等飛機。
              右邊第一個男人是我丈夫。
              我能懂你。
              房間非常漂亮。
              四號去教室。
              希望它離公司近。
              給你介紹我妹妹。
              可能他正在忙。
              公司旁邊有學校。
              身體生病了，要吃藥。
              我已經找出問題了，晚上問你。
              西瓜也要一起洗。
              今天天氣晴/陰。
              最左邊的是哥哥的妻子。
              我知道他走得慢。
              每個新題都很有意思。
              哥哥的眼睛是什麼顏色的？
              你有什麼事情？
              爸爸送我去飯館。
              牛奶不好喝。
              那個男人賣票。
              請喝杯茶吧。
              我們坐出租車去火車站。
              家裡沒吃的了，我們去買點兒吧。
              先生，請問您什麼時候開始點菜？
              我都快吃完了。
              中午我們去飯店吃吧。
              我想休息幾分鐘。
              你的房間號是多少？
              我去過一回北京。
              我哥哥開了一家公司
""",
              language: "zh-CN"),
    ]
}
