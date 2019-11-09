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


enum Gendar:String{
    case male = "male"
    case female = "female"
}

enum VoiceType{
    case maleAR
    case femaleAR
    case maleEN
    case femaleEN
    
    var identifire:String{
        switch self {
        case .maleAR:
            return "ar-SA"
        case .maleEN:
            return "en-GB"
        case .femaleAR:
            return "ar-SA"
        case .femaleEN:
            return "en-US"
        
        }
    }
    
}


class VoiceManager:NSObject{
    
    typealias CompletionBlock = ((Bool) -> ())
    var completionBlock: CompletionBlock?
    var queue = Queue<String>()
    
    public var player:AVAudioPlayer?
    public var speechSynthesizer:AVSpeechSynthesizer?
    public var textList:[String]?
    var current:Int = 0
//    var playList:Bool = false
    var finished = false
    var isSpeaking = false
    public static var shared = VoiceManager()
    
    override init() {
        super.init()
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer?.delegate = self
    }
    
    func speek(_ message: String, completion: CompletionBlock? = nil){
        // Line 1. Create an instance of AVSpeechSynthesizer.
        
        speechSynthesizer?.stopSpeaking(at: .immediate)
        completionBlock?(false)
        completionBlock = completion
        // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: message)
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        speechUtterance.rate = 0.4
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 100
        // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        //ar-SA
        let voice = AVSpeechSynthesisVoice(language: AppConfig.currentVoice.identifire)
        
        speechUtterance.voice = voice
        
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        isSpeaking = true
        self.speechSynthesizer?.speak(speechUtterance)
    
    }
    
    func appendTextList(list:[String]){
        for st in list{
            queue.enqueue(st)
        }
    }
    
    func playList(){
        if(!queue.isEmpty && !isSpeaking){
            speek(queue.dequeue() ?? "")
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
            self.speek("I Can not play this file"){_ in }
        }
    }
    
    func removeLast(){
        if(!queue.isEmpty){
            speek(queue.dequeue() ?? "")
        }
    }
    
     func stop(){
        player?.stop()
        speechSynthesizer?.stopSpeaking(at: .immediate)
//        playList = false
        current = 0
        textList = nil
        isSpeaking = false
    }
  
}


extension VoiceManager:AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        print("finished")
        
        completionBlock?(true)
        completionBlock = nil
//        if playList{
//            current += 1
//            if let cnt = textList?.count , current < cnt {
//                speek(textList?[current] ?? ""){_ in }
//            }else{
//                playList = false
//                textList = nil
//            }
//        }
        if(!queue.isEmpty){
            speek(queue.dequeue() ?? "")
        }else{
            isSpeaking = false
        }
    }
}

