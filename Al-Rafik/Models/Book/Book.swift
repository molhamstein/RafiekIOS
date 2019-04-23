//
//  Book.swift
//  Al-Rafik
//
//  Created by Nour  on 4/5/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON


class Book:BaseModel{
    
    public var bId : String?
    public var name_en : String?
    public var name_ar : String?
    public var description_en : String?
    public var description_ar : String?
    public var pages : Array<Page>?
    public var control : Control?
    
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        bId = json["id"].string
        if let array =  json["pages"].array{
            pages = array.map{Page(json: $0)}
        }
        name_en = json["name"]["en"].string
        name_ar = json["name"]["ar"].string
        description_ar = json["description"]["ar"].string
        description_en = json["description"]["en"].string
        if json["control"] != JSON.null{
            control = Control(json: json["control"])
        }
    }
    
    
    override func dictionaryRepresentation() -> [String : Any] {
        let dictionary = super.dictionaryRepresentation()
        return dictionary
    }
}
