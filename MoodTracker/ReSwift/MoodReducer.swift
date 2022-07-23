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

    switch action {
    case let addAction as AddMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        state?.moodList.append(moodLog)
        
    case let editAction as EditMoodAction:
        state?.editorMood = editAction.mood
        
    case let editorFinalAction as EditorMoodFinalAction:
        let moodLog = state?.editorMood ?? MoodLog()
        state?.moodList[editorFinalAction.index.row] = moodLog
        
    case let deleteAction as DeleteMoodAction:
        state?.moodList.remove(at: deleteAction.index.row)
        
    default:
        break
    }

    return state ?? MoodState()
}
