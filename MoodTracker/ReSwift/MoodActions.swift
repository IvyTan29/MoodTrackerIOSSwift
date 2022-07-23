//
//  MoodActions.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import ReSwift

struct AddMoodAction : Action {
    var mood: MoodLog
}

struct EditMoodAction : Action {
    var mood: MoodLog
}

struct EditorMoodFinalAction : Action {
    // var mood: MoodLog
    var index: IndexPath
}

struct DeleteMoodAction : Action {
    var index: IndexPath
}
