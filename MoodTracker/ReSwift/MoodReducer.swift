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
        print("REDUCER \(state?.chosenTags)")
        print(deleteTagAction.tag)
        state?.chosenTags.remove(deleteTagAction.tag)
        
        let removedChosenTags = state?.chosenTags.filter { $0.name != deleteTagAction.tag.name}
        state?.chosenTags = removedChosenTags ?? []
        print("REDUCER \(state?.chosenTags)")
        
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
            
            var moodLog = state?.editorMood ?? MoodLog()
            moodLog.tags = state?.chosenTags
            
            state?.filterMoodList.append(moodLog)
            
        } else if (state?.dateTypeFilter == .monthControl &&
                    Calendar.current.isDate(
                        state?.editorMood?.dateTime ?? Date(),
                        equalTo: state?.dateFilter ?? Date(),
                        toGranularity: .month) &&
                    Calendar.current.isDate(
                        state?.editorMood?.dateTime ?? Date(),
                        equalTo: state?.dateFilter ?? Date(),
                        toGranularity: .year)) {
            
            var moodLog = state?.editorMood ?? MoodLog()
            moodLog.tags = state?.chosenTags
            
            state?.filterMoodList.append(moodLog)
            
        } else if (Calendar.current.isDate(
            state?.editorMood?.dateTime ?? Date(),
            equalTo: state?.dateFilter ?? Date(),
            toGranularity: granularity)) {
            
            var moodLog = state?.editorMood ?? MoodLog()
            moodLog.tags = state?.chosenTags
            
            state?.filterMoodList.append(moodLog)
        }
        
        
        // reset editor values
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let editAction as EditMoodAction:
        let moodLog = state?.editorMood ?? MoodLog()
        
        state?.filterMoodList[editAction.index.row] = moodLog
        state?.editorMood = MoodLog()
        state?.chosenTags = []
        
        
    case let deleteAction as DeleteMoodAction:
        state?.filterMoodList.remove(at: deleteAction.index.row)
        
    
//    case let filterMoodAction as FilterMoodAction:
//        var filterResult: [MoodLog] = []
//
//        switch filterMoodAction.dateType {
//        case .dayControl:
//            break
//            filterResult = state?.allMoodList.filter({
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: filterMoodAction.date ?? Date(),
//                                        toGranularity: .day)
//            }) ?? []
            
//        case .weekControl:
//            break
//            filterResult = state?.allMoodList.filter({
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: filterMoodAction.date ?? Date(),
//                                        toGranularity: .weekOfYear)
//            }) ?? []
            
//        case .monthControl:
//            break
//            filterResult = state?.allMoodList.filter({
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: filterMoodAction.date ?? Date(),
//                                        toGranularity: .month) &&
//                Calendar.current.isDate($0.dateTime ?? Date(),
//                                        equalTo: filterMoodAction.date ?? Date(),
//                                        toGranularity: .year)
//            }) ?? []
            
//        default: //all
//            break
//            filterResult = state?.allMoodList ?? []
//        }
        
    
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
            break
//            let insightsResult = state?.filterMoodList.filter({
//                ($0.moodValue ?? -5.00) >= floorVal &&
//                ($0.moodValue ?? -5.00) <= ceilVal
//            }) ?? []
            
            // FIXME: - O(n^2) find a way to improve this
//            for mood in insightsResult {
//                mood.tags?.forEach({ count[$0, default: 0] += 1 })
//            }
        }
        
        state?.insightTags = count
        
    
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
