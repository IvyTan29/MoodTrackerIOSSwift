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
        if let url = URL(string: "\(Server.url)/user/entries") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            task.resume()
        }
    }
    
    func postEntryHTTP(_ entry: MoodLog) {
        if let url = URL(string: "\(Server.url)/user/entries") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let json = encodeEntry(entry)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
            
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            task.resume()
        }
    }
    
    func decodeEntries(_ data: Data) -> [MoodLog]? {
        var moodLogs = [MoodLog]()
        
        do {
            let decodedData = try decoder.decode([EntryJsonData].self, from: data)
            
            decodedData.forEach({ item in
                moodLogs.append(MoodLog(
                    id: item.entry._id,
                    dateTime: DateFormat.ISOToDate(dateStr: item.entry.dateTime),
                    moodValue: item.entry.moodValue,
                    tags: item.entry.tags,
                    note: item.entry.note)
                )
            })
            return moodLogs
            
        } catch {
            print(error)
            return nil
        }
    }
    
    func encodeEntry(_ moodLog: MoodLog) -> Data? {
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
            
            return decodedData.entry._id
//            return MoodLog(
//                id: decodedData.entry._id,
//                dateTime: DateFormat.ISOToDate(dateStr: decodedData.entry.dateTime),
//                moodValue: decodedData.entry.moodValue,
//                tags: decodedData.entry.tags,
//                note: decodedData.entry.note
//            )
        } catch {
            print(error)
            return nil
        }
    }
}
