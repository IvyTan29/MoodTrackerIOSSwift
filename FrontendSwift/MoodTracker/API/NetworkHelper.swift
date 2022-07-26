//
//  NetworkHelper.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

struct NetworkHelper {
    static let BASE_URL = "http://localhost:8080"
    static let goodStatusResponseCode = 200..<299
    
    static func performDataTask(urlString: String,
                                httpMethod: String,
                                jsonData: Data?,
                                authorization: String?,
                                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        print("\(httpMethod) \(urlString)")
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            
            if let jsonData = jsonData {
                request.addValue("application/json", forHTTPHeaderField: "content-type")
                request.httpBody = jsonData
            }
            
            if let jwt = authorization {
                request.addValue(jwt, forHTTPHeaderField: "authorization")
            }
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
            task.resume()
        }
    }
}
