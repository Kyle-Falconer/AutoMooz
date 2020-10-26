//
//  TtsHelper.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/25/20.
//

import AVFoundation

class TtsHelper {
    static func announce(text: String) -> Void {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.3

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
