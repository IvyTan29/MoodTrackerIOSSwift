//
//  MoodLog.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation

struct MoodLog : Codable {
    var id: String?
    var dateTime: Date?
    var moodValue: Float?
    var tags: Set<Tag>?
    var note: String?
}
