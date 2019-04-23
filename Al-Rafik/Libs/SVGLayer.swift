//
//  SVGLayer.swift
//  Al-Rafik
//
//  Created by Nour  on 4/9/19.
//  Copyright © 2019 Nour . All rights reserved.
//


import UIKit
public class SVGLayer:CAShapeLayer{
    
    public var id:String?
    public var counter : Int = 0
    public var layerActions:[Action] = []
    
    func  currentAction()->Action? {
        if layerActions.count > 0 {
            let action = layerActions[counter]
            counter += 1
            if counter >= layerActions.count {
                counter = 0
            }
            
            return action
        }
        return nil
    }
    
}
