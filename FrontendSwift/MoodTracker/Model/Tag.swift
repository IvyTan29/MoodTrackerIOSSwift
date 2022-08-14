//
//  Tag.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

struct Tag : Codable, Hashable {
//    var _id : String?
    var name: String
//    var dateTime: Date
//    var moodValue: Float
    var recent: Int
}
