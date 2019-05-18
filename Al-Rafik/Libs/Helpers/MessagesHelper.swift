//
//  MessagesHelper.swift
//  Al-Rafik
//
//  Created by Nour  on 5/18/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation

class MessagesHelper {
    
    static var languageViewInfoMessage:String{
        if AppConfig.currentLanguage == .arabic{
                return "الرجاء اختيار اللغة العربية او اللغة الانكليزية"
        }
        return "Please choose Arabic or english Language"
    }
    
    
    static var gendarViewInfoMessage:String{
        if AppConfig.currentLanguage == .arabic{
            return "الرجاء اختيار نبرة الصوت رجل او امرأة"
        }
        return "Please choose Male or female Gendar"
    }
    
    
    static var searchViewInfoMessage:String{
        if AppConfig.currentLanguage == .arabic{
            return "ادخل رقم الكتاب عن طريق الضغط على الارقام ومن ثم اضغط زر انتر"
        }
        return "Enter Book code using the numbers and then press enter"
        
    }
    
    static var searchResultViewInfoMessage:String{
        if AppConfig.currentLanguage == .arabic{
            return "ادخل رقم الكتاب عن طريق الضغط على الارقام ومن ثم اضغط زر انتر"
        }
        return "Enter Book code using the numbers and then press enter"
        
    }
    
    
}
