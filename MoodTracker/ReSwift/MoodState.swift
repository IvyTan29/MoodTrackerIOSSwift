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
            allMoodList: [
                MoodLog(dateTime: Date(), moodValue: -3, tags: ["Work", "Difficult Conversation"], note: nil),
                MoodLog(dateTime: Date().addingTimeInterval(10000), moodValue: 1, tags: ["Breakfast", "Positive"], note: "Add a note...."),
                MoodLog(dateTime: Date() - 7 * 24*60*60, moodValue: 0, tags: ["Sleep", "Nervous"], note: nil),
                MoodLog(dateTime: Date().advanced(by: 24*60*60), moodValue: 1, tags: ["Sleep", "Nervous"], note: "Hey, I'm sad today"),
                MoodLog(dateTime: ISO8601DateFormatter().date(from: "2021-12-08T10:44:00+0000"), moodValue: 1, tags: ["Sleep", "Nervous"], note: "it's my birthday XD..."),
                MoodLog(dateTime: ISO8601DateFormatter().date(from: "2020-12-08T10:44:00+0000"), moodValue: 0, tags: ["Sleep", "Hate"], note: "testing WOAHH"),
                MoodLog(dateTime: ISO8601DateFormatter().date(from: "2022-07-23T10:44:00+0000"), moodValue: 0, tags: ["07-23"], note: "testing WOAHH"),
                MoodLog(dateTime: ISO8601DateFormatter().date(from: "2022-07-16T10:44:00+0000"), moodValue: 0, tags: ["07-16"], note: "testing WOAHH")
            ],
            filterMoodList: [],
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
            tableTags: [],
            dateTypeFilter: .dayControl,
            dateFilter: Date(),
            insightTags: [:]
        )
    }
    
    var allMoodList = [MoodLog]()
    var filterMoodList = [MoodLog]()
    var editorMood: MoodLog?
    var tagsDict = [String: Bool]() // bool marks if it's recent or not
    var chosenTags: Set<String> = []
    var recentTags: Set<String> = []
    var tableTags: Set<String> = []
    var dateTypeFilter: DateType = .dayControl
    var dateFilter: Date = Date()
    var insightTags = [String: Int]()
}

var moodStore = Store<MoodState>.init(reducer: moodReducer, state: MoodState.createInitialState())

