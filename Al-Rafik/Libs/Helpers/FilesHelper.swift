//
//  FilesHelper.swift
//  Al-Rafik
//
//  Created by Nour  on 4/5/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

class FileHelper{
    
    static let fileManager = FileManager.default
    
    static func documentPath() -> URL{
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    }
    
    static func filePathMainBundel(file:String,ext:String) -> URL?{
        return Bundle.main.url(forResource: file, withExtension: ext)
    }
    
    static func filePathURL(fileId:String)-> URL?{
        return URL(fileURLWithPath: "http://104.217.253.15:3000/api/books/download/\(fileId)")
    }
    
    
    static func document(filePath:String) -> String{
        return documentPath().appendingPathComponent(filePath).path
    }
    
    static func listFilesFromDocumentsFolder(folder:String) -> [String]{
        let fileURL = document(filePath: folder)
        do {
            let files = try fileManager.contentsOfDirectory(atPath: fileURL)
            return files
        }catch{
            print(error)
            return []
        }
    }
    static func isExists(filePath:String) -> Bool{
        return fileManager.fileExists(atPath: filePath)
    }
    
    static func getAudiofilePath(folder:String,file:String) ->URL?{
        let fileURLString = document(filePath: folder)
        if isExists(filePath: fileURLString){
            let path = "\((fileURLString))/\(file)"
            return URL(string: path)
        }
        return nil
    }
    
    static func readBookData(folder:String,file:String) -> Data?{
        let fileURLString = document(filePath: folder)
        if isExists(filePath: fileURLString){
            do {
                let path = "\((fileURLString))/\(file)"
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    static func readBookJSON(folder:String,file:String) -> JSON?{
        do {
            if let data = readBookData(folder: folder, file: file){
                let jsonObj = try JSON(data: data)
                print(jsonObj)
                return jsonObj
            }
        } catch let error {
            print("parse error: \(error.localizedDescription)")
        }
        return nil
    }
}
