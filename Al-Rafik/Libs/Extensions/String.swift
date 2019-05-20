//
//  String.swift
//  
//
//  Created by AlphaApps on 02/11/16.
//  Copyright © 2016 BrainSocket. All rights reserved.
//

import UIKit

extension String {
    
    /// Return count of chars
    var length: Int {
        return count
    }
    
    /// Check if the string is a valid email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    

    
    /// Check if the string is alphanumeric
    var isAlphanumeric: Bool {
        return self.range(of: "^[a-z A-Z]+$", options:String.CompareOptions.regularExpression) != nil
    }
    
    var isNumber: Bool {
        return self.range(of: "^[0-9]+$", options:String.CompareOptions.regularExpression) != nil
    }
    
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
        var filtered:String!
        let inputString:NSArray = self.components(separatedBy: charcter) as NSArray
        filtered = inputString.componentsJoined(by: "")
        
        if self != filtered{
            return false
        }
//
//        if self.length < 12{
//            return false
//        }
        
//        if !(self.starts(with: "00963") || self.starts(with: "+963") ) {
//            return false
//        }
//
        return  true
        
    }
    
    
    /// Localized current string key
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Localized text using string key
    public static func localized(_ key:String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    /// Remove spaces and new lines
    var trimed :String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Get label height for string
    func getLabelHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: .zero)
        label.frame.size.width = width
        label.font = font
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        return label.frame.size.height
    }
    
    
    /// Get label Width for string
    func getLabelWidth(font:UIFont) ->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
    
    
    // check if string contained in another string
    func contains(find: String) -> Bool{
        return self.range(of:find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
    }
}
