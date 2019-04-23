//
//  Page.swift
//  Al-Rafik
//
//  Created by Nour  on 4/5/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import  SwiftyJSON

class Page:BaseModel {

    public var pid : String?
    public var name_en : String?
    public var name_ar : String?
    public var description_en : String?
    public var description_ar : String?
    public var control : Control?
    public var content : String?
    public var shapes : [String:[Action]] = [:]
    public var menu : Array<Action>?
    public var direction : JSON?

    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        content = json["content"].string
        pid = json["id"].string
        let shapesObj = json["shapes"]
        for (key,value) in shapesObj{
            if let array = value["actions"].array{
                let actions = array.map{ Action(json: $0)}
                shapes[key] = actions
            }
        }
        name_en = json["name"]["en"].string
        name_ar = json["name"]["ar"].string
        description_ar = json["description"]["ar"].string
        description_en = json["description"]["en"].string
        if json["control"] != JSON.null{
            control = Control(json: json["control"])
        }
        
        if let array = json["menu"].array {
            menu = array.map{Action(json: $0)}
        }
         direction = json["direction"]
        
    }

    
    override func dictionaryRepresentation() -> [String : Any] {
        let dictionary = super.dictionaryRepresentation()
        return dictionary
    }
}
