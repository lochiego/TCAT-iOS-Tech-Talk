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


// Task

public class Task: Note, Equatable {
    public let id: NSUUID
    private var properties: [String:AnyObject] = [:]
    public var name: String {
        get {
            return properties[Constants.Task.NAME] as! String
        }
    }
    public var description: String {
        get {
            return properties[Constants.Task.DESCRIPTION] as! String
        }
    }
    public var deadline: NSDate? {
        get {
            return properties[Constants.Task.DEADLINE] as! NSDate?
        }
    }
    public var urgent: Bool {
        get {
            return properties[Constants.Task.URGENT] as! Bool
        }
    }
    public var important: Bool {
        get {
            return properties[Constants.Task.IMPORTANT] as! Bool
        }
    }

    public init(id: NSUUID = NSUUID(), name: String = "", description: String = "", deadline: NSDate? = nil, urgent: Bool = false, important: Bool = false) {
        self.id = id
        self.properties[Constants.Task.NAME] = name
        self.properties[Constants.Task.DESCRIPTION] = description
        self.properties[Constants.Task.DEADLINE] = deadline
        self.properties[Constants.Task.URGENT] = urgent
        self.properties[Constants.Task.IMPORTANT] = important
    }
    
}

public func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}
