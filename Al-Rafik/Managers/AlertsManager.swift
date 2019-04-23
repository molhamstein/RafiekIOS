//
//  AlertsManager.swift
//  Al-Rafik
//
//  Created by Nour  on 4/23/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation


struct AlertsManager{    
    static func loadingAlert(state:Bool){
        if state{
            if let url = FileHelper.filePathMainBundel(file: "loading", ext: "mp3"){
                VoiceManager.shared.play(audioURL: url,replay: true)
            }
        }else{
            VoiceManager.shared.stop()
        }
    }
    
    static func successAlert(){
        if let url = FileHelper.filePathMainBundel(file: "success", ext: "mp3"){
            VoiceManager.shared.play(audioURL: url)
        }
    }
    
    static func errorAlert(){
        if let url = FileHelper.filePathMainBundel(file: "error", ext: "mp3"){
            VoiceManager.shared.play(audioURL: url)
        }
    }

    static func warningAlert(){
        if let url = FileHelper.filePathMainBundel(file: "error", ext: "mp3"){
            VoiceManager.shared.play(audioURL: url)
        }
    }
}
