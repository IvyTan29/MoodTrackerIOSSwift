//
//  HttpEntry.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

protocol HttpEntryDelegate : AnyObject {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog])
    
    func didAddEntry(_ statusCode: Int, _ entryId: String)
}

extension HttpEntryDelegate {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog]) {
        // leave empty
    }
    
    func didAddEntry(_ statusCode: Int, _ entryId: String) {
        // leave empty
    }
}

struct HttpEntry {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    weak var delegate: HttpEntryDelegate?
    
    func getEntriesOfUserHTTP() {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries",
            httpMethod: "GET",
            jsonData: nil) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if let entries = decodeEntries(data) {
                        delegate?.didGetEntries(response.statusCode, entries)
                    }
                }
            }
    }
    
    func postEntryHTTP(_ entry: MoodLog) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries",
            httpMethod: "POST",
            jsonData: encodeEntry(entry)) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if let entryId = decodeAnEntry(data) {
                        delegate?.didAddEntry(response.statusCode, entryId)
                    }
                }
            }
    }
    
    func decodeEntries(_ data: Data) -> [MoodLog]? {
        var moodLogs = [MoodLog]()
        
        do {
            let decodedData = try decoder.decode([EntryJsonData].self, from: data)
            
            decodedData.forEach({ item in
                
                do {
                    let note = try item.note
                    
                    moodLogs.append(MoodLog(
                        id: item._id,
                        dateTime: DateFormat.ISOToDate(dateStr: item.dateTime),
                        moodValue: item.moodValue,
                        tags: self.getTagString(item.tags),
                        note: note)
                    )
                } catch {
                    print(error)
                    moodLogs.append(MoodLog(
                        id: item._id,
                        dateTime: DateFormat.ISOToDate(dateStr: item.dateTime),
                        moodValue: item.moodValue,
                        tags: self.getTagString(item.tags))
                    )
                }
            })
            
            return moodLogs
        } catch {
            print(error)
            return nil
        }
    }
    
    func getTagString(_ tags: [TagJsonData]) -> Set<String> {
        var tagStr = Set<String>()
        
        tags.forEach({ tagItem in
            tagStr.insert(tagItem.name)
        })
        
        return tagStr
    }
    
    func encodeEntry(_ moodLog: MoodLog) -> Data? {
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            return try encoder.encode(moodLog)
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeAnEntry(_ data: Data) -> String? {
        do {
            let decodedData = try decoder.decode(EntryJsonData.self, from: data)
            
            return decodedData._id
        } catch {
            print(error)
            return nil
        }
    }
}
