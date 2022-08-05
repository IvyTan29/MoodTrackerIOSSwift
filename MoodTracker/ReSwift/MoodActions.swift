//
//  MoodActions.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import ReSwift

struct EditorDateLevelAction : Action {
    var dateTime: Date
    var moodValue: Float
}

struct EditorTagsAction : Action {
    
}

struct EditorNoteAction : Action {
    var note: String
    var index: IndexPath?
}

struct EditorIdAction : Action {
    var id: String
}

struct InitializeRecentTagAction : Action {
    var recentTags: Set<Tag>
}

struct InitializeTableTagAction : Action {
    var tableTags: Set<Tag>
}

struct InitializeTagsEditAction : Action {
    var index: IndexPath
}

struct DeleteTagAction : Action {
    var tag: Tag
}

struct AddTagAction : Action {
    var tag: Tag
}

struct AddMoodAction : Action {
    
}

struct EditMoodAction : Action {
    var index: IndexPath
}

struct DeleteMoodAction : Action {
    var index: IndexPath
}

struct FilterMoodAction : Action {
    var dateType: DateType
    var date: Date?
}

struct GetInsightsAction : Action {
    var insightDateType: Int
    var moodLevel: Float
}

struct UpdateEntries : Action {
    var entriesArray: [MoodLog]
}
