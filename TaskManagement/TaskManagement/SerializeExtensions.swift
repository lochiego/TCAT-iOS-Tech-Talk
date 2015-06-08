//
//  SerializeExtensions.swift
//  TaskManagement
//
//  Created by Graham Booker on 6/7/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import Foundation

extension NSData: PrimitiveSerializable {
    public var jsonValue: AnyObject { get { return self.base64EncodedDataWithOptions(nil) } }
}

extension NSUUID: PrimitiveSerializable {
    public var jsonValue: AnyObject { get { return self.UUIDString } }
}

extension NSDate: PrimitiveSerializable {
    public var jsonValue: AnyObject { get { return self.timeIntervalSinceReferenceDate } }
}
