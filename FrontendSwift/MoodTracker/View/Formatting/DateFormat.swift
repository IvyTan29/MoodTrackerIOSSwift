//
//  DateFormatter.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation

struct DateFormat {
    static let dateFormatter = DateFormatter()
    static let dateIntervalFormatter = DateIntervalFormatter()
    static let iSO8601DateFormatter = ISO8601DateFormatter()
    
    static func dateFormatToString(format: String, date: Date) -> String {
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    static func stringFormatToDate(format: String, dateStr: String) -> Date {
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: dateStr) ?? Date()
    }
    
    static func dateIntervalToString(from: Date, to: Date) -> String {
        dateIntervalFormatter.timeStyle = .none
        dateIntervalFormatter.dateStyle = .medium
        
        return dateIntervalFormatter.string(from: from, to: to)
    }
    
    static func ISOToDate(dateStr: String) -> Date {
        iSO8601DateFormatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
        
        return iSO8601DateFormatter.date(from: dateStr) ?? Date()
    }
    
    static func ISOToString(date: Date) -> String {
        iSO8601DateFormatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
        
        return iSO8601DateFormatter.string(from: date)
    }
}
