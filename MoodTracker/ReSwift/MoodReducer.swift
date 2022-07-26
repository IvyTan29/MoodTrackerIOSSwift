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
        state?.editorMood?.tags = editorTagsAction.tags
        
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
        
    case let getTagsEditAction as GetTagsEditAction:
        let keys = state?.tagsDict.filter({ $0.value == true }).keys
        
        state?.recentTags = Set(keys!)
//        state?.chosenTags = state?.moodList[getTagsEditAction.index.row].tags ?? []
        
//        for tag in state?.chosenTags {
//            state?.recentTags.remove(tag)
//        }
//
        print("GET edit tags")
        print(state?.recentTags)
        print(state?.chosenTags)
        
    case let unpickedTagBtnAction as UnpickedTagBtnAction:
        state?.chosenTags.remove(unpickedTagBtnAction.tagStr)
        state?.recentTags.insert(unpickedTagBtnAction.tagStr)
    
    case let pickedTagBtnAction as PickedTagBtnAction:
        state?.recentTags.remove(pickedTagBtnAction.tagStr)
        state?.chosenTags.insert(pickedTagBtnAction.tagStr)
        
        print(state?.recentTags)
        print(state?.chosenTags)
        print("TEst : \(pickedTagBtnAction.tagStr)")
        
    case _ as AddMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.moodList.append(moodLog)
        state?.editorMood = MoodLog()
        state?.recentTags = []
        state?.chosenTags = []
        
    case let editAction as EditMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.moodList[editAction.index.row] = moodLog
        state?.editorMood = MoodLog()
        state?.recentTags = []
        state?.chosenTags = []
        
    case let deleteAction as DeleteMoodAction:
        state?.moodList.remove(at: deleteAction.index.row)
        
    default:
        break
    }

    return state ?? MoodState()
}
