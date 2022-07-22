//
//  DateFormatter.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation

struct DateFormat {
    static let dateFormatter = DateFormatter()
    
    static func dateFormatToString(format: String, date: Date) -> String {
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
