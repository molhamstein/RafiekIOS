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
        return "Enter Book Number and Press enter"
        
    }
    
    
    static var searchResultViewErrorMessage:String{
        if AppConfig.currentLanguage == .arabic{
            return "رقم الكتاب الذي ادخلته غير موجود الرجاء معاودة المحاولة"
        }
        return "The book number you entered is not correct please try again"
        
    }
    
    static var wrongChooseErrorMessage:String{
        if AppConfig.currentLanguage == .arabic{
            return  "لقد قمت باختيار خاطئ الرجاء اعادة المحاولة"
        }
        return "you entered a wrong choice please try again"
        
    }
    
    static var closeMessage:String{
        if AppConfig.currentLanguage == .arabic{
            return  "انت على وشك اغلاق الكتاب للتاكيد اضغط زر الاغلاق مرة ثانية"
        }
        return "you are about to clsoe the book to confirm press the close button again"
        
    }
    
    
    
}
