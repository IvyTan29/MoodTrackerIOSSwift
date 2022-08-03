//
//  User.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

struct User : Codable {
    var _id: String?
    var name: String
    var email: String
    var password: String
    var entries: [String]
    var tags: [String]
}
