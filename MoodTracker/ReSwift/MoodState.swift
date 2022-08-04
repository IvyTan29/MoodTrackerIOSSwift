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
            tagsDict: [:],
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

