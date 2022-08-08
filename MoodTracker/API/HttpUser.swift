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
    
    func didLogout(_ statusCode: Int, _ strData: String)
    
    func didHaveError(strData: String)
}

// PARA THE DELEGATE DOES NOT NEED TO INHERIT EVERY FUNCTION
extension HttpUserDelegate {
    func didRegister(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
    
    func didLogin(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
    
    func didLogout(_ statusCode: Int, _ strData: String) {
        // leave empty
    }
}

struct HttpUser {
    
    let encoder = JSONEncoder()
    weak var delegate: HttpUserDelegate?

    func registerUserHttp(_ user: UserJsonData) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user",
            httpMethod: "POST",
            jsonData: encodeUser(user),
            authorization: nil) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        delegate?.didRegister(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                    } else {
                        delegate?.didHaveError(strData: String(data: data, encoding: .utf8) ?? "")
                    }
                }
            }
    }
    
    func loginUserHttp(_ login: LoginJsonData) {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/login",
            httpMethod: "POST",
            jsonData: encodeLogin(login),
            authorization: nil) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        delegate?.didLogin(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                    } else {
                        delegate?.didHaveError(strData: String(data: data, encoding: .utf8) ?? "")
                    }
                    
                }
            }
    }
    
    func logOutUserHttp() {
        NetworkHelper.performDataTask(
            urlString: "\(NetworkHelper.BASE_URL)/user/logout",
            httpMethod: "POST",
            jsonData: nil,
            authorization: moodStore.state.jwtClient) { data, response, error in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse, let data = data {
                    if NetworkHelper.goodStatusResponseCode.contains(response.statusCode) {
                        delegate?.didLogout(response.statusCode, String(data: data, encoding: .utf8) ?? "")
                    } else {
                        delegate?.didHaveError(strData: "Logging out encountered some issues.")
                    }
                }
            }
    }
    
    func encodeUser(_ user: UserJsonData) -> Data? {
        do {
            return try encoder.encode(user)
        } catch {
            print(error)
            return nil
        }
    }
    
    func encodeLogin(_ login: LoginJsonData) -> Data? {
        do {
            return try encoder.encode(login)
        } catch {
            print(error)
            return nil
        }
    }
}
