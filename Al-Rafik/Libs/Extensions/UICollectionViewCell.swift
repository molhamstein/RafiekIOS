//
//  UICollectionViewCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/18/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell{
    
    
    func makerounded(){
        
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
    }
    
    
    func roundedBorder(value:CGFloat){
        self.contentView.layer.cornerRadius = value
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    
    func addShadow(){
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero//CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
    
}
