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
            moodList: [
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: -3, tags: ["Work", "Difficult Conversation"], note: nil),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 2, tags: ["Breakfast", "Positive"], note: "Add a note...."),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 0, tags: ["Sleep", "nervous"], note: nil),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 1, tags: ["Sleep", "nervous"], note: "Hey, I'm sad today")
            ],
            editorMood: MoodLog(),
            tagsDict: ["Work" : true,
                       "Difficult Conversation" : true,
                       "Good Meal" : true,
                       "Presentation" : true,
                       "Swimming" : true,
                       "Energized" : true,
                       "Heart Broken" : false,
                       "Sleep" : false,
                       "Nervous" : false,
                       "Breakfast" : false,
                       "Positive" : false,
                       "Dinner" : false,
                       "Lunch" : false,
                       "Exercise" : false,
                       "Study" : false,
                       "Read Book" : false,
                       "Read Webtoon" : false,
                       "Watch Series" : false,
                       "Watch Movie" : false
                     ],
            chosenTags: [],
            recentTags: [],
            tableTags: []
        )
    }
    
    var moodList = [MoodLog]()
    var editorMood: MoodLog?
    var tagsDict: [String: Bool] = [:] // bool marks if it's recent or not
    var chosenTags: Set<String> = []
    var recentTags: Set<String> = []
    var tableTags: Set<String> = []
}

var moodStore = Store<MoodState>.init(reducer: moodReducer, state: MoodState.createInitialState())

