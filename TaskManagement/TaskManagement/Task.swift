/*******************************************************************************
* Copyright © 2007-15, All Rights Reserved.
* Texas Center for Applied Technology
* Texas A&M Engineering Experiment Station
* The Texas A&M University System
* College Station, Texas, USA 77843
*
* Use is granted only to authorized licensee.
* Proprietary information, not for redistribution.
******************************************************************************/

import Foundation

let NAME = "name"
let DESCRIPTION = "description"
let DEADLINE = "deadline"
let URGENT = "urgent"
let IMPORTANT = "important"

// Task

public class Task: Note, Equatable {
    private let id: NSUUID
    private var properties: [String:Any] = [:]
    public var name: String {
        get {
            return properties[NAME] as! String
        }
    }
    public var description: String {
        get {
            return properties[DESCRIPTION] as! String
        }
    }
    public var deadline: NSDate? {
        get {
            return properties[DEADLINE] as! NSDate?
        }
    }
    public var urgent: Bool {
        get {
            return properties[URGENT] as! Bool
        }
    }
    public var important: Bool {
        get {
            return properties[IMPORTANT] as! Bool
        }
    }

    public init(id: NSUUID = NSUUID(), name: String = "", description: String = "", deadline: NSDate? = nil, urgent: Bool = false, important: Bool = false) {
        self.id = id
        self.properties[NAME] = name
        self.properties[DESCRIPTION] = description
        self.properties[DEADLINE] = deadline
        self.properties[URGENT] = urgent
        self.properties[IMPORTANT] = important
    }
    
}

public func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}
