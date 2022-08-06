//
//  HttpEntry.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

protocol HttpEntryDelegate : AnyObject {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog], _ dateType: DateType, _ fromDate: Date)
    
    func didAddEntry(_ statusCode: Int, _ entryJsonData: EntryJsonData)
    
    func didEditEntry(_ statusCode: Int, _ entryJsonData: EntryJsonData, _ indexPath: IndexPath)
}

extension HttpEntryDelegate {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog], _ dateType: DateType, _ fromDate: Date) {
        // leave empty
    }
    
    func didAddEntry(_ statusCode: Int, _ entryJsonData: EntryJsonData) {
        // leave empty
    }
    
    func didEditEntry(_ statusCode: Int, _ entryJsonData: EntryJsonData, _ indexPath: IndexPath) {
        // leave empty
    }
}

struct HttpEntry {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    weak var delegate: HttpEntryDelegate?
    
    func getEntriesOfUserHTTP(dateType: DateType, fromDate: Date) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries",
            httpMethod: "GET",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let entries = decodeEntries(data) {
                            delegate?.didGetEntries(response.statusCode, entries, dateType, fromDate)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
                    }
                }
            }
    }
    
    func getEntriesWithDateRangeHTTP(dateType: DateType, fromDate: Date) {
        let fromDateMS = fromDate.timeIntervalSince1970
        let oneDayMS = 24*60*60*1.0
        
        if #available(iOS 15.0, *) {
            print(fromDate.formatted())
        }
        
        let toDateMS = { () -> Double in
            switch dateType {
            case .dayControl:
                return fromDateMS + oneDayMS
            case .weekControl:
                return fromDateMS + 7 * oneDayMS
            case .monthControl:
                var  comp = DateComponents()
                comp.month = 1
                comp.day = -1
                var temp = Calendar.current.date(byAdding: comp, to: fromDate) ?? Date()
                return temp.advanced(by: oneDayMS).timeIntervalSince1970
            default:
                return fromDateMS
            }
        }()
        
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries/dateRange?fromDate=\(fromDateMS)&toDate=\(toDateMS)",
            httpMethod: "GET",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let entries = decodeEntries(data) {
                            delegate?.didGetEntries(response.statusCode, entries, dateType, fromDate)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
                    }
                }
            }
    }
    
    func postEntryHTTP(_ entry: MoodLog) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries",
            httpMethod: "POST",
            jsonData: encodeEntry(entry),
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let entryJson = decodeAnEntry(data) {
                            delegate?.didAddEntry(response.statusCode, entryJson)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
//                        self.dismiss(animated: true)
                    }
                }
            }
    }
    
    func putEntryHTTP(_ indexPath: IndexPath, _ entry: MoodLog) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entries/\(moodStore.state.filterMoodList[indexPath.row].id ?? "")",
            httpMethod: "PUT",
            jsonData: encodeEntry(entry),
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let entryJson = decodeAnEntry(data) {
                            delegate?.didEditEntry(response.statusCode, entryJson, indexPath)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
//                        self.dismiss(animated: true)
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
                        dateTime: item.dateTime,
                        moodValue: item.moodValue,
                        tags: self.getTagSet(item.tags),
                        note: note)
                    )
                } catch {
                    print(error)
                    moodLogs.append(MoodLog(
                        id: item._id,
                        dateTime: item.dateTime,
                        moodValue: item.moodValue,
                        tags: self.getTagSet(item.tags))
                    )
                }
            })
            
            return moodLogs
        } catch {
            print(error)
            return nil
        }
    }
    
    func getTagSet(_ tags: [TagJsonData]) -> Set<Tag> {
        var tagStr = Set<Tag>()
        
        tags.forEach({ tagItem in
            tagStr.insert(Tag(
                name: tagItem.name,
                recent: tagItem.recent)
            )
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
    
    func decodeAnEntry(_ data: Data) -> EntryJsonData? {
        do {
            return try decoder.decode(EntryJsonData.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
