// VocabApp
// Created by enzo on 5/28/24

import Foundation
import AVFoundation

class TTSService {
    let synthesizer: AVSpeechSynthesizer
    
    init() {
        self.synthesizer = AVSpeechSynthesizer()
    }
    
    func play(text: String, lang: String){
        
        let utterance = AVSpeechUtterance(string: text)
        let voice = AVSpeechSynthesisVoice(language: lang)

        utterance.rate = 0.30
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        utterance.voice = voice
        
        self.synthesizer.speak(utterance)
    }
}
