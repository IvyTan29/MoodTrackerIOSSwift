//
//  JSONHelper.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

func parseJSONEntry(_ data: Data) -> MoodLog? {
    let decoder = JSONDecoder()

    do {
        let decodedData = try decoder.decode(MoodLog.self, from: data)
        
        // TODO: 
        let moodLog = MoodLog(dateTime: decodedData.dateTime, moodValue: decodedData.moodValue, tags: decodedData.tags, note: decodedData.note)
        
        return moodLog
    } catch {
        // TODO: error
        return nil
    }
}
