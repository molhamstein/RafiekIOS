//
//  SpeechCommands.swift
//  Al-Rafik
//
//  Created by Nour Araar on 11/7/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import Speech
import AVFoundation

var NumericNumbers:[String:String] = [
     "one"    : "1"
    ,"two"    : "2"
    ,"three" : "3"
    ,"four"   : "4"
    ,"five"    : "5"
    ,"six"      : "6"
    ,"seven" : "7"
    ,"eight"   : "8"
    ,"nine"    : "9"
    ,"ten"      : "10"
    ,"first"    : "1"
    ,"second"    : "2"
    ,"third" : "3"
    ,"forth"   : "4"
    ,"fifth"    : "5"
    ,"sixth"      : "6"
    ,"seventh" : "7"
    ,"eighth"   : "8"
    ,"nineth"    : "9"
    ,"ninth"      : "9"
    ,"tenth"      : "10"
                ,"واحد":"1"
    ,"اثنان":"2"
    ,"إثنان":"2"
    ,"إثنين":"2"
    ,"اثنين":"2"
    ,"ثلاثة":"3"
    ,"أربعة":"4"
    ,"اربعة":"4"
    ,"خمسة":"5"
    ,"ستة":"6"
    ,"سبعة":"7"
    ,"ثمانية":"8"
    ,"تسعة":"9"
    ,"عشرة":"10"
    ,"صفر":"0"
    ,"الاول"    : "1"
    ,"الأول"    : "1"
    ,"الأولى"    : "1"
    ,"الثانية"    : "2"
    ,"الثاني"    : "2"
    ,"الثالثة" : "3"
    ,"الثالث"    : "3"
    ,"الرابعة"   : "4"
    ,"الرابع"   : "4"
    ,"الخامسة"    : "5"
    ,"الخامس"    : "5"
    ,"السادسة"      : "6"
    ,"السادس"      : "6"
    ,"السابعة" : "7"
    ,"السابع" : "7"
    ,"الثامنة"   : "8"
    ,"الثامن"   : "8"
    ,"التاسعة"    : "9"
    ,"التاسع"    : "9"
    ,"العاشرة"      : "10"
    ,"العاشر"      : "10"
]

protocol SpeechCommandDelegate {
    func commandDidFetched(command:VoiceCommand)
}

class SpeechCommandsManager: NSObject, SFSpeechRecognizerDelegate {
    
    static var shared = SpeechCommandsManager()
    var delegate: SpeechCommandDelegate?
    let speechSynthesizer = AVSpeechSynthesizer()
    var channel:AVAudioNodeBus = 1
    private var listening = false
    //  private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    var timer:Timer?
    var Stoptimer:Timer?
    private let audioEngine = AVAudioEngine()
    
   @objc  func open(){
        askMicPermission(completion: { (granted, message) in
            DispatchQueue.main.async {
                if self.audioEngine.isRunning {
                    if granted {
                        self.stopListening()
                    }
                } else {
                    // Setup the text and start recording
                    self.listening = true
                    if granted {
                        self.startListening()
                    }
                }
            }
        })
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        tapButton.isEnabled = available
        if available {
            // Prepare to listen
            listening = true
        } else {
            print("Recognition is not available.")
        }
    }
    
    private func askMicPermission(completion: @escaping (Bool, String) -> ()) {
        SFSpeechRecognizer.requestAuthorization { status in
            let message: String
            var granted = false
            
            switch status {
            case .authorized:
                message = "Listening..."
                granted = true
                break
                
            case .denied:
                message = "Access to speech recognition is denied by the user."
                break
                
            case .restricted:
                message = "Speech recognition is restricted."
                break
                
            case .notDetermined:
                message = "Speech recognition has not been authorized yet."
                break
            }
            completion(granted, message)
        }
    }
    
    
    private func startListening() {
        AlertsManager.successAlert()
        self.StopSpeechTimer()
        // Clear existing tasks
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        // Start audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("An error occurred when starting audio session.")
            return
        }
        
        // Request speech recognition
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        let  speechRec = SFSpeechRecognizer(locale: Locale.init(identifier: AppConfig.currentLanguage.langCode))
        speechRec?.delegate = self
        recognitionTask = speechRec?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            print("processing")
            var isFinal = false
            if result != nil {
                print(result?.bestTranscription.formattedString ?? "")
                print(result!.isFinal)
                isFinal = result!.isFinal
            }
            if isFinal {
                // here finish the listening
                if let msg = result?.bestTranscription.formattedString{
                    self.finalizeListening()
                    // here handle the command
                    self.fetchCommand(msg: msg)
                }else{
                    self.finalizeListening()
                }
            }
            else if error == nil{
                self.restartSpeechTimer(time:1.0)
            }
            if error != nil || self.listening == false{
                //  self.playErrorSound()
                // here give error signal
                self.finalizeListening()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: channel)
        if self.recognitionRequest != nil{
            inputNode.installTap(onBus: self.channel, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("An error occurred starting audio engine")
        }
    }
    
    
    private func stopListening() {
        print("stopListing")
        timer?.invalidate()
        Stoptimer?.invalidate()
        audioEngine.inputNode.removeTap(onBus: channel)
        audioEngine.inputNode.reset()
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.cancel()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        self.listening = false
        // here give the signal to be able to listen again
    }
    
    
    @objc private func timerEnded() {
        // If the audio recording engine is running stop it and remove the SFSpeechRecognitionTask
        if audioEngine.isRunning {
            endlistening()
        }
    }
    
    @objc private  func restartSpeechTimer(time:Double) {
        print("restart timer")
        timer?.invalidate()
        Stoptimer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { (timer) in
            if self.audioEngine.isRunning{
                self.endlistening()
            }
        })
    }

    @objc func StopSpeechTimer() {
        print("stopTimer")
        timer?.invalidate()
        Stoptimer?.invalidate()
        Stoptimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
            if self.audioEngine.isRunning{
                self.stopListening()
            }
        })
    }
    
   private  func endlistening(){
        timer?.invalidate()
        Stoptimer?.invalidate()
        self.listening = false
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: self.channel)
        self.recognitionRequest?.endAudio()
    }

    private func finalizeListening(){
        timer?.invalidate()
        Stoptimer?.invalidate()
        self.audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: self.channel)
        self.listening = false
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    // call wit api
    func fetchCommand(msg:String){
        let commad = normalizeCommand(msg: msg)
        print(commad)
        CommandAPI
            .shared
            .getCommand(message: commad, completionBlock: { (success, error, result) in
                if success{
                    if let command = result {
                        self.delegate?.commandDidFetched(command: command)
                    }else {
                        AlertsManager.errorAlert()
                    }
                }
                if error != nil {
                    AlertsManager.errorAlert()
                }
            })
    }
    // this func to convert string numbers to numeric numbers ex ( one -> 1 , three -> 3)
    func normalizeCommand(msg:String)-> String{
        var result = msg
        for (key,val) in NumericNumbers {
            result = result.replacingOccurrences(of: key, with: val)
        }
        return result
    }
}
