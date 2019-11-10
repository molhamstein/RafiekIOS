//
//  Command.swift
//  Al-Rafik
//
//  Created by Nour Araar on 11/9/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation

enum VoiceCommandsType: String{
    case bookSearch = "book_search"
    case command = "command"
    case chooseBook = "choose_book"
    case changeLanguage = "change_language"
    case selectCommand = "command_select"
    case selectPage = "choose_page"
    case wrongCommand = "wrong_command"
}

struct VoiceCommand : Codable {
    let _text : String?
    let entities : Entities?
    let msg_id : String?
    
    enum CodingKeys: String, CodingKey {
        case _text = "_text"
        case entities = "entities"
        case msg_id = "msg_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _text = try values.decodeIfPresent(String.self, forKey: ._text)
        entities = try values.decodeIfPresent(Entities.self, forKey: .entities)
        msg_id = try values.decodeIfPresent(String.self, forKey: .msg_id)
    }
    
    var commandType: VoiceCommandsType {
        if let entities = entities , let value = entities.intent?.first?.value{
            let commandType = VoiceCommandsType.init(rawValue: value)
            return commandType ?? .wrongCommand
        }
        return .wrongCommand
    }
    
    var value: String? {
        switch commandType {
        case .bookSearch
                , .chooseBook:
            if let book = entities?.book_number?.first?.value {
                return book
            }
            return nil
        case .command:
            if let value = entities?.command?.first?.value{
                return value
            }
            return nil
        case .changeLanguage:
            if let value = entities?.language?.first?.value{
                return value
            }
            return nil
        case .selectCommand:
            if let value = entities?.command?.first?.value{
                return value
            }
            return nil
        case .selectPage:
            if let value = entities?.page_number?.first?.value {
                return value
            }
            return nil
        case .wrongCommand:
            return nil
        }
    }
}

struct Intent : Codable {
    let confidence : Double?
    let value : String?
    
    enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
}

struct Entities : Codable {
    let page_number : [Page_number]?
    let language : [Language]?
    let command : [Command]?
    let book_number : [Book_number]?
    let intent : [Intent]?
    enum CodingKeys: String, CodingKey {
        case page_number = "page_number"
        case language = "language"
        case command = "command"
        case book_number = "book_number"
        case intent = "intent"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page_number = try values.decodeIfPresent([Page_number].self, forKey: .page_number)
        language = try values.decodeIfPresent([Language].self, forKey: .language)
        command = try values.decodeIfPresent([Command].self, forKey: .command)
        book_number = try values.decodeIfPresent([Book_number].self, forKey: .book_number)
        intent = try values.decodeIfPresent([Intent].self, forKey: .intent)
    }
}

struct Command : Codable {
    let confidence : Double?
    let value : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case value = "value"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}

struct Book_number : Codable {
    let confidence : Double?
    let value : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case value = "value"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}


struct Language : Codable {
    let confidence : Double?
    let value : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        
        case confidence = "confidence"
        case value = "value"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}

struct Page_number : Codable {
    let confidence : Double?
    let value : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        
        case confidence = "confidence"
        case value = "value"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}
