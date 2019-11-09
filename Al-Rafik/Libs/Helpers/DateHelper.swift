//
//  DateHelper.swift
//  BrainSocket Code base
//
//  Created by BrainSocket on 12/25/16.
//  Copyright © 2016 . All rights reserved.
//
import UIKit

// MARK: Date helper
struct DateHelper {
    
    /// Get date from iso string
    static func getDateFromISOString(_ dateStr: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let loc = Locale(identifier: "us")
        dateFormater.locale = loc
        return dateFormater.date(from: dateStr)
    }
    
    /// Get iso date string from date object
    static func getISOStringFromDate(_ date: Date) -> String? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let loc = Locale(identifier: "us")
        dateFormater.locale = loc
        return dateFormater.string(from: date)
    }

    /// Get date from  string
    static func getDateFromString(_ dateStr: String) -> Date? {
        let dateFormater = DateFormatter()
        let loc = Locale(identifier: "us")
        dateFormater.locale = loc
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.date(from: dateStr)
    }


    /// Get  date string from date object
    static func getStringFromDate(_ date: Date) -> String? {
        let dateFormater = DateFormatter()
        let loc = Locale(identifier: "us")
        dateFormater.locale = loc
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: date)
    }
    
    static func getBirthFormatedStringFromDate(_ date: Date) -> String? {
        let dateFormater = DateFormatter()
        let loc = Locale(identifier: "us")
        dateFormater.locale = loc
        dateFormater.dateFormat = "dd MMM yyyy"
        return dateFormater.string(from: date)
    }
    
    static func getBirthDateFromString(_ dateStr: String) -> Date? {
        let dateFormater = DateFormatter()
        let loc = Locale(identifier: "us")
        dateFormater.locale = loc
        dateFormater.dateFormat = "dd MMM yyyy"
        return dateFormater.date(from: dateStr)
    }
    
    /// Get iso date string from date object
    static func getISOStringFromTimestamp(_ timestamp: Double) -> String? {
        let timestampDate = NSDate(timeIntervalSince1970: Double(timestamp as NSNumber)/1000)
        return getISOStringFromDate(timestampDate as Date)
    }
    
    
    static func getDayFrom(date:Date) -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        return dayInWeek
    }
    
    static func getDayNumberFrom(date:Date) ->Int{
        let dayNumber = Calendar.current.component(.weekday, from: date)
        return dayNumber
    }
    
   
}
