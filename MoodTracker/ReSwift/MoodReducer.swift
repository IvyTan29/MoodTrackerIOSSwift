//
//  MoodReducer.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import ReSwift

func moodReducer(action: Action, state: MoodState?) -> MoodState {

    var state = state // state is originally in a let variable
    
    print("HEHEHEH: ", state?.editorMood)

    switch action {
    case let editorDateLevelAction as EditorDateLevelAction:
        state?.editorMood?.dateTime = editorDateLevelAction.dateTime
        state?.editorMood?.moodValue = editorDateLevelAction.moodValue
        
    case let editorTagsAction as EditorTagsAction:
        state?.editorMood?.tags = editorTagsAction.tags
        
    case let editorNoteAction as EditorNoteAction:
        state?.editorMood?.note = editorNoteAction.note
        
    case let addAction as AddMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        state?.moodList.append(moodLog)
        
    case let editAction as EditMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        state?.moodList[editAction.index.row] = moodLog
        
    case let deleteAction as DeleteMoodAction:
        state?.moodList.remove(at: deleteAction.index.row)
        
    default:
        break
    }

    return state ?? MoodState()
}
