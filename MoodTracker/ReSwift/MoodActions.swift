//
//  MoodActions.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import ReSwift

struct EditorDateLevelAction : Action {
    var dateTime: Double
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

struct UpdateEntriesAction : Action {
    var entriesArray: [MoodLog]
    var dateType: DateType
    var date: Date
}

struct StoreJWTAction : Action {
    var jwt: String
}
