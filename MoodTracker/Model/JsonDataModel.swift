//
//  JsonDataModel.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

struct UserJsonData : Codable {
    var _id: String?
    var name: String
    var email: String
    var password: String
    var entries: [String]
    var tags: [String]
}

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
    let moodValue: Float
    let recent: Int
}

struct LoginJsonData : Encodable {
    let email: String
    let password: String
}

struct TagGroupJsonData : Codable {
    let _id: String
}
