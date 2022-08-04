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
            allMoodList: [],
            filterMoodList: [],
            editorMood: MoodLog(),
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
    var chosenTags: Set<Tag> = []
    var recentTags: Set<Tag> = []
    var tableTags: Set<Tag> = []
    var dateTypeFilter: DateType = .dayControl
    var dateFilter: Date = Date()
    var insightTags = [String: Int]()
}

var moodStore = Store<MoodState>.init(reducer: moodReducer, state: MoodState.createInitialState())

