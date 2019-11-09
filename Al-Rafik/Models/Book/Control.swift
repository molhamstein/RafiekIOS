//
//  Controll.swift
//  Al-Rafik
//
//  Created by Nour  on 4/11/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Control:BaseModel {
    public var content : String?
    public var shapes : [String:[Action]] = [:]
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        content = json["content"].string
        let shapesObj = json["shapes"]
        for (key,value) in shapesObj{
            if let array = value["actions"].array{
                let actions = array.map{ Action(json: $0)}
                shapes[key] = actions
            }
        }
    }
    
    
    override public func dictionaryRepresentation() -> [String : Any] {
        let dictionary = super.dictionaryRepresentation()
        return dictionary
    }

}
