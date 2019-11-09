//
//  XUILabel.swift
//  Wardah
//
//  Created by Nour  on 12/22/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//


import UIKit

@IBDesignable
class XUIButton:UIButton{
    
    @IBInspectable var localization: String = "" {
        didSet {
            self.setTitle(localization.localized, for: .normal)
        }
    }
    
    @IBInspectable var primary:Bool {
        didSet{

            if primary{
                //self.backgroundColor = AppColors.primaryButton
                self.setTitleColor(.white, for: .normal)
            }
        }
    }
    init(primary:Bool){
        self.primary = primary
        super.init(frame:CGRect.zero)
    }
    
    
    override init(frame: CGRect) {
        self.primary = true
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.primary = true
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.titleLabel?.font = AppFonts.normalBold
            let currentTitle = self.currentTitle
            self.setTitle(currentTitle?.localized, for: .normal)
        if AppConfig.currentLanguage == .english{
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            
        }else{
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        }
    }
    
  
    
}
