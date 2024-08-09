//
//  TTSService.swift
//  Lexel
//
//  Created by Tyler McCormick on 7/28/24.
//

import Foundation
import AVFoundation
import NaturalLanguage

class TTSService {
    static let shared = TTSService()
    
    /// Helper function to generate TTS for a given word
    ///
    /// - Parameters
    ///     - word: The word to be spoken
    ///     - lang: The language of the word (for accent purposes)
    func speak(text: String, lang: String){
        let utterance = AVSpeechUtterance(string: text)
        let voice = AVSpeechSynthesisVoice(language: lang)
        
        utterance.rate = 0.30
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        utterance.voice = voice
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func speak(text: String) {
        let recgonizer = NLLanguageRecognizer()
        let speechSynthesizer = AVSpeechSynthesizer()
        
        recgonizer.processString(text)
        let lang = recgonizer.dominantLanguage!.rawValue
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        speechSynthesizer.speak(utterance)
    }
}
