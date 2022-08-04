//
//  NetworkHelper.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

struct NetworkHelper {
    static let BASE_URL = "http://localhost:8080"
    
    static func performDataTask(urlString: String,
                                httpMethod: String,
                                jsonData: Data?,
                                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            
            if let jsonData = jsonData {
                print("WENT HERE IN NETWORK HELPER")
                request.addValue("application/json", forHTTPHeaderField: "content-type")
                request.httpBody = jsonData
            }
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
            task.resume()
        }
    }
}
