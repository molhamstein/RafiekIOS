//
//  NSlayoutConstraint.swift
//  Wardah
//
//  Created by Nour  on 11/5/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation

import UIKit

class XNSLayoutConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        let ratio = ScreenSizeRatio.smallRatio
        self.constant = self.constant  * CGFloat(ratio)
    }
    
}


extension NSLayoutConstraint{

//    open override func awakeFromNib() {
//        let ratio = ScreenSizeRatio.smallRatio
//        self.constant = self.constant * CGFloat(ratio)
//    }
    
    func setNewConstant(_ newconstant:CGFloat){
        self.constant = newconstant
    }
    
}
