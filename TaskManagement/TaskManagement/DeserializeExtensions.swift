//
//  DeserializeExtensions.swift
//  TaskManagement
//
//  Created by Graham Booker on 6/7/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import Foundation
import Argo

extension NSData: Decodable {
    public static func decode(j: JSON) -> Decoded<NSData> {
        switch j {
        case let .String(s):
            var data = NSData(base64EncodedString: s, options: NSDataBase64DecodingOptions(rawValue: 0))
            if let concreteData = data {
                return pure(concreteData)
            }
            return .TypeMismatch("\(j) is not a valid base64 String")
        default: return .TypeMismatch("\(j) is not a String")
        }
    }
}

extension NSUUID: Decodable {
    public static func decode(j: JSON) -> Decoded<NSUUID> {
        switch j {
        case let .String(s):
            var uuid = NSUUID(UUIDString: s)
            if let concreteUUID = uuid {
                return pure(concreteUUID)
            }
            return .TypeMismatch("\(j) is not a UUID String")
        default: return .TypeMismatch("\(j) is not a String")
        }
    }
}

extension NSDate: Decodable {
    public static func decode(j: JSON) -> Decoded<NSDate> {
        switch j {
        case let .Number(n): return pure(NSDate(timeIntervalSince1970: n.doubleValue))
        default: return .TypeMismatch("\(j) is not a long")
        }
    }
}