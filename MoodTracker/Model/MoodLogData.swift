//
//  MoodLogData.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation

struct MoodLogData {
    
    static let moodLogs = [
        MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: -3, tags: ["Work", "Difficult Conversation"], note: nil),
        MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 2, tags: ["Breakfast", "Positive"], note: "Add a note...."),
        MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 0, tags: ["Sleep", "nervous"], note: nil)
    ]
}
