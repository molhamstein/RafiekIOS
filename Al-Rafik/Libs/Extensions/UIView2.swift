//
//  Extensions.swift
//  audible
//
//  Created by Brian Voong on 9/17/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
extension UIView {
  
    
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
            
        }
        
        if let left = left {
            anchors.append(leadingAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
            
        }
        
        if let right = right {
            anchors.append(trailingAnchor.constraint(equalTo: right, constant: -rightConstant))
            
        }
        
        if widthConstant > 0 {
            
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
            
        }
        
        if heightConstant > 0 {
            
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
            
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
}


extension UIView {
    
    
    func anchorToTop8(_ topview: UIView? = nil, leftview: UIView? = nil, bottomview: UIView? = nil, rightview: UIView? = nil) {
        
      //  anchorWithConstantsToTop8(topview, leftview: leftview, bottomview: bottomview, rightview: rightview, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        anchorWithConstantsToTop8(topview, leftview: leftview, bottomview: bottomview, rightview: rightview, topattribute: .top, leftattribute: .leading, bottomattribute: .bottom, rightattribute: .trailing, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorToSuperView(topConstant:CGFloat = 0 ,leftConstant:CGFloat = 0 ,bottomConstant:CGFloat = 0,rightConstant:CGFloat = 0 ,widthconstant:CGFloat = 0, heightConstant:CGFloat=0){
        
        if let superview = self.superview {
        
         _ = self.anchor8(superview, topattribute: .top, topConstant: topConstant, leftview: superview, leftattribute: .leading, leftConstant: leftConstant, bottomview: superview, bottomattribute: .bottom, bottomConstant: bottomConstant, rightview: superview, rightattribute: .trailing, rightConstant: rightConstant, widthConstant: widthconstant, heightConstant: heightConstant)
        }
    }
    
    func anchorWithConstantsToTop8(_ topview: UIView? = nil, leftview: UIView? = nil, bottomview: UIView? = nil, rightview: UIView? = nil,topattribute:NSLayoutConstraint.Attribute? = nil,leftattribute:NSLayoutConstraint.Attribute? = nil,bottomattribute:NSLayoutConstraint.Attribute? = nil,rightattribute:NSLayoutConstraint.Attribute? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor8(topview, topattribute: topattribute, topConstant: topConstant, leftview: leftview,leftattribute: leftattribute,leftConstant: leftConstant,bottomview: bottomview,bottomattribute: bottomattribute, bottomConstant: bottomConstant, rightview: rightview, rightattribute: rightattribute, rightConstant: rightConstant)
    }
    
    
    func anchor8(_ topview: UIView? = nil,topattribute:NSLayoutConstraint.Attribute? = nil, topConstant: CGFloat = 0,leftview: UIView? = nil,leftattribute:NSLayoutConstraint.Attribute? = nil, leftConstant: CGFloat = 0,bottomview: UIView? = nil,bottomattribute:NSLayoutConstraint.Attribute? = nil,bottomConstant: CGFloat = 0, rightview: UIView? = nil,rightattribute:NSLayoutConstraint.Attribute? = nil,  rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let topview = topview{
            
            if let topattreibute = topattribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.top,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: topview,
                                                  attribute: topattreibute,
                                                  multiplier: 1.0,
                                                  constant: topConstant))
            }
            
        }
        
        
        if let leftview = leftview{
            
            if let leftattreibute = leftattribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.leading,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: leftview,
                                                  attribute: leftattreibute,
                                                  multiplier: 1.0,
                                                  constant: leftConstant))
            }
            
        }
        
        
        if let rightview = rightview{
            
            if let rightattribute = rightattribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.trailing,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: rightview,
                                                  attribute: rightattribute,
                                                  multiplier: 1.0,
                                                  constant: -rightConstant))
            }
            
        }
        
        if let bottomview = bottomview{
            
            if let bottomattribute = bottomattribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: bottomview,
                                                  attribute: bottomattribute,
                                                  multiplier: 1.0,
                                                  constant: -bottomConstant))
            }
            
        }
        
        if widthConstant > 0{
            
            anchors.append(NSLayoutConstraint(item: self,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              multiplier: 1.0,
                                              constant: widthConstant))
            
            
        }
        
        if heightConstant > 0{
            
            anchors.append(NSLayoutConstraint(item: self,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              multiplier: 1.0,
                                              constant: heightConstant))
            
            
        }
        NSLayoutConstraint.activate(anchors)
        
        return anchors
    }
    
    
    
    
    func anchor8_(_ topview: UIView? = nil,topattribute:NSLayoutConstraint.Attribute? = nil,currentViewTopAttribute:NSLayoutConstraint.Attribute? = nil,topConstant: CGFloat = 0,leftview: UIView? = nil,leftattribute:NSLayoutConstraint.Attribute? = nil,currentViewleftAttribute:NSLayoutConstraint.Attribute? = nil, leftConstant: CGFloat = 0,bottomview: UIView? = nil,bottomattribute:NSLayoutConstraint.Attribute? = nil,currentViewbottomAttribute:NSLayoutConstraint.Attribute? = nil,bottomConstant: CGFloat = 0, rightview: UIView? = nil,rightattribute:NSLayoutConstraint.Attribute? = nil,currentViewrightAttribute:NSLayoutConstraint.Attribute? = nil ,rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let topview = topview{
            
            if let topattreibute = topattribute,let currentViewTopAttribute = currentViewTopAttribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: currentViewTopAttribute,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: topview,
                                                  attribute: topattreibute,
                                                  multiplier: 1.0,
                                                  constant: topConstant))
            }
            
        }
        
        
        if let leftview = leftview{
            
            if let leftattreibute = leftattribute,let currentViewleftAttribute = currentViewleftAttribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: currentViewleftAttribute,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: leftview,
                                                  attribute: leftattreibute,
                                                  multiplier: 1.0,
                                                  constant: leftConstant))
            }
            
        }
        
        
        if let rightview = rightview{
            
            if let rightattribute = rightattribute , let currentViewrightAttribute = currentViewrightAttribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: currentViewrightAttribute,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: rightview,
                                                  attribute: rightattribute,
                                                  multiplier: 1.0,
                                                  constant: -rightConstant))
            }
            
        }
        
        if let bottomview = bottomview{
            
            if let bottomattribute = bottomattribute , let currentViewbottomAttribute = currentViewbottomAttribute{
                anchors.append(NSLayoutConstraint(item: self,
                                                  attribute: currentViewbottomAttribute,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: bottomview,
                                                  attribute: bottomattribute,
                                                  multiplier: 1.0,
                                                  constant: -bottomConstant))
            }
            
        }
        
        if widthConstant > 0{
            
            anchors.append(NSLayoutConstraint(item: self,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              multiplier: 1.0,
                                              constant: widthConstant))
            
            
        }
        
        if heightConstant > 0{
            
            anchors.append(NSLayoutConstraint(item: self,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              multiplier: 1.0,
                                              constant: heightConstant))
            
            
        }
        NSLayoutConstraint.activate(anchors)
        
        return anchors
    }
    
    
    func CenterX(_ toview:UIView,Constant:CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: self , attribute: .centerX, relatedBy: .equal, toItem: toview, attribute: .centerX, multiplier: 1, constant: Constant)])
        
    }
    
    func CenterY(_ toview:UIView,Constant:CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: self , attribute: .centerY, relatedBy: .equal, toItem: toview, attribute: .centerY, multiplier: 1, constant: Constant)])
    }
    
    func Center(_ toview:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        CenterX(toview, Constant: 0)
        CenterY(toview, Constant: 0)
    }
    
}






