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
            state?.filterMoodList[index.row].note = editorNoteAction.note
        }
        
    case let editorIdAction as EditorIdAction:
        state?.editorMood?.id = editorIdAction.id
        
        
    case let initRecentTagAction as InitializeRecentTagAction:
        state?.recentTags = initRecentTagAction.recentTags
        
    case let initTableTagAction as InitializeTableTagAction:
        state?.tableTags = initTableTagAction.tableTags
        
        
    case let initializeTagsEditAction as InitializeTagsEditAction:
        let recentTags = state?.recentTags
        let tableTags = state?.tableTags
        
        let chosenTags = state?.filterMoodList[initializeTagsEditAction.index.row].tags ?? []
        
        state?.recentTags = recentTags?.subtracting(chosenTags) ?? []
        state?.tableTags = tableTags?.subtracting(chosenTags) ?? []
        state?.chosenTags = chosenTags
        
        
    case let deleteTagAction as DeleteTagAction:
        state?.chosenTags.remove(deleteTagAction.tag)
        
        let removedChosenTags = state?.chosenTags.filter { $0.name != deleteTagAction.tag.name}
        state?.chosenTags = removedChosenTags ?? []
        
        if deleteTagAction.tag.recent == 1 {
            state?.recentTags.insert(deleteTagAction.tag)
        } else {
            state?.tableTags.insert(deleteTagAction.tag)
        }
        
    
    case var addTagAction as AddTagAction:
        addTagAction.tag.name = addTagAction.tag.name.capitalized
        let inChosen = state?.chosenTags.contains(addTagAction.tag) ?? false
        
        if !inChosen {
            state?.chosenTags.insert(addTagAction.tag)
        }
        
        state?.recentTags.remove(addTagAction.tag)
        state?.tableTags.remove(addTagAction.tag)
        
        
    case _ as AddMoodAction:
        if isPartOfFilter(state) {
            var moodLog = state?.editorMood ?? MoodLog()
            moodLog.tags = state?.chosenTags
            
            state?.filterMoodList.append(moodLog)
        }
        
        // reset editor values
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let editAction as EditMoodAction:
        if isPartOfFilter(state) {
            let moodLog = state?.editorMood ?? MoodLog()
            state?.filterMoodList[editAction.index.row] = moodLog
        } else {
            state?.filterMoodList.remove(at: editAction.index.row)
        }
        
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let deleteAction as DeleteMoodAction:
        state?.filterMoodList.remove(at: deleteAction.index.row)
    
    case let updateEntries as UpdateEntriesAction:
        state?.filterMoodList = updateEntries.entriesArray
        
        state?.dateTypeFilter = updateEntries.dateType
        state?.dateFilter = updateEntries.date
        
    case let storeJWT as StoreJWTAction:
        state?.jwtClient = storeJWT.jwt.replacingOccurrences(of: "\"", with: "")
        
    default:
        break
    }

    return state ?? MoodState()
}

func isPartOfFilter(_ state: MoodState?) -> Bool {
    let granularity = { () -> Calendar.Component in
        switch state?.dateTypeFilter {
        case .dayControl:
            return .day
        case .weekControl:
            return .weekOfYear
        default:
            return .month
        }
    }()
    
    if (state?.dateTypeFilter == .allControl) {
        return true
        
    } else if (state?.dateTypeFilter == .monthControl &&
                Calendar.current.isDate(
                    Date(timeIntervalSince1970: state?.editorMood?.dateTime ?? Date().timeIntervalSince1970),
                    equalTo: state?.dateFilter ?? Date(),
                    toGranularity: .month) &&
                Calendar.current.isDate(
                    Date(timeIntervalSince1970: state?.editorMood?.dateTime ?? Date().timeIntervalSince1970),
                    equalTo: state?.dateFilter ?? Date(),
                    toGranularity: .year)) {
        
        return true
        
    } else if (Calendar.current.isDate(
        Date(timeIntervalSince1970: state?.editorMood?.dateTime ?? Date().timeIntervalSince1970),
        equalTo: state?.dateFilter ?? Date(),
        toGranularity: granularity)) {
        
        return true
    }
    return false
}
