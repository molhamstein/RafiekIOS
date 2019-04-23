//
//  AppBrain.swift
//  Al-Rafik
//
//  Created by Nour  on 4/17/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation



struct AppBrain {

    private var value:String?
    private var number:Int?
    private var book:String?
    private var enterMode:Bool = false
    private var menuMode:Bool = false
    
    private enum Operation{
        case text2Speech((String)->Void)
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
    
    
  
    mutating func performOperation(_ sympole:String){
        VoiceManager.shared.stop()
        if let operation = operations[sympole]{
            switch operation {
            case .text2Speech(let f):
                f(value ?? "")
                break
            case .playAudio(let f):
                if let book = self.book{
                    if let url = FileHelper.getAudiofilePath(folder: book, file: value ?? ""){
                        f(url,false)
                    }
                }
                break
            case .navigate(let f):
                f(value ?? "")
                break
            case .openUrl(let f):
                f(value ?? "")
                break
                
            case .command:
                VoiceManager.shared.speek(msg: value ?? "")
                if let val = value , let num = Int(val){
                    setNumber(num)
                }
                if let op = value{
                    switch (op){
                    case "up" , "down" , "left" , "right":
                        NavigationManager.goToDirection(dir: op)
                        break;
                    case "next":
                        NavigationManager.next()
                        break;
                    case "previous":
                        NavigationManager.prev()
                        break;
                    case "enter":
                        if !enterMode{
                            if menuMode{
                                if let index = number {
                                    NavigationManager.trigerMenuAction(num: index)
                                    number = nil
                                }
                                menuMode = false
                            }else{
                                VoiceManager.shared.speek(msg: "Please Choose the page number")
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
                    case "menu":
                            VoiceManager.shared.speek(msg: "Please Choose the Action number")
                            NavigationManager.playMenuActions()
                            menuMode = true
                            enterMode = false
                        break
                    default:
                        break;
                    }
                }
                break
           
            }
        }
        
        
    }

    
    mutating func setValue(_ operand:String){
        value = operand
    }
    
    mutating func setNumber(_ val:Int){
        number = val
    }
    

    mutating func setBook(_ book:String){
        self.book = book
    }
    
    
}
