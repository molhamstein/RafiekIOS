//
//  AppBrain.swift
//  Al-Rafik
//
//  Created by Nour  on 4/17/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation



enum Commands:String{
    case menu       = "menu"
    case enter      = "enter"
    case up         = "up"
    case down       = "down"
    case left       = "left"
    case right      = "right"
    case previous   = "previous"
    case next       = "next"
    case confirm    = "confirm"
    
    var description:String{
        switch self {
        case .menu:
            return ""
        case .enter:
            return ""
        case .up:
            return ""
        case .down:
            return ""
        case .left:
            return ""
        case .right:
            return ""
        case .previous:
            return ""
        case .next:
            return "Going To next page"
        case .confirm:
            return ""
        }
        
    }
}

class AppBrain {

    private var value:String?
    private var number:Int?
    private var book:String?
    private var enterMode:Bool = false
    private var menuMode:Bool = false
    private var confirmMode:Bool = false
    
    private enum Operation{
        case text2Speech((String, @escaping () -> ())->Void)
        case playAudio((URL,Bool)->Void)
        case navigate((String)->Void)
        case openUrl((String)->Void)
        case command
    }
    
    
    
    private var operations:[String:Operation] = [
        "text":Operation.text2Speech(VoiceManager.shared.speek),
        "audio":Operation.playAudio(VoiceManager.shared.play),
        "navigation":Operation.navigate(NavigationManager.navigateToPage),
        "url":Operation.openUrl(NavigationManager.openUrl),
        "command":Operation.command,
    ]
  
     func performOperation(_ sympole:String){
        VoiceManager.shared.stop()
        if let operation = operations[sympole]{
            switch operation {
            case .text2Speech(let speek):
                speek(value ?? ""){}
                number = nil
                break
            case .playAudio(let play):
                if let book = self.book{
                    if let url = FileHelper.getAudiofilePath(folder: book, file: value ?? ""){
                        play(url,false)
                    }
                }
                number = nil
                break
                
            case .navigate(let navigate):
                navigate(value ?? "")
                number = nil
                break
                
            case .openUrl(let openURL):
                openURL(value ?? "")
                number = nil
                break
                
            case .command:
                // Comand
                VoiceManager.shared.speek(msg: value ?? ""){
                    
                }
                if let val = value , let num = Int(val){
                    setNumber(num)
                }
                if let val = value , let op = Commands(rawValue: val){
                    switch (op){
                    case .up , .down , .left , .right:
                        VoiceManager.shared.speek(msg: op.description) {
                            NavigationManager.goToDirection(dir: op.rawValue)
                            self.number = nil
                        }
                        break;
                    case .next:
                        NavigationManager.next()
                        number = nil
                        break;
                    case .previous:
                        NavigationManager.prev()
                        number = nil
                        break;
                    case .enter:
                        if !enterMode{
                            if menuMode{
                                if let index = number {
                                    NavigationManager.trigerMenuAction(num: index)
                                    number = nil
                                }
                                menuMode = false
                            }else{
                                VoiceManager.shared.speek(msg: "Please Choose the page number")
                                number = nil
                                enterMode = true
                            }
                        }else{
                            if let index = number {
                                NavigationManager.goToPage(num: index)
                                number = nil
                            }
                            enterMode = false
                        }
                        break
                    case .menu:
                            VoiceManager.shared.speek(msg: "Please Choose the Action number")
                            NavigationManager.playMenuActions()
                            menuMode = true
                            enterMode = false
                            number = nil
                        break
                    case .confirm:
                        break
                    }
                }// End Command
                break
           
            }
        }
        
        
    }

    
     func setValue(_ operand:String){
        value = operand
    }
    
     func setNumber(_ val:Int){
        number = (number ?? 0) * 10 +  val
        print(number)
    }
    

     func setBook(_ book:String){
        self.book = book
    }
    
    
    
}
