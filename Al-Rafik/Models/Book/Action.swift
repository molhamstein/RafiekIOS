//
//  Book.swift
//  Al-Rafik
//
//  Created by Nour  on 4/5/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON


public class Action:BaseModel{
    
    public var text_ar : String?
    public var text_en : String?
    public var mediaId_ar : String?
    public var mediaId_en : String?
    public var href_en :String?
    public var href_ar :String?
    public var pageId : String?
    public var url:String?
    public var command:String?
    public var type : String?

    public var value:String?{
        switch type {
        case "text":
            return text
        case "audio":
            return mediaId
        case "navigation":
            return pageId
        case "url":
            return url
        case "command":
            return command
        default:
            break
        }
        return nil
    }
    
    
    var text:String?{
        if AppConfig.currentLanguage == .arabic{
            return text_ar
        }
        return text_en
    }
    
    var mediaId:String?{
        if AppConfig.currentLanguage == .arabic{
            return mediaId_ar
        }
        return mediaId_en
    }
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        type = json["type"].string
        text_ar =  json["value"]["ar"]["text"].string
        text_en = json["value"]["en"]["text"].string
        mediaId_en = json["value"]["en"]["mediaId"].string
        mediaId_ar = json["value"]["ar"]["mediaId"].string
        href_en = json["value"]["en"]["href"].string
        href_ar = json["value"]["ar"]["href"].string
        url = json["value"].string
        command = json["value"].string
        pageId = json["value"].string
    }
    
    
    override public func dictionaryRepresentation() -> [String : Any] {
        let dictionary = super.dictionaryRepresentation()
        return dictionary
    }
}
