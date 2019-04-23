//
//  XUILabel.swift
//  Wardah
//
//  Created by Nour  on 12/22/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class XUILabel:UILabel{
    
    @IBInspectable var localization: String = "" {
        didSet {
            self.text = localization.localized
        }
    }

    @IBInspectable var fontType: Int = 0 {
        didSet {
            switch (fontType){
            case 0:
                self.font = AppFonts.small
            case 1:
                self.font = AppFonts.normal
            case 2:
                self.font = AppFonts.big
            default:
                self.font = AppFonts.normal
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if self.tag == -1{
//            self.font = AppFonts.xSmall
//        }else if self.tag > -1 {
//            self.font = AppFonts.normal
//        }else{
//            self.font = UIFont.systemFont(ofSize: 10)
//        }
       // setLineHeight(height: 0.5)
        self.text = self.text?.localized
    }

}




extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
    
    func setLineHeight(height:CGFloat){
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = height
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
     //   setLineHeight(height: 1)
    }
    
    
}

