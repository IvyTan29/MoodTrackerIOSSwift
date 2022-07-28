//
//  Fetch.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/28/22.
//

import Foundation
import RxSwift

func httpPost() {
    print("TEST RUN")
    let url = URL(
        string: "https://discord.com/api/webhooks/1002121201751183392/Jlo25kTxCtheUgUmFIqm5K4ofIOjJ7xEYjKU83Bvlm0qZIEjohixMOR4QjKQkj2SFsrs"
    )!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST" // get post put
    request.addValue("application/json", forHTTPHeaderField: "content-type")
//    request.addValue("Bearer ssffsdfsdf", forHTTPHeaderField: "Authorization")
    
    request.httpBody = "{\"content\": \"IOS is fun (hopefully)\"}".data(using: .utf8)
    
    // this is asynchronous
    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        
        print("IM HERE")
        if let error = error {
            print("Error took place \(error)")
            return
        }
        
        // Read HTTP Response Status code
        // 200 ok
        if let response = response as? HTTPURLResponse {
            print("Response HTTP Status code: \(response.statusCode)")
        }
        
        if let data = data {
            print(String(data: data, encoding: .utf8))
        }
    }
    
    task.resume()
}
