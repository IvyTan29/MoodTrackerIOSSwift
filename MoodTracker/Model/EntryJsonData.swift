//
//  EntryJsonData.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

struct EntryJsonData : Decodable {
    let entry: Entry
}

struct Entry : Codable {
    let _id: String?
    let dateTime: String
    let moodValue: Float
    let tags: Set<String>
    let note: String?
}
