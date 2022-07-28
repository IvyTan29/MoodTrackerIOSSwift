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
            state?.allMoodList[index.row].note = editorNoteAction.note
        }
        
        
    case _ as InitializeTagAction:
        let recentKeys = state?.tagsDict.filter({ $0.value == true }).keys
        let tableKeys = state?.tagsDict.filter({ $0.value == false }).keys
        
        state?.recentTags = Set(recentKeys!)
        state?.tableTags = Set(tableKeys!)
        
        
    case let initializeTagsEditAction as InitializeTagsEditAction:
        let recentTags = state?.recentTags
        let tableTags = state?.tableTags
        
        let chosenTags = state?.allMoodList[initializeTagsEditAction.index.row].tags ?? []
        
        state?.recentTags = recentTags?.subtracting(chosenTags) ?? []
        state?.tableTags = tableTags?.subtracting(chosenTags) ?? []
        state?.chosenTags = chosenTags
        
        
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
        
        
    case _ as AddMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.allMoodList.append(moodLog)
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let editAction as EditMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.allMoodList[editAction.index.row] = moodLog
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let deleteAction as DeleteMoodAction:
        state?.allMoodList.remove(at: deleteAction.index.row)
        
    
    case let filterMoodAction as FilterMoodAction:
        var filterResult: [MoodLog] = []
        
        switch filterMoodAction.dateType {
        case .dayControl:
            filterResult = state?.allMoodList.filter({
                Calendar.current.isDate($0.dateTime ?? Date(),
                                        equalTo: filterMoodAction.date ?? Date(),
                                        toGranularity: .day)
            }) ?? []
            
        case .weekControl:
            print("WEEK")
            filterResult = state?.allMoodList.filter({
                Calendar.current.isDate($0.dateTime ?? Date(),
                                        equalTo: filterMoodAction.date ?? Date(),
                                        toGranularity: .weekOfYear)
            }) ?? []
            
        case .monthControl:
            filterResult = state?.allMoodList.filter({
                Calendar.current.isDate($0.dateTime ?? Date(),
                                        equalTo: filterMoodAction.date ?? Date(),
                                        toGranularity: .month) &&
                Calendar.current.isDate($0.dateTime ?? Date(),
                                        equalTo: filterMoodAction.date ?? Date(),
                                        toGranularity: .year)
            }) ?? []
            
        default: //all
            filterResult = state?.allMoodList ?? []
        }
        
        state?.dateTypeFilter = filterMoodAction.dateType
        state?.dateFilter = filterMoodAction.date ?? Date()
        state?.filterMoodList = filterResult
        
        print(state?.filterMoodList)
        
        
    default:
        break
    }

    return state ?? MoodState()
}
