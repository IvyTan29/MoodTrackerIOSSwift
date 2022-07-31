//
//  JsonUtil.swift
//  Tutorial
//
//  Created by Mini on 7/28/22.
//

import Foundation

struct SerializationError : Error {
    
}

class JsonUtil {
    
    open class func stringify(dictionary: [String: Any]) -> String {

        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [ ]) else {
                throw SerializationError()
            }

            guard let string = String(data: jsonData, encoding: .utf8) else {
                throw SerializationError()
            }

            return string
        }
        catch (let error) {

            print(error)
        }
        return ""
    }
    
    open class func parseJSON<R>(string: String) -> R? {
        
        do {
            guard let data = string.data(using: .utf8) else {
                throw SerializationError()
            }
            
            guard let object = try? JSONSerialization.jsonObject(with: data, options: [ .allowFragments ]) as? R else {
                throw SerializationError()
            }
            
            return object
        }
        catch (let error) {
            print(error)
        }

        return nil
    }
    
}

func example() {
    let dict : [String : Any] = [
        "content" : "Hello World!"
    ]
    
    let jsonstring = JsonUtil.stringify(dictionary: dict)
    print(jsonstring)
    
    
    let dict2 : [String : Any] = JsonUtil.parseJSON(string: jsonstring) ?? [:]
    print(dict2)
}

