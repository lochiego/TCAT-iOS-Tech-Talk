//
//  Serializable.swift
//  TaskManagement
//
//  Created by Graham Booker on 6/5/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import Foundation

public protocol SpecificSerializable {
    var jsonProperties: Dictionary<String, AnyObject> {get}
}

public protocol PrimitiveSerializable {
    var jsonValue: AnyObject {get}
}

public struct Serialize {
    static func isJsonPrimitive(obj: Any) -> Bool {
        if  obj is String ||
            obj is Int ||
            obj is Double ||
            obj is Float ||
            obj is Bool {
                return true
        }
        return false
    }
    
    static func getJsonValue(value: Any) -> AnyObject {
        if isJsonPrimitive(value) {
            return value as! AnyObject
        }
        if let prim = value as? PrimitiveSerializable {
            return prim.jsonValue
        }
        if let array = value as? NSArray {
            var primArray = Array<AnyObject>()
            for obj in array {
                primArray.append(getJsonValue(obj))
            }
            return primArray
        }
        if let dict = value as? NSDictionary {
            var primDict = Dictionary<String, AnyObject>()
            var successful = true
            for (key, value) in dict {
                if let strKey = key as? String {
                    primDict[strKey] = getJsonValue(value)
                }
                else {
                    successful = false
                    break
                }
            }
            if successful {
                return primDict
            }
        }
        return toDictionary(value)
    }
    
    static func unwrap(any: Any) -> Any? {
        let mirror = reflect(any)
        if mirror.disposition != .Optional {
            return any
        }
        
        if mirror.count == 0 {
            return nil
        }
        
        let (_, some) = mirror[0]
        return some.value
    }
    
    static func toDictionary(obj: Any) -> NSDictionary {
        var dict: Dictionary<String, AnyObject> = [:]
        
        var values: Dictionary<String, Any>
        if let ss = obj as? SpecificSerializable {
            values = ss.jsonProperties
        }
        else {
            values = [:]
            var mirror = reflect(obj)
            for i in 0..<(mirror.count) {
                let (propName, mirrorChild) = mirror[i]
                if let propValue = unwrap(mirrorChild.value) {
                    values[propName] = propValue
                }
            }
        }
        
        for (key, value) in values {
            dict[key] = getJsonValue(value)
        }
        
        return dict
    }
    
    public static func toJson(obj: Any) -> NSData {
        var dictionary = toDictionary(obj)
        
        var err: NSError?
        if let json = NSJSONSerialization.dataWithJSONObject(dictionary, options:NSJSONWritingOptions(0), error: &err) {
            return json
        }
        else {
            let error = err?.description ?? "nil"
            NSLog("ERROR: Unable to serialize json, error: %@", error)
            NSNotificationCenter.defaultCenter().postNotificationName("CrashlyticsLogNotification", object: nil, userInfo: ["string": "unable to serialize json, error: \(error)"])
            abort()
        }
    }
}