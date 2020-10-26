//
//  SfxHelper.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/25/20.
//

import AVFoundation
import AppKit

class SfxHelper {

    static func moo() {
//        let url = Bundle.main.url(forResource: "Single_Cow-SoundBible.com-2051754137", withExtension: "mp3")!
//          do {
//              let player = try AVAudioPlayer(contentsOf: url)
//              player.prepareToPlay()
//              player.play()
//          } catch let error {
//              print(error.localizedDescription)
//          }
        NSSound(named: "Single_Cow-SoundBible.com-2051754137.mp3")?.play()
    }
}
