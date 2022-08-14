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
            filterMoodList: [],
            editorMood: MoodLog(),
            chosenTags: [],
            recentTags: [],
            tableTags: [],
            dateTypeFilter: .dayControl,
            dateFilter: Date(),
            jwtClient: ""
        )
    }
    
    var filterMoodList = [MoodLog]()
    var editorMood: MoodLog?
    var chosenTags: Set<Tag> = []
    var recentTags: Set<Tag> = []
    var tableTags: Set<Tag> = []
    var dateTypeFilter: DateType = .dayControl
    var dateFilter: Date = Date()
    var jwtClient: String?
}

var moodStore = Store<MoodState>.init(reducer: moodReducer, state: MoodState.createInitialState())

