//
//  AppBrain.swift
//  Al-Rafik
//
//  Created by Nour  on 4/17/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation



enum Commands:String{
    case menu           = "menu"
    case enter          = "enter"
    case up             = "up"
    case down           = "down"
    case left           = "left"
    case right          = "right"
    case previous       = "previous"
    case next           = "next"
    case confirm        = "confirm"
    case text           = "text"
    case navigation     = "navigation"
    case url            = "url"
    case audio          = "audio"
    case command        = "command"
    case setPage        = "setPage"
    case navigateMenu   = "navigateMenu"
    
    
    func description(val:String = "") -> String{
        switch self {
        case .menu:
            if AppConfig.currentLanguage == .arabic{
                return "ستسمع مجموعه من الاوامر المرقمة, اختر احدها و اضغط موافق"
            }
            return "Menu Mode,  you will hear a list of commands and you have to type the number of the command and then press enter"
        case .enter:
            if AppConfig.currentLanguage == .arabic{
                  return "يمكنك الان ادخال رقم الصفحة و ضغط موافق ثم تثبيت الصفحة و التاكيد بضغط موافق مرة اخرى"
            }
              return "Enter Mode, Type the page number on your keypad and place the correct page on your device and then press enter again to confirm the page or press menu to cancel"
        case .up:
            if AppConfig.currentLanguage == .arabic{
                return "التوجه للاعلى"
            }
            return "Going To up page"
        case .down:
            if AppConfig.currentLanguage == .arabic{
                return "التوجة للاسفل"
            }
            return "Going To down page"
        case .left:
            if AppConfig.currentLanguage == .arabic{
                return "التوجه الى اليسار"
            }
            return "Going To left page"
        case .right:
            if AppConfig.currentLanguage == .arabic{
                return "التوجه الى اليمين"
            }
            return "Going To right page"
        case .previous:
            if AppConfig.currentLanguage == .arabic{
                return "الذهاب للصفحة السابقة"
            }
            return "Going To previose page"
        case .next:
            if AppConfig.currentLanguage == .arabic{
                return "التوجه للصفحة التالية"
            }
            return "Going To next page"
        case .confirm:
            if AppConfig.currentLanguage == .arabic{
                return "الرجاء تثبيت الصفحة \(val) على الجهاز ومن ثم اضغط زر موافق"
            }
            return "Please Set The correct Page \(val) on your device and then press enter or press menu to cancel"
        case .text:
            if AppConfig.currentLanguage == .arabic{
                return "قراءة النص"
            }
            return "You will hear a text"
        case .navigation:
            if AppConfig.currentLanguage == .arabic{
                return "سوف يتم نقلك الى الصفحة الرجاء وضع الصفحة المطلوبة على الجهاز واضغط موافق  \(val)"
            }
            return "You will be navigating to page \(val) please set the required page on the device and press enter or press menu to cancel"
            
        case .navigateMenu:
            if AppConfig.currentLanguage == .arabic{
                return "سوف يتم نقلك الى الصفحة \(val)"
            }
            return "You will be navigating to page \(val)"
        case .audio:
            if AppConfig.currentLanguage == .arabic{
               return "لسماع تسجيل صوتي"
            }
            return "You will hear an audio file"
        case .url:
            if AppConfig.currentLanguage == .arabic{
                return "لفتح رابط خارجي"
            }
            return "You will open a web url"
        case .command:
            if AppConfig.currentLanguage == .arabic{
                return "Command"
            }
            return "Command"
        case .setPage:
            if AppConfig.currentLanguage == .arabic{
                return "سوف يتم نقلك الى الصفحة \(val) الرجاء وضع الصفحة المطلوبة على الجهاز"
            }
            return "You will be navigating to page \(val) please set the required page on the device or press enter to choose another page or press menu to hear the list of commands"
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
    private var selectedPage:Page?
    
    public enum Operation{
        case text2Speech((String, @escaping (Bool) -> ())->Void)
        case playAudio((URL,Bool)->Void)
        case navigate((String)->Void)
        case openUrl((String)->Void)
        case command
    }
    
    
    
    public static var operations:[String:Operation] = [
        "text":Operation.text2Speech(VoiceManager.shared.speek),
        "audio":Operation.playAudio(VoiceManager.shared.play),
        "navigation":Operation.navigate(NavigationManager.navigateToPage),
        "url":Operation.openUrl(NavigationManager.openUrl),
        "command":Operation.command,
    ]
  
     func performOperation(_ sympole:String){
        VoiceManager.shared.stop()
        if let operation = AppBrain.operations[sympole]{
            switch operation {
            case .text2Speech(let speek):
                speek(value ?? ""){_ in }
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
                
            case .navigate(_):
                if let _ = selectedPage{
                    enterMode = false
                    confirmMode = true
                }
                number = nil
                break
                
            case .openUrl(let openURL):
                openURL(value ?? "")
                number = nil
                break
                
            case .command:
                handelComand()
                break
           
            }
        }
        
        
    }

    
    func handelComand(){
        // Comand
        VoiceManager.shared.speek(value ?? "")
        if let val = value , let num = Int(val){
            setNumber(num)
        }
        if let val = value , let op = Commands(rawValue: val){
            switch (op){
            case .up , .down , .left , .right:
                
                if let _ = selectedPage{
                    enterMode = false
                    confirmMode = true
                }
                self.number = nil
                break;
            case .next:
                if let _ = selectedPage{
                    enterMode = false
                    confirmMode = true
                }
                self.number = nil
                
                break;
            case .previous:
                if let _ = selectedPage{
                    enterMode = false
                    confirmMode = true
                }
                self.number = nil
                
                break;
            case .enter:
                handelEnterMode(op:op)
                break
            case .menu:
                handelMenuMode(op:op)
                break
            case .confirm:
                break
            default:
                VoiceManager.shared.speek(op.description()) { _ in
                    
                }
            }
        }// End Command
    }
    
    
    func handelEnterMode(op:Commands){
        if !enterMode{
            // confirm menu action
            if menuMode{
                if let index = number {
                    NavigationManager.trigerMenuAction(num: index)
                    number = nil
                }
                menuMode = false
            }else if confirmMode{ // confirm navigation action
                if let page = selectedPage{

                    NavigationManager.navigateToPage(id: page.pid ?? "")
                    confirmMode = false
                    enterMode = false
                    menuMode = false
                }
            }else{ // enter mode
                VoiceManager.shared.speek(op.description())
                number = nil
                enterMode = true
            }
        }else{
            if !confirmMode{ // confirm enter mode
                confirmMode = true
                VoiceManager.shared.speek(Commands.confirm.description(val:"\(number ?? 0)"))
            }else{
                if let index = number { // confirm number in enter mode
                    NavigationManager.goToPage(num: index)
                    number = nil
                }else if let page = selectedPage{ // confirm page in navigation
                    VoiceManager.shared.appendTextList(list: [Commands.navigation.description(val:"\(page.description ?? "")")])
                    VoiceManager.shared.playList()
                    NavigationManager.navigateToPage(id: page.pid ?? "")
                }
                confirmMode = false
                enterMode = false
            }
        }
    }
    
    func handelMenuMode(op:Commands){
        if confirmMode || enterMode{
            confirmMode = false
            enterMode = false
         
        }else{
        VoiceManager.shared.appendTextList(list: [op.description()])
        NavigationManager.playMenuActions()
        VoiceManager.shared.playList()
        self.menuMode = true
        self.enterMode = false
        self.confirmMode = false
        self.number = nil
        }
    }
    
    func setPage(_ page:Page){
        selectedPage = page
    }
    
     func setValue(_ operand:String){
        value = operand
    }
    
     func setNumber(_ val:Int){
        number = (number ?? 0) * 10 +  val
    }
    

     func setBook(_ book:String){
        self.book = book
    }
    
    
    
}
