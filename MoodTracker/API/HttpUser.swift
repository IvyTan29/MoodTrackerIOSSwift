//
//  HttpUser.swift
//  MoodTracker
//
//  Created by Ivy Tan on 8/3/22.
//

import Foundation

protocol HttpUserDelegate : AnyObject {
    func didRegister(_ statusCode: Int, _ strData: String)
    
    func didLogin(_ statusCode: Int, _ strData: String)
}

// PARA THE DELEGATE DOES NOT NEED TO INHERIT EVERY FUNCTION
extension HttpUserDelegate {
    func didRegister(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
    
    func didLogin(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
}

struct HttpUser {
    
    let encoder = JSONEncoder()
    weak var delegate: HttpUserDelegate?

    func registerUserHTTP(_ user: User) {
        if let url = URL(string: "\(Server.url)/user") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let json = encodeUser(user)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
            
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didRegister(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                }
            }
            task.resume()
        }
    }
    
    func loginUserHTTP(_ login: Login) {
        if let url = URL(string: "\(Server.url)/user/login") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let json = encodeLogin(login)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
            
            // this is asynchronous
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    delegate?.didLogin(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                }
            }
            task.resume()
        }
    }
    
    func encodeUser(_ user: User) -> Data? {
        do {
            return try encoder.encode(user)
        } catch {
            print(error)
            return nil
        }
    }
    
    func encodeLogin(_ login: Login) -> Data? {
        do {
            return try encoder.encode(login)
        } catch {
            print(error)
            return nil
        }
    }
}
