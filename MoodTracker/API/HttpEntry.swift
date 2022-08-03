//
//  HttpEntry.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

protocol HttpEntryDelegate : AnyObject {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog])
}

extension HttpEntryDelegate {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog]) {
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
            
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if let entries = decodeEntries(data) {
                        print("IN HERE")
                        delegate?.didGetEntries(response.statusCode, entries)
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
}
