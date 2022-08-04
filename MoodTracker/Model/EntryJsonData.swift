//
//  EntryJsonData.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

//struct EntryJsonData : Decodable {
//    let entry: Entry
//}

struct EntryJsonData : Codable {
    let _id: String?
    let dateTime: String
    let moodValue: Float
    let tags: [TagJsonData]
    let note: String?
}

struct TagJsonData : Codable {
    let _id: String?
    let name: String
    let dateTime: String
//    let required: Bool
}
