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
    case let editorDateLevelAction as EditorDateLevelAction:
        state?.editorMood?.dateTime = editorDateLevelAction.dateTime
        state?.editorMood?.moodValue = editorDateLevelAction.moodValue
        
        
    case let editorTagsAction as EditorTagsAction:
        let chosenTags = state?.chosenTags
        
        state?.editorMood?.tags = chosenTags
        
    case let editorNoteAction as EditorNoteAction:
        state?.editorMood?.note = editorNoteAction.note
        if let index = editorNoteAction.index {
            state?.moodList[index.row].note = editorNoteAction.note
        }
        
        
    case _ as InitializeTagAction:
        let recentKeys = state?.tagsDict.filter({ $0.value == true }).keys
        let tableKeys = state?.tagsDict.filter({ $0.value == false }).keys
        
        state?.recentTags = Set(recentKeys!)
        state?.tableTags = Set(tableKeys!)
        
        
    case let initializeTagsEditAction as InitializeTagsEditAction:
        let recentTags = state?.recentTags
        let tableTags = state?.tableTags
        
        print(tableTags)
        let chosenTags = state?.moodList[initializeTagsEditAction.index.row].tags ?? []
        
        state?.recentTags = recentTags?.subtracting(chosenTags) ?? []
        state?.tableTags = tableTags?.subtracting(chosenTags) ?? []
        state?.chosenTags = chosenTags
        
        print(tableTags)
        print("GET edit tags")
        
        
    case let deleteTagAction as DeleteTagAction:
        state?.chosenTags.remove(deleteTagAction.tagStr)
        
        let isRecent = state?.tagsDict[deleteTagAction.tagStr] ?? true
        
        if isRecent {
            state?.recentTags.insert(deleteTagAction.tagStr)
        } else {
            state?.tableTags.insert(deleteTagAction.tagStr)
        }
        
    
    case let addTagAction as AddTagAction:
        state?.recentTags.remove(addTagAction.tagStr)
        state?.tableTags.remove(addTagAction.tagStr)
        state?.chosenTags.insert(addTagAction.tagStr)
        
        print("TEst : \(addTagAction.tagStr)")
        
        
    case _ as AddMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.moodList.append(moodLog)
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let editAction as EditMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.moodList[editAction.index.row] = moodLog
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let deleteAction as DeleteMoodAction:
        state?.moodList.remove(at: deleteAction.index.row)
        
        
    default:
        break
    }

    return state ?? MoodState()
}
