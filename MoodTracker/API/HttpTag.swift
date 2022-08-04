//
//  HttpTag.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/4/22.
//

import Foundation

protocol HttpTagDelegate : AnyObject {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<String>)
}

extension HttpTagDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<String>) {
        // leave empty
    }
}

struct HttpTag {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    weak var delegate: HttpTagDelegate?
    
    func addTagsToUserAndEntryHttp(_ entryId: String, _ tagList: [Tag]) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries/\(entryId)\tags",
            httpMethod: "POST",
            jsonData: encodeTagList(tagList)) { data, response, error in
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
    }
    
    func getRecentTagsHttp() {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/recent/tags",
            httpMethod: "GET",
            jsonData: nil) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if let recentTags = decodeTagList(data) {
                        delegate?.didGetRecentTags(response.statusCode, recentTags)
                    }
                }
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
    
    func decodeTagList(_ data: Data) -> Set<String>? {
        var tagStrSet = Set<String>()
        
        do {
            let decodedData = try decoder.decode([TagJsonData].self, from: data)
            
            decodedData.forEach({ item in
                tagStrSet.insert(item._id ?? "")
            })
            
            return tagStrSet
        } catch {
            print(error)
            return nil
        }
    }
}
