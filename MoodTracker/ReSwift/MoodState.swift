//
//  MoodState.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import ReSwift

struct MoodState {
    static func createInitialState() -> MoodState {
        return MoodState(
            list: [
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: -3, tags: ["Work", "Difficult Conversation"], note: nil),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 2, tags: ["Breakfast", "Positive"], note: "Add a note...."),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 0, tags: ["Sleep", "nervous"], note: nil),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 1, tags: ["Sleep", "nervous"], note: nil)
            ]
        )
    }
    
    var list = [MoodLog]()
}
