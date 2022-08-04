//
//  HttpTag.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/4/22.
//

import Foundation

protocol HttpTagDelegate : AnyObject {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<Tag>)
    
    func didGetTableTags(_ statusCode: Int, _ tags: Set<Tag>)
    
    func didAddTags(_ statusCode: Int, _ strData: String)
}

extension HttpTagDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<Tag>) {
        // leave empty
    }
    
    func didGetTableTags(_ statusCode: Int, _ tags: Set<Tag>) {
        // leave empty
    }
    
    func didAddTags(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
}

struct HttpTag {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    weak var delegate: HttpTagDelegate?
    
    func postTagsToUserAndEntryHttp(_ entryId: String, _ tagArray: [TagJsonData]) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entry/\(entryId)/tags",
            httpMethod: "POST",
            jsonData: encodeTagSet(tagArray)) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didAddTags(response.statusCode, String(data: data, encoding: .utf8) ?? "")
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
                    if let recentTags = decodeTag(data, 1) {
                        delegate?.didGetRecentTags(response.statusCode, recentTags)
                    }
                }
            }
    }
    
    func getTableTagsHttp() {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/table/tags",
            httpMethod: "GET",
            jsonData: nil) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if let tableTags = decodeTag(data, 0) {
                        delegate?.didGetTableTags(response.statusCode, tableTags)
                    }
                }
            }
    }
    
    func encodeTagSet(_ tagArray: [TagJsonData]) -> Data? {
        do {
            return try encoder.encode(tagArray)
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeTag(_ data: Data, _ recent: Int) -> Set<Tag>? {
        var tagSet = Set<Tag>()
        
        do {
            let decodedData = try decoder.decode([TagGroupJsonData].self, from: data)
            
            decodedData.forEach({ item in
                tagSet.insert(
                    Tag(name: item._id,
                        recent: recent
                       )
                )
            })
            
            return tagSet
        } catch {
            print(error)
            return nil
        }
    }
}
