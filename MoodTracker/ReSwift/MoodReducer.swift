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
        
        
    case let initRecentTagAction as InitializeRecentTagAction:
        state?.recentTags = initRecentTagAction.recentTags
        
    case let initTableTagAction as InitializeTableTagAction:
        state?.tableTags = initTableTagAction.tableTags
        
        
    case let initializeTagsEditAction as InitializeTagsEditAction:
        let recentTags = state?.recentTags
        let tableTags = state?.tableTags
        
        let chosenTags = state?.allMoodList[initializeTagsEditAction.index.row].tags ?? []
        
        state?.recentTags = recentTags?.subtracting(chosenTags) ?? []
        state?.tableTags = tableTags?.subtracting(chosenTags) ?? []
        state?.chosenTags = chosenTags
        
        
    case let deleteTagAction as DeleteTagAction:
        state?.chosenTags.remove(deleteTagAction.tag)
        
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
        
    
    case let getInsightsAction as GetInsightsAction:
        state?.insightTags = [:] // reset
        var count = [String: Int]()
        
        let floorVal = floor(getInsightsAction.moodLevel)
        let ceilVal = ceil(getInsightsAction.moodLevel)
        
        switch getInsightsAction.insightDateType {
        case 0: // this week
//            let insightsResult = state?.allMoodList.filter({
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: Date(),
//                                        toGranularity: .weekOfYear) &&
//                ($0.moodValue ?? -5.00) >= floorVal &&
//                ($0.moodValue ?? -5.00) <= ceilVal
//            }) ?? []
//
//            // FIXME: - O(n^2) find a way to improve this
//            for mood in insightsResult {
//                mood.tags?.forEach({ count[$0, default: 0] += 1 })
//            }
            break
            
        case 1: // last week
//            let lastWeekDateInSeconds = Date().timeIntervalSince1970 - (7 * 24 * 60 * 60) // minus a week
//            let lastWeekDate = Date(timeIntervalSince1970: lastWeekDateInSeconds)
//
//            let insightsResult = state?.allMoodList.filter({
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: lastWeekDate,
//                                        toGranularity: .weekOfYear) &&
//                ($0.moodValue ?? -5.00) >= floorVal &&
//                ($0.moodValue ?? -5.00) <= ceilVal
//            }) ?? []
//
//            // FIXME: - O(n^2) find a way to improve this
//            for mood in insightsResult {
//                mood.tags?.forEach({ count[$0, default: 0] += 1 })
//            }
            break
            
        case 2: // last month
//            let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
//
//            let insightsResult = state?.allMoodList.filter({
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: lastMonthDate,
//                                        toGranularity: .month) &&
//                ($0.moodValue ?? -5.00) >= floorVal &&
//                ($0.moodValue ?? -5.00) <= ceilVal
//            }) ?? []
//
//            // FIXME: - O(n^2) find a way to improve this
//            for mood in insightsResult {
//                mood.tags?.forEach({ count[$0, default: 0] += 1 })
//            }
            break
            
        default: // overall
            let insightsResult = state?.allMoodList.filter({
                ($0.moodValue ?? -5.00) >= floorVal &&
                ($0.moodValue ?? -5.00) <= ceilVal
            }) ?? []
            
            // FIXME: - O(n^2) find a way to improve this
//            for mood in insightsResult {
//                mood.tags?.forEach({ count[$0, default: 0] += 1 })
//            }
        }
        
        state?.insightTags = count
        
    
    case let updateEntries as UpdateEntries:
        state?.allMoodList = updateEntries.entriesArray
        
    default:
        break
    }

    return state ?? MoodState()
}
