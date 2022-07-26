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


struct InitializeTagAction : Action {
    
}

struct InitializeTagsEditAction : Action {
    var index: IndexPath
}

struct DeleteTagAction : Action {
    var tagStr: String
}

struct AddTagAction : Action {
    var tagStr: String
}

//struct AddTagToTableAction : Action {
//    var tagStr: String
//}

struct AddMoodAction : Action {
    
}

struct EditMoodAction : Action {
    var index: IndexPath
}

struct DeleteMoodAction : Action {
    var index: IndexPath
}
