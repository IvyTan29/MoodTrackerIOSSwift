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
    
    func didGetInsightTags(_ statusCode: Int, _ insightTags: [TagCountJsonData])
    
    func didAddTags(_ statusCode: Int, _ strData: String)
    
    func didEditTags(_ statusCode: Int, _ strData: String, _ indexPath: IndexPath)
}

extension HttpTagDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<Tag>) {
        // leave empty
    }
    
    func didGetTableTags(_ statusCode: Int, _ tags: Set<Tag>) {
        // leave empty
    }
    
    func didGetInsightTags(_ statusCode: Int, _ insightTags: [TagCountJsonData]) {
        // leave empty
    }
    
    func didAddTags(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
    
    func didEditTags(_ statusCode: Int, _ strData: String, _ indexPath: IndexPath){
        // leave empty
    }
}

struct HttpTag {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    weak var delegate: HttpTagDelegate?
    
    func getRecentTagsHttp() {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/recent/tags",
            httpMethod: "GET",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let recentTags = decodeTag(data, 1) {
                            delegate?.didGetRecentTags(response.statusCode, recentTags)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
//                        self.dismiss(animated: true)
                    }
                    
                }
            }
    }
    
    func getTableTagsHttp() {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/table/tags",
            httpMethod: "GET",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let tableTags = decodeTag(data, 0) {
                            delegate?.didGetTableTags(response.statusCode, tableTags)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
//                        self.dismiss(animated: true)
                    }
                }
            }
    }
    
    func getAllInsightsTagHttp(moodValue: Float) {
        // MOODLEVEL
        let floorVal = floor(moodValue)
        let ceilVal = ceil(moodValue)
        
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/insightAll/tags?floorMoodValue=\(floorVal)&ceilMoodValue=\(ceilVal)",
            httpMethod: "GET",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let insightTags = decodeTagCount(data) {
                            delegate?.didGetInsightTags(response.statusCode, insightTags)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
//                        self.dismiss(animated: true)
                    }
                }
            }
    }
    
    func getInsightsTagWithDateRangeHttp(insightDateType: Int, moodValue: Float) {
        // MOODLEVEL
        let floorVal = floor(moodValue)
        let ceilVal = ceil(moodValue)
        
        // DATES CODE
        let todayStartDate = Calendar.current.startOfDay(for: Date())
        let todayStartDateSec = todayStartDate.timeIntervalSince1970 // para time is 12:00 AM
        let todayComponents = Calendar.current.dateComponents([.weekday], from: todayStartDate)
        let oneDaySec = 24*60*60*1.0
        
        let thisWeekSundaySec = todayStartDateSec - ((Double(todayComponents.weekday ?? 0) - 1) * oneDaySec)
        let components = Calendar.current.dateComponents([.year, .month], from: todayStartDate)
        let thisMonthStartDate = Calendar.current.date(from: components) ?? Date()
        
        let fromDateSec = { () -> Double in
            switch insightDateType {
            case 0: // this week
                return thisWeekSundaySec
            case 1: // last week
                return thisWeekSundaySec - 7 * oneDaySec // minus 7 days
            case 2: // last month
                let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: thisMonthStartDate) ?? Date()
                return lastMonthDate.timeIntervalSince1970
            default:
                return thisWeekSundaySec
            }
        }()

        let toDateSec = { () -> Double in
            switch insightDateType {
            case 0: // this week
                return thisWeekSundaySec + 7 * oneDaySec
            case 1: // last week
                return thisWeekSundaySec
            case 2: // last month
                return thisMonthStartDate.timeIntervalSince1970
            default:
                return thisWeekSundaySec
            }
        }()
        
        if #available(iOS 15.0, *) {
            print(Date(timeIntervalSince1970: fromDateSec).formatted())
            print(Date(timeIntervalSince1970: toDateSec).formatted())
        }
        
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/insight/tags?fromDate=\(fromDateSec)&toDate=\(toDateSec)&floorMoodValue=\(floorVal)&ceilMoodValue=\(ceilVal)",
            httpMethod: "GET",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        if let insightTags = decodeTagCount(data) {
                            delegate?.didGetInsightTags(response.statusCode, insightTags)
                        }
                    } else {
                        print(String(data: data, encoding: .utf8))
//                        self.dismiss(animated: true)
                    }
                }
            }
    }
    
    func postTagsToUserAndEntryHttp(_ entryId: String, _ tagArray: [TagJsonData]) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entry/\(entryId)/tags",
            httpMethod: "POST",
            jsonData: encodeTagSet(tagArray),
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didAddTags(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                }
            }
    }
    
    func putTagsToUserAndEntryHttp(_ entryId: String, _ tagArray: [TagJsonData], _ indexPath: IndexPath) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/entry/\(entryId)/tags",
            httpMethod: "PUT",
            jsonData: encodeTagSet(tagArray),
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didEditTags(response.statusCode, String(data: data, encoding: .utf8) ?? "", indexPath)
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
    
    func decodeTagCount(_ data: Data) -> [TagCountJsonData]? {
        do {
            let decodedData = try decoder.decode([TagCountJsonData].self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
