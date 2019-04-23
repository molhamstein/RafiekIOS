//
//  Dirction.swift
//  Al-Rafik
//
//  Created by Nour  on 4/23/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

class Direction:BaseModel{
    public var up : String?
    public var left : String?
    public var right : String?
    public var down : String?
    
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        up = json["up"].string
        left = json["left"].string
        right = json["right"].string
        down = json["down"].string
    }
    
    override func dictionaryRepresentation() -> [String : Any] {
        let dictionary = super.dictionaryRepresentation()
        return dictionary
    }
    
    
}


