//
//  HttpTag.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/4/22.
//

import Foundation


struct HttpTag {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
//    weak
    
    func addTagsToUserAndEntryHttp(_ entryId: String, _ tagList: [Tag]) {
        if let url = URL(string: "\(Server.BASE_URL)/user/entries/\(entryId)\tags") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let json = encodeTagList(tagList)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
            
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
//                    delegate?.didGetEntries(response.statusCode, entries)
//                    if let entries = decodeTags(data) {
//                        delegate?.didGetEntries(response.statusCode, entries)
//                    }
                }
            }
            task.resume()
        }
    }
    
    func encodeTagList(_ tagList: [Tag]) -> Data? {
        do {
            return try encoder.encode(tagList)
        } catch {
            print(error)
            return nil
        }
    }
}
