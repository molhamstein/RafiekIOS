//
//  XUITextField.swift
//  Wardah
//
//  Created by Nour  on 12/22/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation
import UIKit




@IBDesignable
class XUITextField:UITextField{
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.appStyle()
        
        self.placeholder = self.placeholder?.localized
//        if tag > 1{
//            self.font = AppFonts.normal
//        }else{
//            self.font = AppFonts.xSmall
//        }
        
    }


}


class PasswordTextField:UITextField{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if tag != -1{
            self.appStyle()
        }
        self.placeholder = self.placeholder?.localized
        self.font = AppFonts.normal
        self.addIconButton()
    }
    
    func addIconButton(){
        
        self.addIconButton(image: "eyeIcon")
        let passwordTextFieldRightButton = self.rightView as! UIButton
        passwordTextFieldRightButton.addTarget(self, action: #selector(hideText), for: .touchUpInside)
        
        
    }
    
    @objc func hideText(){
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
    
    

}









