//
//  MoodActions.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import ReSwift

struct AddMoodAction : Action {
//    var mood: MoodLog
}

struct EditorDateLevelAction : Action {
    var dateTime: Date?
    var moodValue: Float?
}

struct EditorTagsAction : Action {
    var tags: Set<String>?
}

struct EditorNoteAction : Action {
    var note: String?
}

struct EditMoodAction : Action {
    // var mood: MoodLog
    var index: IndexPath
}

struct DeleteMoodAction : Action {
    var index: IndexPath
}
