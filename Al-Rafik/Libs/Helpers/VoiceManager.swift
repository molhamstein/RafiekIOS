//
//  VoiceManager.swift
//  Al-Rafik
//
//  Created by Nour  on 4/14/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import AVFoundation
import Speech


class VoiceManager:NSObject{
    
    public var player:AVAudioPlayer?
    public var speechSynthesizer:AVSpeechSynthesizer?
    public var textList:[String]?
    var current:Int = 0
    var playList:Bool = false
    var finished = false
    
    public static var shared = VoiceManager()
    
    override init() {
        super.init()
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer?.delegate = self
    }
    
    func speek(msg:String,completionBlock: @escaping () -> () = {  }){
        // Line 1. Create an instance of AVSpeechSynthesizer.
       finished = false
        // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: msg)
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        speechUtterance.rate = 0.5
        // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        speechSynthesizer?.speak(speechUtterance)

        
        DispatchQueue.main.async {
//                    while(true){
//                        if (self.finished){
//                            completionBlock()
//                            break;
//                        }
//                    }
        }
        print("xx")
    }
    
    func speakTextList(){
        if textList != nil{
            playList = true
            current = 0
            speek(msg: textList?[current] ?? ""){
            }
        }else{
            playList = false
        }
    }

     func play(audioURL:URL,replay:Bool = false){
        stop()
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            if replay{
                
                player?.numberOfLoops = -1
            }else{
                player?.numberOfLoops = 0
            }
            player?.prepareToPlay()
            player?.play()
            
        } catch {
            self.speek(msg: "I Can not play this file"){}
        }
    }
    
    
     func stop(){
        player?.stop()
        speechSynthesizer?.stopSpeaking(at: .immediate)
        playList = false
        current = 0
        textList = nil
    }
  
}


extension VoiceManager:AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        finished = true
        print("finished")
        if playList{
            current += 1
            if let cnt = textList?.count , current < cnt {
                speek(msg: textList?[current] ?? ""){}
            }else{
                playList = false
                textList = nil
            }
        }
    }
}
