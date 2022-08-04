//
//  HttpTag.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/4/22.
//

import Foundation

protocol HttpTagDelegate : AnyObject {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<Tag>)
    
    func didAddTags(_ statusCode: Int, _ strData: String)
}

extension HttpTagDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<Tag>) {
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
    
    func postTagsToUserAndEntryHttp(_ entryId: String, _ tagSet: Set<Tag>) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entry/\(entryId)/tags",
            httpMethod: "POST",
            jsonData: encodeTagSet(tagSet)) { data, response, error in
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
                    if let recentTags = decodeTagRecent(data) {
                        delegate?.didGetRecentTags(response.statusCode, recentTags)
                    }
                }
            }
    }
    
    func encodeTagSet(_ tagSet: Set<Tag>) -> Data? {
        do {
            return try encoder.encode(tagSet)
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeTagRecent(_ data: Data) -> Set<Tag>? {
        var tagSet = Set<Tag>()
        
        do {
            let decodedData = try decoder.decode([TagGroupJsonData].self, from: data)
            
            decodedData.forEach({ item in
                tagSet.insert(
                    Tag(name: item._id,
                        recent: 1
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
